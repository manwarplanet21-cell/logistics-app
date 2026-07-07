import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'app_config.dart';

class SocketService {
  late final IO.Socket socket;

  void connect() {
    socket = IO.io(
      AppConfig.serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
  }

  void disconnect() {
    socket.disconnect();
    socket.dispose();
  }
}
