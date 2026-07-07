import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/socket_service.dart';

class CustomerTrackingScreen extends StatefulWidget {
  const CustomerTrackingScreen({super.key});

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  final _driverIdController = TextEditingController(text: '1');
  final SocketService _socketService = SocketService();
  GoogleMapController? _mapController;
  LatLng _driverLocation = const LatLng(15.5881, 32.5342);
  Set<Marker> _markers = {};
  bool _connected = false;

  @override
  void initState() {
    super.initState();
    _setMarker(_driverLocation);
    _socketService.connect();
    _socketService.socket.onConnect((_) => setState(() => _connected = true));
    _socketService.socket.onDisconnect((_) => setState(() => _connected = false));
    _socketService.socket.on('driver_location_updated', (data) {
      if (data == null || !mounted) return;
      final lat = data['lat'];
      final lng = data['lng'];
      if (lat == null || lng == null) return;
      final pos = LatLng((lat as num).toDouble(), (lng as num).toDouble());
      setState(() {
        _driverLocation = pos;
        _setMarker(pos);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(pos));
    });
  }

  void _joinTracking() {
    _socketService.socket.emit('join_tracking_room', _driverIdController.text.trim());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تفعيل التتبع')));
  }

  void _setMarker(LatLng pos) {
    _markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: pos,
        infoWindow: const InfoWindow(title: 'موقع السائق'),
      ),
    };
  }

  @override
  void dispose() {
    _driverIdController.dispose();
    _socketService.disconnect();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الشحنة')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _driverIdController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'رقم السائق'),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(onPressed: _joinTracking, child: const Text('تتبع')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(_connected ? Icons.circle : Icons.circle_outlined, color: _connected ? Colors.green : Colors.red, size: 14),
                const SizedBox(width: 8),
                Text(_connected ? 'متصل بالسيرفر' : 'غير متصل'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(target: _driverLocation, zoom: 14.5),
              markers: _markers,
              myLocationButtonEnabled: true,
              onMapCreated: (controller) => _mapController = controller,
            ),
          ),
        ],
      ),
    );
  }
}
