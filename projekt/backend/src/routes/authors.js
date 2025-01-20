const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const authors = await db.query('SELECT * FROM biblioteka.autorzy');
            res.json(authors.rows);
        } catch (err) {
            res.status(500).send('Błąd pobierania autorów');
        }
    });

    router.post('/', async (req, res) => {
        const { imie, nazwisko, pseudonim, rok_urodzenia, kraj_pochodzenia, notka_biograficzna } = req.body;
        try {
            await db.query(
                `INSERT INTO biblioteka.autorzy (imie, nazwisko, pseudonim, rok_urodzenia, kraj_pochodzenia, notka_biograficzna)
       VALUES ($1, $2, $3, $4, $5, $6)`,
                [imie, nazwisko, pseudonim, rok_urodzenia, kraj_pochodzenia, notka_biograficzna]
            );
            res.status(201).send('Autor dodany pomyślnie');
        } catch (err) {
            res.status(500).send('Błąd dodawania autora');
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { imie, nazwisko, pseudonim, rok_urodzenia, kraj_pochodzenia, notka_biograficzna } = req.body;
        try {
            await db.query(
                `UPDATE biblioteka.autorzy
       SET imie = $1, nazwisko = $2, pseudonim = $3, rok_urodzenia = $4, kraj_pochodzenia = $5, notka_biograficzna = $6
       WHERE id_autora = $7`,
                [imie, nazwisko, pseudonim, rok_urodzenia, kraj_pochodzenia, notka_biograficzna, id]
            );
            res.send('Autor zaktualizowany pomyślnie');
        } catch (err) {
            res.status(500).send('Błąd edytowania autora');
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;
        try {
            await db.query(`DELETE FROM biblioteka.autorzy WHERE id_autora = $1`, [id]);
            res.send('Autor usunięty pomyślnie');
        } catch (err) {
            res.status(500).send('Błąd usuwania autora');
        }
    });

    return router;
};

