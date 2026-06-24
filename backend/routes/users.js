const router = require('express').Router();
const User   = require('../models/User');

function todayStr() {
  const n = new Date();
  const y = n.getFullYear();
  const m = String(n.getMonth() + 1).padStart(2, '0');
  const d = String(n.getDate()).padStart(2, '0');
  return `${y}-${m}-${d}`;
}

function _safe(user) {
  const obj = user.toObject();
  delete obj.password;
  return obj;
}

// GET /api/users/:username  — fetch full user profile
router.get('/:username', async (req, res) => {
  try {
    const user = await User.findOne({ username: req.params.username.toLowerCase() });
    if (!user) return res.status(404).json({ error: 'User not found.' });

    // Reset daily calories if new day
    const today = todayStr();
    if (user.lastActiveDate !== today) {
      user.caloriesConsumedToday = 0;
      user.lastActiveDate = today;
      await user.save();
    }

    res.json(_safe(user));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT /api/users/:username  — replace entire user profile (sent from Flutter on save)
router.put('/:username', async (req, res) => {
  try {
    const allowed = [
      'name', 'age', 'weight', 'height', 'gender',
      'activityLevel', 'goal', 'caloriesConsumedToday',
      'lastActiveDate', 'weightLog', 'foodLog',
      'walletBalance', 'planType', 'proExpiryDate',
    ];

    const update = {};
    for (const key of allowed) {
      if (req.body[key] !== undefined) update[key] = req.body[key];
    }

    const user = await User.findOneAndUpdate(
      { username: req.params.username.toLowerCase() },
      { $set: update },
      { new: true }
    );
    if (!user) return res.status(404).json({ error: 'User not found.' });

    res.json(_safe(user));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/users/:username/food  — append a food log entry
router.post('/:username/food', async (req, res) => {
  try {
    const { foodName, grams, calories, protein, carbs, fat, time, date } = req.body;
    if (!foodName || grams == null || calories == null) {
      return res.status(400).json({ error: 'foodName, grams, and calories are required.' });
    }

    const entry = {
      foodName,
      grams:    Number(grams),
      calories: Number(calories),
      protein:  Number(protein  ?? 0),
      carbs:    Number(carbs    ?? 0),
      fat:      Number(fat      ?? 0),
      time:     time ?? '',
      date:     date ?? todayStr(),
    };

    const user = await User.findOneAndUpdate(
      { username: req.params.username.toLowerCase() },
      {
        $push: { foodLog: entry },
        $inc:  { caloriesConsumedToday: entry.calories },
      },
      { new: true }
    );
    if (!user) return res.status(404).json({ error: 'User not found.' });

    res.status(201).json(_safe(user));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST /api/users/:username/weight  — append a weight log entry
router.post('/:username/weight', async (req, res) => {
  try {
    const { weight, date } = req.body;
    if (weight == null) return res.status(400).json({ error: 'weight is required.' });

    const user = await User.findOneAndUpdate(
      { username: req.params.username.toLowerCase() },
      {
        $push: { weightLog: { weight: Number(weight), date: date ?? todayStr() } },
        $set:  { weight: Number(weight) },
      },
      { new: true }
    );
    if (!user) return res.status(404).json({ error: 'User not found.' });

    res.status(201).json(_safe(user));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE /api/users/:username/food — clear today's food log
router.delete('/:username/food', async (req, res) => {
  try {
    const today = todayStr();
    const user = await User.findOneAndUpdate(
      { username: req.params.username.toLowerCase() },
      {
        $pull: { foodLog: { date: today } },
        $set:  { caloriesConsumedToday: 0 },
      },
      { new: true }
    );
    if (!user) return res.status(404).json({ error: 'User not found.' });
    res.json(_safe(user));
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
