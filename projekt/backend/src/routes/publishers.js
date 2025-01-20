const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const result = await db.query('SELECT * FROM biblioteka.wydawnictwa');
            res.json(result.rows);
        } catch (error) {
            console.error('Błąd podczas pobierania wydawnictw:', error);
            res.status(500).json({ error: 'Błąd serwera podczas pobierania wydawnictw.' });
        }
    });

    router.post('/', async (req, res) => {
        const { nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email } = req.body;
        try {
            const result = await db.query(
                `INSERT INTO biblioteka.wydawnictwa 
                (nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email)
                VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
                [nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email]
            );
            res.status(201).json(result.rows[0]);
        } catch (error) {
            console.error('Błąd podczas dodawania wydawnictwa:', error);
            res.status(500).json({ error: 'Błąd serwera podczas dodawania wydawnictwa.' });
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email } = req.body;
        try {
            const result = await db.query(
                `UPDATE biblioteka.wydawnictwa 
                SET nazwa = $1, kraj = $2, miejscowosc = $3, ulica = $4, numer_domu = $5, kod_pocztowy = $6, telefon = $7, email = $8
                WHERE id_wydawnictwa = $9 RETURNING *`,
                [nazwa, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email, id]
            );
            if (result.rowCount === 0) {
                return res.status(404).json({ error: 'Wydawnictwo o podanym ID nie istnieje.' });
            }
            res.json(result.rows[0]);
        } catch (error) {
            console.error('Błąd podczas aktualizacji wydawnictwa:', error);
            res.status(500).json({ error: 'Błąd serwera podczas aktualizacji wydawnictwa.' });
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;
        try {
            const result = await db.query('DELETE FROM biblioteka.wydawnictwa WHERE id_wydawnictwa = $1 RETURNING *', [id]);
            if (result.rowCount === 0) {
                return res.status(404).json({ error: 'Wydawnictwo o podanym ID nie istnieje.' });
            }
            res.json({ message: 'Wydawnictwo zostało usunięte.' });
        } catch (error) {
            console.error('Błąd podczas usuwania wydawnictwa:', error);
            res.status(500).json({ error: 'Błąd serwera podczas usuwania wydawnictwa.' });
        }
    });

    return router;
}
