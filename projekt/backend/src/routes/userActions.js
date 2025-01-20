const express = require("express");

module.exports = (db) => {
    const router = express.Router();
    router.post("/rent", async (req, res) => {
        const { id_wydania, id_czytelnika } = req.body;

        if (!id_wydania || !id_czytelnika) {
            return res.status(400).json({ error: "Wymagane parametry: id_wydania, id_czytelnika" });
        }

        try {
            await db.query("SELECT biblioteka.wypozycz_egzemplarz($1, $2)", [id_wydania, id_czytelnika]);
            res.status(200).json({ message: "Wypożyczenie zakończone sukcesem." });
        } catch (error) {
            console.error("Błąd wypożyczenia:", error.message);
            res.status(500).json({ error: "Nie udało się wypożyczyć egzemplarza." });
        }
    });

    router.post("/reserve", async (req, res) => {
        const { id_czytelnika, id_wydania } = req.body;

        if (!id_czytelnika || !id_wydania) {
            return res.status(400).json({ error: "Wymagane parametry: id_czytelnika, id_wydania" });
        }

        try {
            await db.query("SELECT biblioteka.zarezerwuj_wydanie($1, $2)", [id_czytelnika, id_wydania]);
            res.status(200).json({ message: "Rezerwacja zakończona sukcesem." });
        } catch (error) {
            console.error("Błąd rezerwacji:", error.message);
            res.status(500).json({ error: "Nie udało się zarezerwować wydania." });
        }
    });


    router.post("/rate", async (req, res) => {
        const { id_ksiazki, id_czytelnika, ocena, komentarz } = req.body;

        if (!id_ksiazki || !id_czytelnika || !ocena) {
            return res.status(400).json({ error: "Wymagane parametry: id_ksiazki, id_czytelnika, ocena" });
        }

        try {
            await db.query(
                `INSERT INTO biblioteka.oceny (id_ksiazki, id_czytelnika, ocena, komentarz)
             VALUES ($1, $2, $3, $4)
             ON CONFLICT (id_ksiazki, id_czytelnika)
             DO UPDATE SET ocena = $3, komentarz = $4`,
                [id_ksiazki, id_czytelnika, ocena, komentarz || null]
            );
            res.status(200).json({ message: "Ocena została zapisana." });
        } catch (error) {
            console.error("Błąd zapisu oceny:", error.message);
            res.status(500).json({ error: "Nie udało się zapisać oceny." });
        }
    });

    router.get("/rating", async (req, res) => {
        const { id_ksiazki, id_czytelnika } = req.query;

        if (!id_ksiazki || !id_czytelnika) {
            return res.status(400).json({ error: "Wymagane parametry: id_ksiazki, id_czytelnika" });
        }

        try {
            const result = await db.query(
                `SELECT ocena, komentarz FROM biblioteka.oceny WHERE id_ksiazki = $1 AND id_czytelnika = $2`,
                [id_ksiazki, id_czytelnika]
            );
            res.status(200).json(result.rows[0] || null);
        } catch (error) {
            console.error("Błąd pobierania oceny:", error.message);
            res.status(500).json({ error: "Nie udało się pobrać oceny." });
        }
    });

    router.delete("/rate", async (req, res) => {
        const { id_ksiazki, id_czytelnika } = req.body;

        if (!id_ksiazki || !id_czytelnika) {
            return res.status(400).json({ error: "Wymagane parametry: id_ksiazki, id_czytelnika" });
        }

        try {
            await db.query(`DELETE FROM biblioteka.oceny WHERE id_ksiazki = $1 AND id_czytelnika = $2`, [
                id_ksiazki,
                id_czytelnika,
            ]);
            res.status(200).json({ message: "Ocena została usunięta." });
        } catch (error) {
            console.error("Błąd usuwania oceny:", error.message);
            res.status(500).json({ error: "Nie udało się usunąć oceny." });
        }
    });

    return router;
}
