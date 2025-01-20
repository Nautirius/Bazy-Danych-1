const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const rentals = await db.query('SELECT * FROM biblioteka.widok_wypozyczen');
            res.json(rentals.rows);
        } catch (error) {
            console.error('Error fetching rentals:', error);
            res.status(500).json({error: 'Failed to fetch rentals. Please try again later.'});
        }
    });

    router.get('/user/:id', async (req, res) => {
        try {
            const { id } = req.params;
            const rental = await db.query('SELECT * FROM biblioteka.widok_wypozyczen WHERE id_czytelnika = $1', [id]);
            res.json(rental.rows);
        } catch (error) {
            console.error('Error fetching rental:', error);
            res.status(500).json({error: 'Failed to fetch rental. Please try again later.'});
        }
    });

    router.post('/', async (req, res) => {
        const { id_czytelnika, id_egzemplarza, status, data_wypozyczenia, data_zwrotu } = req.body;
        try {
            await db.query(
                'INSERT INTO biblioteka.wypozyczenia (id_czytelnika, id_egzemplarza, status, data_wypozyczenia, data_zwrotu) VALUES ($1, $2, $3, $4, $5)',
                [id_czytelnika, id_egzemplarza, status, data_wypozyczenia, data_zwrotu ? data_zwrotu : null]
            );
            res.status(201).json({message: 'Wypożyczenie dodane.'});
        } catch (error) {
            console.error('Error creating rental:', error);
            res.status(500).json({error: 'Failed to create rental. Please try again later.'});
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { id_czytelnika, id_egzemplarza, status, data_wypozyczenia, data_zwrotu } = req.body;

        try {
            await db.query(
                'UPDATE biblioteka.wypozyczenia SET id_czytelnika = $1, id_egzemplarza = $2, status = $3, data_wypozyczenia = $4, data_zwrotu = $5 WHERE id_wypozyczenia = $6',
                [id_czytelnika, id_egzemplarza, status, data_wypozyczenia, data_zwrotu, id]
            );
            res.json({message: 'Wypożyczenie zaktualizowane.'});
        } catch (error) {
            console.error('Error updating rental:', error);
            res.status(500).json({error: 'Failed to update rental. Please try again later.'});
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;

        try {
            await db.query('DELETE FROM biblioteka.wypozyczenia WHERE id_wypozyczenia = $1', [id]);
            res.json({message: 'Wypożyczenie usunięte.'});
        } catch (error) {
            console.error('Error deleting rental:', error);
            res.status(500).json({error: 'Failed to delete rental. Please try again later.'});
        }
    });

    return router;
};
