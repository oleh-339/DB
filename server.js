const express = require('express');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();
app.use(express.json());

// Пул підключень до бази даних
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// 1. CREATE - Створення користувача
app.post('/api/users', async (req, res) => {
    const { nickname, email } = req.body;
    try {
        const [result] = await pool.execute(
            'INSERT INTO users (nickname, email) VALUES (?, ?)',
            [nickname, email]
        );
        res.status(201).json({ id: result.insertId, nickname, email });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 2. READ - Отримання всіх користувачів
app.get('/api/users', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT * FROM users');
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 3. UPDATE - Оновлення користувача за ID
app.put('/api/users/:id', async (req, res) => {
    const { id } = req.params;
    const { nickname, email } = req.body;
    try {
        await pool.execute(
            'UPDATE users SET nickname = ?, email = ? WHERE id = ?',
            [nickname, email, id]
        );
        res.json({ message: 'Дані користувача оновлено', id, nickname, email });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 4. DELETE - Видалення користувача за ID
app.delete('/api/users/:id', async (req, res) => {
    const { id } = req.params;
    try {
        await pool.execute('DELETE FROM users WHERE id = ?', [id]);
        res.json({ message: 'Користувача видалено', id });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Сервер запущено на http://localhost:${PORT}`);
});

// 5. Вивід даних зі сторони зв'язку M:1 (Сторіс + Автор)
app.get('/api/stories/details', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT s.id AS story_id, s.media_url, s.media_type, u.nickname, u.email 
            FROM stories s
            JOIN users u ON s.user_id = u.id
        `);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 6. Вивід даних зі стикувальної таблиці M:M (Підписки: Хто на кого підписаний)
app.get('/api/followers/details', async (req, res) => {
    try {
        const [rows] = await pool.query(`
            SELECT 
                u1.nickname AS follower_nickname, 
                u2.nickname AS followed_nickname
            FROM followers f
            JOIN users u1 ON f.follower_id = u1.id
            JOIN users u2 ON f.followed_id = u2.id
        `);
        res.json(rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});