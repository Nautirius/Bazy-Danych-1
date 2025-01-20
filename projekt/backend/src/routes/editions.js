const express = require('express');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

module.exports = (db) => {
    const router = express.Router();

    // Configure multer for file uploads
    const upload = multer({
        dest: 'uploads/covers/',
        limits: {fileSize: 5 * 1024 * 1024}, // 5MB limit
    });

    // Helper to generate cover file path
    function generateCoverPath(idKsiazki, idWydania, extension) {
        return `uploads/covers/book_${idKsiazki}_publication_${idWydania}${extension}`;
    }

    // Route to get all wydania using a database view
    router.get('/', async (req, res) => {
        try {
            const wydania = await db.query('SELECT * FROM biblioteka.widok_wydania');
            res.json(wydania.rows);
        } catch (error) {
            console.error('Error fetching wydania:', error);
            res.status(500).json({error: 'Failed to fetch wydania. Please try again later.'});
        }
    });

    router.get('/ranking/reviews', async (req, res) => {
        try {
            const wydania = await db.query('SELECT * FROM biblioteka.widok_wydania ORDER BY srednia_ocen DESC');
            res.json(wydania.rows);
        } catch (error) {
            console.error('Error fetching wydania:', error);
            res.status(500).json({error: 'Failed to fetch wydania. Please try again later.'});
        }
    });

    router.get('/ranking/rentals', async (req, res) => {
        try {
            const wydania = await db.query('SELECT * FROM biblioteka.widok_wydania ORDER BY liczba_wypozyczen DESC');
            res.json(wydania.rows);
        } catch (error) {
            console.error('Error fetching wydania:', error);
            res.status(500).json({error: 'Failed to fetch wydania. Please try again later.'});
        }
    });

    router.get('/:id', async (req, res) => {
        try {
            const {id} = req.params;
            const wydania = await db.query('SELECT * FROM biblioteka.widok_wydania WHERE id_wydania = $1', [id]);
            res.json(wydania.rows[0]);
        } catch (error) {
            console.error('Error fetching wydanie:', error);
            res.status(500).json({error: 'Failed to fetch wydanie. Please try again later.'});
        }
    });

    router.get('/check-availability/:id', async (req, res) => {
        try {
            const {id} = req.params;
            // const wydania = await db.query('SELECT * FROM biblioteka.sprawdz_dostepne_egzemplarze()', [id]);
            const available = await db.query(
                'SELECT * FROM biblioteka.sprawdz_dostepne_egzemplarze($1)',
                [id]
            );
            res.json(available.rows[0]);
        } catch (error) {
            console.error('Error checking availability:', error);
            res.status(500).json({error: 'Failed to check availability. Please try again later.'});
        }
    });

    router.post('/', upload.single('okladka'), async (req, res) => {
        const {id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron} = req.body;
        const file = req.file;

        try {
            const result = await db.query(
                'INSERT INTO biblioteka.wydania (id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron) VALUES ($1, $2, $3, $4, $5) RETURNING id_wydania',
                [id_ksiazki, id_wydawnictwa || null, rok_wydania, jezyk, liczba_stron]
            );
            const id_wydania = result.rows[0].id_wydania;

            let coverPath = 'uploads/covers/default_cover.png';
            if (file) {
                const extension = path.extname(file.originalname);
                coverPath = generateCoverPath(id_ksiazki, id_wydania, extension);
                fs.renameSync(file.path, coverPath);
            }

            await db.query('UPDATE biblioteka.wydania SET sciezka_do_okladki = $1 WHERE id_wydania = $2', [coverPath, id_wydania]);
            res.status(201).json({message: 'Wydanie added successfully.'});
        } catch (error) {
            console.error('Error adding wydanie:', error);
            if (file) fs.unlinkSync(file.path); // Clean up uploaded file
            res.status(500).json({error: 'Failed to add wydanie. Please try again later.'});
        }
    });

    router.put('/:id', upload.single('okladka'), async (req, res) => {
        const {id} = req.params;
        const {id_ksiazki, id_wydawnictwa, rok_wydania, jezyk, liczba_stron} = req.body;
        const file = req.file;

        try {
            const wydanie = await db.query('SELECT * FROM biblioteka.wydania WHERE id_wydania = $1', [id]);
            if (!wydanie.rows.length) {
                if (file) fs.unlinkSync(file.path);
                return res.status(404).json({error: 'Wydanie not found.'});
            }

            let coverPath = wydanie.rows[0].sciezka_do_okladki;
            if (file) {
                const extension = path.extname(file.originalname);
                coverPath = generateCoverPath(id_ksiazki, id, extension);
                if (fs.existsSync(coverPath)) fs.unlinkSync(coverPath); // Remove old cover
                fs.renameSync(file.path, coverPath);
            }

            await db.query(
                'UPDATE biblioteka.wydania SET id_ksiazki = $1, id_wydawnictwa = $2, rok_wydania = $3, jezyk = $4, liczba_stron = $5, sciezka_do_okladki = $6 WHERE id_wydania = $7',
                [id_ksiazki, id_wydawnictwa || null, rok_wydania, jezyk, liczba_stron, coverPath, id]
            );
            res.json({message: 'Wydanie updated successfully.'});
        } catch (error) {
            console.error('Error updating wydanie:', error);
            if (file) fs.unlinkSync(file.path); // Clean up uploaded file
            res.status(500).json({error: 'Failed to update wydanie. Please try again later.'});
        }
    });

    router.delete('/:id', async (req, res) => {
        const {id} = req.params;

        try {
            const wydanie = await db.query('SELECT * FROM biblioteka.wydania WHERE id_wydania = $1', [id]);
            if (!wydanie.rows.length) return res.status(404).json({error: 'Wydanie not found.'});

            const coverPath = wydanie.rows[0].sciezka_do_okladki;
            if (coverPath && coverPath !== './default.jpg' && fs.existsSync(coverPath)) {
                fs.unlinkSync(coverPath);
            }

            await db.query('DELETE FROM biblioteka.wydania WHERE id_wydania = $1', [id]);
            res.json({message: 'Wydanie deleted successfully.'});
        } catch (error) {
            console.error('Error deleting wydanie:', error);
            res.status(500).json({error: 'Failed to delete wydanie. Please try again later.'});
        }
    });

    return router;
}
