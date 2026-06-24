const mongoose = require('mongoose');

const weightEntrySchema = new mongoose.Schema({
  weight: { type: Number, required: true },
  date:   { type: String, required: true },   // "yyyy-MM-dd"
}, { _id: false });

const foodLogEntrySchema = new mongoose.Schema({
  foodName: { type: String, required: true },
  grams:    { type: Number, required: true },
  calories: { type: Number, required: true },
  protein:  { type: Number, required: true },
  carbs:    { type: Number, required: true },
  fat:      { type: Number, required: true },
  time:     { type: String, required: true },  // "HH:mm"
  date:     { type: String, required: true },  // "yyyy-MM-dd"
}, { _id: false });

const userSchema = new mongoose.Schema({
  username:               { type: String, required: true, unique: true, lowercase: true, trim: true },
  password:               { type: String, required: true },   // bcrypt hash
  name:                   { type: String, required: true },
  age:                    { type: Number, required: true },
  weight:                 { type: Number, required: true },
  height:                 { type: Number, required: true },
  gender:                 { type: String, required: true, enum: ['male', 'female'] },
  activityLevel:          { type: String, required: true },
  goal:                   { type: String, required: true },
  caloriesConsumedToday:  { type: Number, default: 0 },
  lastActiveDate:         { type: String, default: '' },
  weightLog:              { type: [weightEntrySchema], default: [] },
  foodLog:                { type: [foodLogEntrySchema], default: [] },
  walletBalance:          { type: Number, default: 0 },
  planType:               { type: String, default: 'free' },
  proExpiryDate:          { type: String, default: '' },
}, { timestamps: true });

module.exports = mongoose.model('User', userSchema);
