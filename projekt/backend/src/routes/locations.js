const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const locations = await db.query('SELECT * FROM biblioteka.lokalizacje');
            res.json(locations.rows);
        } catch (err) {
            console.error(err);
            res.status(500).send('Błąd pobierania lokalizacji');
        }
    });

    router.post('/', async (req, res) => {
        const { numer_polki, opis } = req.body;
        try {
            await db.query(
                `INSERT INTO biblioteka.lokalizacje (numer_polki, opis) VALUES ($1, $2)`,
                [numer_polki, opis]
            );
            res.status(201).send('Lokalizacja dodana pomyślnie');
        } catch (err) {
            console.error(err);
            res.status(500).send('Błąd dodawania lokalizacji');
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { numer_polki, opis } = req.body;
        try {
            await db.query(
                `UPDATE biblioteka.lokalizacje SET numer_polki = $1, opis = $2 WHERE id_lokalizacji = $3`,
                [numer_polki, opis, id]
            );
            res.send('Lokalizacja zaktualizowana pomyślnie');
        } catch (err) {
            console.error(err);
            res.status(500).send('Błąd edytowania lokalizacji');
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;
        try {
            await db.query(`DELETE FROM biblioteka.lokalizacje WHERE id_lokalizacji = $1`, [id]);
            res.send('Lokalizacja usunięta pomyślnie');
        } catch (err) {
            console.error(err);
            res.status(500).send('Błąd usuwania lokalizacji');
        }
    });

    return router;
};
