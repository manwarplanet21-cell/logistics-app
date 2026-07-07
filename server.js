const express = require('express');
const http = require('http');
const cors = require('cors');
const helmet = require('helmet');
const { Server } = require('socket.io');
require('dotenv').config();

const sequelize = require('./config/database');
const Driver = require('./models/Driver');
const driverRoutes = require('./routes/driverRoutes');
const { updateDriverLocation } = require('./services/dispatchService');

const app = express();
app.use(cors({ origin: process.env.FRONTEND_ORIGIN || '*' }));
app.use(helmet());
app.use(express.json());
app.use('/api/drivers', driverRoutes);
app.get('/health', (req, res) => res.json({ status: 'running', time: new Date() }));

const server = http.createServer(app);
const io = new Server(server, { cors: { origin: process.env.FRONTEND_ORIGIN || '*', methods: ['GET', 'POST'] } });
const activeDrivers = new Map();

io.on('connection', (socket) => {
  socket.on('driver_online', async (driverId) => {
    activeDrivers.set(String(driverId), { socketId: socket.id });
    await Driver.update({ isAvailable: true }, { where: { id: driverId } });
  });

  socket.on('join_tracking_room', (driverId) => {
    socket.join(`track_driver_${driverId}`);
  });

  socket.on('update_location', async ({ driverId, lat, lng }) => {
    if (!driverId || lat == null || lng == null) return;
    await updateDriverLocation(driverId, lat, lng);
    io.to(`track_driver_${driverId}`).emit('driver_location_updated', { driverId, lat, lng });
  });

  socket.on('disconnect', async () => {
    for (const [driverId, info] of activeDrivers.entries()) {
      if (info.socketId === socket.id) {
        activeDrivers.delete(driverId);
        await Driver.update({ isAvailable: false }, { where: { id: driverId } });
        break;
      }
    }
  });
});

async function start() {
  await sequelize.authenticate();
  await sequelize.query('CREATE EXTENSION IF NOT EXISTS postgis;');
  await sequelize.sync({ alter: true });
  const port = process.env.PORT || 3000;
  server.listen(port, () => console.log(`Backend running on port ${port}`));
}

start().catch((err) => {
  console.error(err);
  process.exit(1);
});
