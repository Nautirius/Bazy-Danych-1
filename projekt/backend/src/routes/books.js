const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const books = await db.query('SELECT * FROM biblioteka.widok_ksiazek;');
            res.json(books.rows);
        } catch (error) {
            console.error('Błąd pobierania książek:', error);
            res.status(500).send('Błąd pobierania książek.');
        }
    });

    router.get('/ranking/most-popular', async (req, res) => {
        try {
            const books = await db.query('SELECT * FROM biblioteka.widok_najbardziej_popularne_ksiazki;');
            res.json(books.rows);
        } catch (error) {
            console.error('Błąd pobierania książek:', error);
            res.status(500).send('Błąd pobierania książek.');
        }
    });

    router.get('/reviews/:id', async (req, res) => {
        const { id } = req.params;

        try {
            const reviewsQuery = `
            SELECT 
                o.id_oceny,
                o.ocena,
                o.komentarz,
                o.data_dodania,
                c.imie,
                c.nazwisko
            FROM 
                biblioteka.oceny o
            JOIN 
                biblioteka.czytelnicy c ON o.id_czytelnika = c.id_czytelnika
            WHERE 
                o.id_ksiazki = $1
            ORDER BY 
                o.data_dodania DESC;
        `;

            const { rows: reviews } = await db.query(reviewsQuery, [id]);
            res.status(200).json(reviews);
        } catch (error) {
            console.error('Error fetching reviews:', error.message);
            res.status(500).json({ error: 'Nie udało się pobrać opinii.' });
        }
    });

    router.post('/', async (req, res) => {
        const { tytul, jezyk_oryginalu, id_kategorii, opis, authors } = req.body;

        try {
            await db.query(
                'SELECT biblioteka.dodaj_ksiazke($1, $2, $3, $4, $5)',
                [tytul, jezyk_oryginalu, id_kategorii || null, opis, authors]
            );
            res.status(201).json({ message: 'Książka została dodana.' });
        } catch (err) {
            console.error(err.message);
            res.status(500).json({ error: 'Błąd podczas dodawania książki.' });
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { tytul, jezyk_oryginalu, id_kategorii, opis, authors } = req.body;

        try {
            await db.query(
                `UPDATE biblioteka.ksiazki
                 SET tytul = $1, jezyk_oryginalu = $2, id_kategorii = $3, opis = $4
                 WHERE id_ksiazki = $5;`,
                [tytul, jezyk_oryginalu, id_kategorii || null, opis, id]
            );

            await db.query(`DELETE FROM biblioteka.ksiazki_autorzy WHERE id_ksiazki = $1;`, [id]);

            if (authors && authors.length > 0) {
                const authorInserts = authors.map((idAutora) =>
                    db.query(
                        `INSERT INTO biblioteka.ksiazki_autorzy (id_ksiazki, id_autora) VALUES ($1, $2);`,
                        [id, idAutora]
                    )
                );
                await Promise.all(authorInserts);
            }

            res.send('Książka została zaktualizowana.');
        } catch (error) {
            console.error('Błąd edycji książki:', error);
            res.status(500).send('Błąd edycji książki.');
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;

        try {
            await db.query(`DELETE FROM biblioteka.ksiazki_autorzy WHERE id_ksiazki = $1;`, [id]);
            await db.query(`DELETE FROM biblioteka.ksiazki WHERE id_ksiazki = $1;`, [id]);

            res.send('Książka została usunięta.');
        } catch (error) {
            console.error('Błąd usuwania książki:', error);
            res.status(500).send('Błąd usuwania książki.');
        }
    });

    return router;
};
