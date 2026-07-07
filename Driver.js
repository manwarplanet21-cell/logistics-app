const { DataTypes } = require('sequelize');
const sequelize = require('../config/database');

const Driver = sequelize.define('Driver', {
  name: { type: DataTypes.STRING, allowNull: false },
  phone: { type: DataTypes.STRING, allowNull: true },
  isAvailable: { type: DataTypes.BOOLEAN, defaultValue: true },
  location: { type: DataTypes.GEOMETRY('POINT', 4326), allowNull: true },
});

module.exports = Driver;
