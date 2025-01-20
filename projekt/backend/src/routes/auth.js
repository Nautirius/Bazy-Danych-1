const express = require("express");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");
const { body, validationResult } = require("express-validator");


module.exports = (db, JWT_SECRET) => {
    const router = express.Router();

    router.post(
        "/register",
        [
        //     body("email").isEmail().withMessage("Nieprawidłowy email"),
        //     body("imie").notEmpty().withMessage("Imię jest wymagane"),
        //     body("nazwisko").notEmpty().withMessage("Nazwisko jest wymagane"),
        //     body("pesel").isLength({min: 11, max: 11}).withMessage("PESEL musi mieć 11 znaków"),
            body("haslo").isLength({min: 6}).withMessage("Hasło musi mieć co najmniej 6 znaków"),
        ],
        async (req, res) => {
            const errors = validationResult(req);
            if (!errors.isEmpty()) {
                return res.status(400).json({errors: errors.array()});
            }

            const {
                imie,
                nazwisko,
                data_urodzin,
                pesel,
                kraj,
                miejscowosc,
                ulica,
                numer_domu,
                kod_pocztowy,
                telefon,
                email,
                haslo
            } = req.body;

            try {
                // Check whether email or PESEL already exists
                const userExists = await db.query("SELECT * FROM biblioteka.czytelnicy WHERE email = $1 OR pesel = $2", [email, pesel]);
                if (userExists.rows.length > 0) {
                    return res.status(400).json({error: "Email lub PESEL już istnieje"});
                }

                // password encryption
                const hashedPassword = await bcrypt.hash(haslo, 10);

                // add a reader to the database
                const newReader = await db.query(
                    `INSERT INTO biblioteka.czytelnicy (imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica,
                                                        numer_domu, kod_pocztowy, telefon, email, haslo)
                     VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
                     RETURNING *`,
                    [imie, nazwisko, data_urodzin, pesel, kraj, miejscowosc, ulica, numer_domu, kod_pocztowy, telefon, email, hashedPassword]
                );

                res.status(201).json(newReader.rows[0]);
            } catch (error) {
                console.error(error.message);
                res.status(500).send("Błąd serwera");
            }
        }
    );

    router.post("/login", async (req, res) => {
        const {email, haslo} = req.body;

        try {
            // find the reader by email value
            const user = await db.query("SELECT * FROM biblioteka.czytelnicy WHERE email = $1", [email]);
            if (user.rows.length === 0) {
                return res.status(400).json({error: "Nieprawidłowy email lub hasło"});
            }

            // compare passwords
            const validPassword = await bcrypt.compare(haslo, user.rows[0].haslo);
            if (!validPassword) {
                return res.status(400).json({error: "Nieprawidłowy email lub hasło"});
            }

            // const result = await db.query("SELECT verify_login_credentials($1, $2) AS valid", [email, haslo]);
            // if (!result.rows[0].valid) {
            //     return res.status(400).json({ error: "Nieprawidłowy email lub hasło" });
            // }

            // generate JWT
            const token = jwt.sign({id: user.rows[0].id_czytelnika}, JWT_SECRET, {expiresIn: "1h"});
            res.json({token, user: user.rows[0]});
        } catch (error) {
            console.error(error.message);
            res.status(500).send("Błąd serwera");
        }
    });

    router.post("/verify", async (req, res) => {
        const { token } = req.body;

        if (!token) {
            return res.status(400).json({ error: "Token jest wymagany" });
        }

        try {
            const decoded = jwt.verify(token, JWT_SECRET);
            const user = await db.query("SELECT * FROM biblioteka.czytelnicy WHERE id_czytelnika = $1", [decoded.id]);

            if (user.rows.length === 0) {
                return res.status(404).json({ error: "Użytkownik nie znaleziony" });
            }

            res.json({ user: user.rows[0] });
        } catch (error) {
            console.error("Błąd weryfikacji tokena:", error.message);
            res.status(401).json({ error: "Token jest nieprawidłowy lub wygasł" });
        }
    });


    return router;
}
