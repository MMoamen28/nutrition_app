const router = require('express').Router();
const bcrypt = require('bcryptjs');
const User   = require('../models/User');

function todayStr() {
  const n = new Date();
  const y = n.getFullYear();
  const m = String(n.getMonth() + 1).padStart(2, '0');
  const d = String(n.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

// POST /api/auth/register
router.post('/register', async (req, res) => {
  try {
    const { username, password, name, age, weight, height, gender, activityLevel, goal } = req.body;

    if (!username || !password || !name || !age || !weight || !height || !gender || !activityLevel || !goal) {
      return res.status(400).json({ error: 'All fields are required.' });
    }

    const exists = await User.findOne({ username: username.toLowerCase() });
    if (exists) return res.status(409).json({ error: 'Username already exists.' });

    const hash  = await bcrypt.hash(password, 10);
    const today = todayStr();

    const user = await User.create({
      username:      username.toLowerCase(),
      password:      hash,
      name,
      age:           Number(age),
      weight:        Number(weight),
      height:        Number(height),
      gender,
      activityLevel,
      goal,
      lastActiveDate: today,
      weightLog:     [{ weight: Number(weight), date: today }],
    });

    res.status(201).json({ message: 'User created.', user: _safe(user) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/auth/login
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;
    if (!username || !password) return res.status(400).json({ error: 'Username and password are required.' });

    const user = await User.findOne({ username: username.toLowerCase() });
    if (!user) return res.status(401).json({ error: 'Invalid credentials.' });

    const match = await bcrypt.compare(password, user.password);
    if (!match) return res.status(401).json({ error: 'Invalid credentials.' });

    // Reset daily calories if new day
    const today = todayStr();
    if (user.lastActiveDate !== today) {
      user.caloriesConsumedToday = 0;
      user.lastActiveDate = today;
      await user.save();
    }

    res.json({ message: 'Login successful.', user: _safe(user) });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Returns user document without the password hash
function _safe(user) {
  const obj = user.toObject();
  delete obj.password;
  return obj;
}

module.exports = router;
