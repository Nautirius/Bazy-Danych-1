const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const path = require('path');
const { Pool } = require('pg');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 5000;

const JWT_SECRET = process.env.JWT_SECRET;

app.use(cors());
app.use(bodyParser.json());
app.use(express.static('../../frontend/build'));

const db = new Pool({
    connectionString: process.env.DATABASE_URL,
    max: 20, // Maksymalna liczba połączeń
    idleTimeoutMillis: 30000, // Maksymalny czas bezczynności połączenia (w ms)
    connectionTimeoutMillis: 2000, // Maksymalny czas na nawiązanie nowego połączenia (w ms)
})

db.on('error', (err) => {
    console.error('Błąd puli połączeń:', err);
});

// API routes
const dziedzinyRoutes = require('./routes/categories');
app.use('/api/categories', dziedzinyRoutes(db));

const authorsRoutes = require('./routes/authors');
app.use('/api/authors', authorsRoutes(db));

const booksRoutes = require('./routes/books');
app.use('/api/books', booksRoutes(db));

const publishersRouter = require('./routes/publishers');
app.use('/api/publishers', publishersRouter(db));

const editionsRouter = require('./routes/editions');
app.use('/api/editions', editionsRouter(db));

const locationsRouter = require('./routes/locations');
app.use('/api/locations', locationsRouter(db));

const copiesRouter = require('./routes/copies');
app.use('/api/copies', copiesRouter(db));

const readersRouter = require('./routes/readers');
app.use('/api/readers', readersRouter(db));

const rentalsRouter = require('./routes/rentals');
app.use('/api/rentals', rentalsRouter(db));

const reservationsRouter = require('./routes/reservations');
app.use('/api/reservations', reservationsRouter(db));

const authRouter = require('./routes/auth');
app.use('/api/auth', authRouter(db, JWT_SECRET));

const userActionsRouter = require('./routes/userActions');
app.use('/api/user-actions', userActionsRouter(db));

app.use('/api/uploads/covers', express.static(path.join(__dirname, './uploads/covers')));


app.get('*', (req, res) => {
    res.sendFile(path.join(__dirname, '../../frontend/build/index.html'));
});


app.listen(PORT, () => {
    console.log(`Server listening on the port ${PORT}`);
});