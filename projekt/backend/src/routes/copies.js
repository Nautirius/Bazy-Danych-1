const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    // Pobierz wszystkie egzemplarze (z widoku)
    router.get('/', async (req, res) => {
        try {
            const egzemplarze = await db.query('SELECT * FROM biblioteka.widok_egzemplarzy;');
            res.json(egzemplarze.rows);
        } catch (error) {
            console.error('Błąd pobierania egzemplarzy:', error);
            res.status(500).send('Błąd pobierania egzemplarzy.');
        }
    });

    // Pobierz wszystkie dostepne egzemplarze (z widoku)
    router.get('/available', async (req, res) => {
        try {
            const egzemplarze = await db.query("SELECT * FROM biblioteka.widok_egzemplarzy WHERE stan='dostępny';");
            res.json(egzemplarze.rows);
        } catch (error) {
            console.error('Błąd pobierania egzemplarzy:', error);
            res.status(500).send('Błąd pobierania egzemplarzy.');
        }
    });

    // Dodaj nowy egzemplarz
    router.post('/', async (req, res) => {
        const { id_wydania, stan, id_lokalizacji } = req.body;

        try {
            await db.query(
                `INSERT INTO biblioteka.egzemplarze (id_wydania, stan, id_lokalizacji)
                 VALUES ($1, $2, $3);`,
                [id_wydania, stan, id_lokalizacji || null]
            );
            res.status(201).send('Egzemplarz został dodany.');
        } catch (error) {
            console.error('Błąd dodawania egzemplarza:', error);
            res.status(500).send('Błąd dodawania egzemplarza.');
        }
    });

    // Edytuj egzemplarz
    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { id_wydania, stan, id_lokalizacji } = req.body;

        try {
            await db.query(
                `UPDATE biblioteka.egzemplarze
                 SET id_wydania = $1, stan = $2, id_lokalizacji = $3
                 WHERE id_egzemplarza = $4;`,
                [id_wydania, stan, id_lokalizacji || null, id]
            );
            res.send('Egzemplarz został zaktualizowany.');
        } catch (error) {
            console.error('Błąd edycji egzemplarza:', error);
            res.status(500).send('Błąd edycji egzemplarza.');
        }
    });

    // Usuń egzemplarz
    router.delete('/:id', async (req, res) => {
        const { id } = req.params;

        try {
            await db.query(`DELETE FROM biblioteka.egzemplarze WHERE id_egzemplarza = $1;`, [id]);
            res.send('Egzemplarz został usunięty.');
        } catch (error) {
            console.error('Błąd usuwania egzemplarza:', error);
            res.status(500).send('Błąd usuwania egzemplarza.');
        }
    });

    return router;
};
