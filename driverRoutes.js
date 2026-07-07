const express = require('express');
const Driver = require('../models/Driver');
const { findNearestDriver } = require('../services/dispatchService');

const router = express.Router();

router.post('/', async (req, res) => {
  const driver = await Driver.create(req.body);
  res.status(201).json({ success: true, driver });
});

router.get('/', async (req, res) => {
  const drivers = await Driver.findAll({ order: [['id', 'ASC']] });
  res.json({ success: true, drivers });
});

router.post('/nearest', async (req, res) => {
  const { pickupLat, pickupLng, maxDistanceMeters } = req.body;
  const driver = await findNearestDriver(pickupLat, pickupLng, maxDistanceMeters || 5000);
  res.json({ success: !!driver, driver });
});

module.exports = router;
