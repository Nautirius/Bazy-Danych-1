const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const reservations = await db.query('SELECT * FROM biblioteka.widok_rezerwacji');
            res.json(reservations.rows);
        } catch (error) {
            console.error('Error fetching reservations:', error);
            res.status(500).json({ error: 'Failed to fetch reservations. Please try again later.' });
        }
    });

    router.get('/user/:id', async (req, res) => {
        try {
            const { id } = req.params;
            const reservation = await db.query('SELECT * FROM biblioteka.widok_rezerwacji WHERE id_czytelnika = $1', [id]);
            res.json(reservation.rows);
        } catch (error) {
            console.error('Error fetching reservation:', error);
            res.status(500).json({ error: 'Failed to fetch reservation details.' });
        }
    });

    router.post('/', async (req, res) => {
        try {
            const { id_czytelnika, id_wydania, data_rezerwacji } = req.body;
            const newReservation = await db.query(`INSERT INTO biblioteka.rezerwacje (id_czytelnika, id_wydania, data_rezerwacji)
                    VALUES ($1, $2, $3) RETURNING *`,
                [id_czytelnika, id_wydania, data_rezerwacji]
            );
            res.json(newReservation.rows[0]);
        } catch (error) {
            console.error('Error creating reservation:', error);
            res.status(500).json({ error: 'Failed to create reservation.' });
        }
    });

    router.put('/:id', async (req, res) => {
        try {
            const { id } = req.params;
            const { id_czytelnika, id_wydania, data_rezerwacji } = req.body;
            const updatedReservation = await db.query(`UPDATE biblioteka.rezerwacje
                SET id_czytelnika = $1, id_wydania = $2, data_rezerwacji = $4
                WHERE id_rezerwacji = $5 RETURNING *`,
                [id_czytelnika, id_wydania, data_rezerwacji, id]
            );
            res.json(updatedReservation.rows[0]);
        } catch (error) {
            console.error('Error updating reservation:', error);
            res.status(500).json({ error: 'Failed to update reservation.' });
        }
    });

    router.delete('/:id', async (req, res) => {
        try {
            const { id } = req.params;
            await db.query('DELETE FROM biblioteka.rezerwacje WHERE id_rezerwacji = $1', [id]);
            res.status(204).send();
        } catch (error) {
            console.error('Error deleting reservation:', error);
            res.status(500).json({ error: 'Failed to delete reservation.' });
        }
    });

    return router;
};
