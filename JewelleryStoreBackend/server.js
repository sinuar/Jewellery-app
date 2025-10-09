const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');

const app = express();
app.use(cors());
app.use(bodyParser.json());


// User and catalogue data (in-memory for simplicity)
const users = [];
const catalogue = [
  { id: 1, name: 'Diamond Ring', price: 1200 },
  { id: 2, name: 'Gold Necklace', price: 800 },
  { id: 3, name: 'Silver Bracelet', price: 300 }
];

const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const SECRET = 'your_jwt_secret';

// Signup
app.post('/signup', (req, res) => {
  const { username, password } = req.body;
  if (users.find(u => u.username === username)) {
    return res.json({ success: false, message: 'User already exists.' });
  }
  const hashedPassword = bcrypt.hashSync(password, 8);
  users.push({ username, password: hashedPassword });
  const token = jwt.sign({ username }, SECRET, { expiresIn: '1h' });
  res.json({ success: true, token });
});

// Login
app.post('/login', (req, res) => {
  const { username, password } = req.body;
  const user = users.find(u => u.username === username);
  if (!user || !bcrypt.compareSync(password, user.password)) {
    return res.json({ success: false, message: 'Invalid credentials.' });
  }
  const token = jwt.sign({ username }, SECRET, { expiresIn: '1h' });
  res.json({ success: true, token });
});

// Catalogue Endpoint
app.get('/catalogue', (req, res) => {
  res.json(catalogue);
});

// Start server
const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

