const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const pool = new Pool({
  host: process.env.DB_HOST || 'postgres-service',
  port: parseInt(process.env.DB_PORT) || 5432,
  database: process.env.DB_NAME || 'postgres',
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASSWORD || 'postgres',
  connectionTimeoutMillis: 5000,
  idleTimeoutMillis: 10000,
  max: 10,
});

const QUOTES = [
  { text: "The only way to do great work is to love what you do.", author: "Steve Jobs" },
  { text: "In the middle of every difficulty lies opportunity.", author: "Albert Einstein" },
  { text: "It does not matter how slowly you go as long as you do not stop.", author: "Confucius" },
  { text: "Life is what happens when you're busy making other plans.", author: "John Lennon" },
  { text: "The future belongs to those who believe in the beauty of their dreams.", author: "Eleanor Roosevelt" },
  { text: "Success is not final, failure is not fatal: it is the courage to continue that counts.", author: "Winston Churchill" },
  { text: "You miss 100% of the shots you don't take.", author: "Wayne Gretzky" },
  { text: "Whether you think you can or you think you can't, you're right.", author: "Henry Ford" },
  { text: "Strive not to be a success, but rather to be of value.", author: "Albert Einstein" },
  { text: "Two roads diverged in a wood, and I took the one less traveled by.", author: "Robert Frost" },
  { text: "I am not a product of my circumstances. I am a product of my decisions.", author: "Stephen Covey" },
  { text: "The best time to plant a tree was 20 years ago. The second best time is now.", author: "Chinese Proverb" },
  { text: "An unexamined life is not worth living.", author: "Socrates" },
  { text: "Spread love everywhere you go. Let no one ever come to you without leaving happier.", author: "Mother Teresa" },
  { text: "When you reach the end of your rope, tie a knot in it and hang on.", author: "Franklin D. Roosevelt" },
  { text: "Always remember that you are absolutely unique. Just like everyone else.", author: "Margaret Mead" },
  { text: "Do not go where the path may lead, go instead where there is no path and leave a trail.", author: "Ralph Waldo Emerson" },
  { text: "You will face many defeats in life, but never let yourself be defeated.", author: "Maya Angelou" },
  { text: "The greatest glory in living lies not in never falling, but in rising every time we fall.", author: "Nelson Mandela" },
  { text: "In the end, it's not the years in your life that count. It's the life in your years.", author: "Abraham Lincoln" },
];

async function waitForDb(retries = 10, delay = 3000) {
  for (let i = 0; i < retries; i++) {
    try {
      const client = await pool.connect();
      await client.query('SELECT 1');
      client.release();
      console.log('✅ Database connection established');
      return true;
    } catch (err) {
      console.log(`⏳ Waiting for database... attempt ${i + 1}/${retries} - ${err.message}`);
      await new Promise(r => setTimeout(r, delay));
    }
  }
  throw new Error('Could not connect to database after retries');
}

async function seedDatabase() {
  const client = await pool.connect();
  try {
    await client.query(`
      CREATE TABLE IF NOT EXISTS quotes (
        id SERIAL PRIMARY KEY,
        text TEXT NOT NULL,
        author VARCHAR(255) NOT NULL,
        created_at TIMESTAMP DEFAULT NOW()
      )
    `);

    const { rows } = await client.query('SELECT COUNT(*) FROM quotes');
    if (parseInt(rows[0].count) === 0) {
      console.log('🌱 Seeding quotes into database...');
      for (const q of QUOTES) {
        await client.query(
          'INSERT INTO quotes (text, author) VALUES ($1, $2)',
          [q.text, q.author]
        );
      }
      console.log(`✅ Seeded ${QUOTES.length} quotes`);
    } else {
      console.log(`📚 Database already has ${rows[0].count} quotes`);
    }
  } finally {
    client.release();
  }
}

app.get('/health', async (req, res) => {
  try {
    await pool.query('SELECT 1');
    res.json({ status: 'ok', db: 'connected', timestamp: new Date().toISOString() });
  } catch (err) {
    res.status(503).json({ status: 'error', db: 'disconnected', message: err.message });
  }
});

app.get('/ready', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT COUNT(*) FROM quotes');
    if (parseInt(rows[0].count) > 0) {
      res.json({ status: 'ready', quotes: rows[0].count });
    } else {
      res.status(503).json({ status: 'not ready', reason: 'no quotes in db' });
    }
  } catch (err) {
    res.status(503).json({ status: 'not ready', message: err.message });
  }
});

app.get('/api/quote', async (req, res) => {
  try {
    const { rows } = await pool.query(
      'SELECT id, text, author FROM quotes ORDER BY RANDOM() LIMIT 1'
    );
    if (rows.length === 0) {
      return res.status(404).json({ error: 'No quotes found' });
    }
    res.json(rows[0]);
  } catch (err) {
    console.error('Error fetching quote:', err.message);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/quotes', async (req, res) => {
  try {
    const { rows } = await pool.query('SELECT id, text, author FROM quotes ORDER BY id');
    res.json({ quotes: rows, total: rows.length });
  } catch (err) {
    res.status(500).json({ error: 'Internal server error' });
  }
});

async function start() {
  try {
    await waitForDb();
    await seedDatabase();
    app.listen(PORT, '0.0.0.0', () => {
      console.log(`🚀 Backend API running on port ${PORT}`);
    });
  } catch (err) {
    console.error('Fatal startup error:', err.message);
    process.exit(1);
  }
}

start();