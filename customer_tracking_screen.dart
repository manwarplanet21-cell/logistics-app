import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../services/socket_service.dart';

class CustomerTrackingScreen extends StatefulWidget {
  final String driverId;
  const CustomerTrackingScreen({super.key, required this.driverId});

  @override
  State<CustomerTrackingScreen> createState() => _CustomerTrackingScreenState();
}

class _CustomerTrackingScreenState extends State<CustomerTrackingScreen> {
  GoogleMapController? _mapController;
  final SocketService _socketService = SocketService();
  LatLng _driverLocation = const LatLng(15.5881, 32.5342);
  Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _setMarker(_driverLocation);
    _socketService.connect();
    _socketService.socket.onConnect((_) => _socketService.joinTracking(widget.driverId));
    _socketService.socket.on('driver_location_updated', (data) {
      if (!mounted || data == null) return;
      final next = LatLng((data['lat'] as num).toDouble(), (data['lng'] as num).toDouble());
      setState(() {
        _driverLocation = next;
        _setMarker(next);
      });
      _mapController?.animateCamera(CameraUpdate.newLatLng(next));
    });
  }

  void _setMarker(LatLng point) {
    _markers = {
      Marker(
        markerId: const MarkerId('driver'),
        position: point,
        infoWindow: const InfoWindow(title: 'السائق في الطريق'),
      ),
    };
  }

  @override
  void dispose() {
    _socketService.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تتبع الشحنة')),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _driverLocation, zoom: 14.5),
            markers: _markers,
            myLocationButtonEnabled: true,
            onMapCreated: (controller) => _mapController = controller,
          ),
          Positioned(
            bottom: 18,
            left: 18,
            right: 18,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Row(
                    children: [
                      Icon(Icons.route, color: Theme.of(context).colorScheme.primary, size: 34),
                      const SizedBox(width: 14),
                      const Expanded(child: Text('جاري تحديث موقع السائق لحظيًا', style: TextStyle(fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
