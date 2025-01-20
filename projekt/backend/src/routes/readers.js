const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const readers = await db.query('SELECT * FROM biblioteka.widok_czytelnicy');
            res.json(readers.rows);
        } catch (err) {
            res.status(500).send('Błąd pobierania czytelników');
        }
    });

    router.get('/ranking/rentals', async (req, res) => {
        try {
            const readers = await db.query('SELECT * FROM biblioteka.widok_czytelnicy ORDER BY liczba_wypozyczen DESC');
            res.json(readers.rows);
        } catch (err) {
            res.status(500).send('Błąd pobierania czytelników');
        }
    });

    router.get('/ranking/penalties', async (req, res) => {
        try {
            const readers = await db.query('SELECT * FROM biblioteka.widok_czytelnicy ORDER BY suma_kar DESC');
            res.json(readers.rows);
        } catch (err) {
            res.status(500).send('Błąd pobierania czytelników');
        }
    });

    router.post('/', async (req, res) => {
        const { imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email } = req.body;
        try {
            await db.query(
                `INSERT INTO biblioteka.czytelnicy (imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email)
                 VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
                [imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email]
            );
            res.status(201).send('Czytelnik dodany pomyślnie');
        } catch (err) {
            res.status(500).send(`Błąd dodawania czytelnika: ${err.message}`);
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email } = req.body;
        try {
            await db.query(
                `UPDATE biblioteka.czytelnicy
                 SET imie = $1, nazwisko = $2, data_urodzin = $3, pesel = $4, kraj = $5, miejscowosc = $6, ulica = $7, numer_domu = $8, kod_pocztowy = $9, telefon = $10, email = $11
                 WHERE id_czytelnika = $12`,
                [imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email, id]
            );
            res.send('Czytelnik zaktualizowany pomyślnie');
        } catch (err) {
            res.status(500).send(`Błąd edytowania czytelnika: ${err.message}`);
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;
        try {
            await db.query('DELETE FROM biblioteka.czytelnicy WHERE id_czytelnika = $1', [id]);
            res.send('Czytelnik usunięty pomyślnie');
        } catch (err) {
            res.status(500).send(`Błąd usuwania czytelnika: ${err.message}`);
        }
    });

    return router;
};
