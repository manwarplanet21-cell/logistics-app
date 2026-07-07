import 'package:socket_io_client/socket_io_client.dart' as io;
import 'app_config.dart';

class SocketService {
  late final io.Socket socket;

  void connect() {
    socket = io.io(
      AppConfig.serverUrl,
      io.OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );
    socket.connect();
  }

  void joinTracking(String driverId) {
    socket.emit('join_tracking_room', driverId);
  }

  void driverOnline(String driverId) {
    socket.emit('driver_online', driverId);
  }

  void sendLocation(String driverId, double lat, double lng) {
    socket.emit('update_location', {'driverId': driverId, 'lat': lat, 'lng': lng});
  }

  void dispose() {
    socket.disconnect();
    socket.dispose();
  }
}
