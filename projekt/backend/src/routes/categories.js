const express = require('express');

module.exports = (db) => {
    const router = express.Router();

    router.get('/', async (req, res) => {
        try {
            const result = await db.query('SELECT * FROM biblioteka.hierarchia_kategorii');
            res.status(200).json(result.rows);
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Error getting category' });
        }
    });

    router.post('/', async (req, res) => {
        const { nazwa, id_kategorii_nadrzednej } = req.body;
        try {
            const result = await db.query(
                'INSERT INTO biblioteka.kategorie (nazwa, id_kategorii_nadrzednej) VALUES ($1, $2) RETURNING *',
                [nazwa, id_kategorii_nadrzednej]
            );
            res.status(201).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Error adding category' });
        }
    });

    router.put('/:id', async (req, res) => {
        const { id } = req.params;
        const { nazwa, id_kategorii_nadrzednej } = req.body;
        try {
            const result = await db.query(
                'UPDATE biblioteka.kategorie SET nazwa = $1, id_kategorii_nadrzednej = $2 WHERE id_kategorii = $3 RETURNING *',
                [nazwa, id_kategorii_nadrzednej, id]
            );
            if (result.rowCount === 0) {
                return res.status(404).json({ error: 'Category not found' });
            }
            res.status(200).json(result.rows[0]);
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Error editing category' });
        }
    });

    router.delete('/:id', async (req, res) => {
        const { id } = req.params;
        try {
            const result = await db.query('DELETE FROM biblioteka.kategorie WHERE id_kategorii = $1 RETURNING *', [id]);
            if (result.rowCount === 0) {
                return res.status(404).json({ error: 'Category not found' });
            }
            res.status(200).json({ message: 'Kategoria usunięta' });
        } catch (error) {
            console.error(error);
            res.status(500).json({ error: 'Error deleting category' });
        }
    });

    return router;
};
