const { QueryTypes } = require('sequelize');
const sequelize = require('../config/database');
const Driver = require('../models/Driver');

async function findNearestDriver(pickupLat, pickupLng, maxDistanceMeters = 5000) {
  const drivers = await sequelize.query(`
    SELECT id, name, phone, "isAvailable",
      ST_Distance(location::geography, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography) AS distance
    FROM "Drivers"
    WHERE "isAvailable" = true
      AND location IS NOT NULL
      AND ST_DWithin(location::geography, ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography, :maxDistance)
    ORDER BY distance ASC
    LIMIT 1;
  `, {
    replacements: { lat: pickupLat, lng: pickupLng, maxDistance: maxDistanceMeters },
    type: QueryTypes.SELECT,
  });
  return drivers.length ? drivers[0] : null;
}

async function updateDriverLocation(driverId, lat, lng) {
  return Driver.update({ location: { type: 'Point', coordinates: [lng, lat] } }, { where: { id: driverId } });
}

module.exports = { Driver, findNearestDriver, updateDriverLocation };
