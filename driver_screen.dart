import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/socket_service.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final _driverIdController = TextEditingController(text: '1');
  final SocketService _socketService = SocketService();
  Timer? _timer;
  Position? _lastPosition;
  bool _online = false;

  @override
  void initState() {
    super.initState();
    _socketService.connect();
  }

  Future<bool> _ensurePermission() async {
    bool enabled = await Geolocator.isLocationServiceEnabled();
    if (!enabled) return false;
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return permission == LocationPermission.always || permission == LocationPermission.whileInUse;
  }

  Future<void> _goOnline() async {
    final ok = await _ensurePermission();
    if (!ok) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('يرجى تفعيل إذن الموقع')));
      return;
    }

    final driverId = _driverIdController.text.trim();
    _socketService.socket.emit('driver_online', driverId);
    setState(() => _online = true);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _sendLocation());
    await _sendLocation();
  }

  Future<void> _sendLocation() async {
    final driverId = _driverIdController.text.trim();
    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    _lastPosition = pos;
    _socketService.socket.emit('update_location', {
      'driverId': driverId,
      'lat': pos.latitude,
      'lng': pos.longitude,
    });
    if (mounted) setState(() {});
  }

  void _goOffline() {
    _timer?.cancel();
    setState(() => _online = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _driverIdController.dispose();
    _socketService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('لوحة السائق')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _driverIdController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'رقم السائق'),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_online ? 'السائق متصل' : 'السائق غير متصل', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(_lastPosition == null
                      ? 'لا يوجد موقع مرسل بعد'
                      : 'Lat: ${_lastPosition!.latitude.toStringAsFixed(6)}\nLng: ${_lastPosition!.longitude.toStringAsFixed(6)}'),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _online ? _goOffline : _goOnline,
              child: Text(_online ? 'إيقاف الإرسال' : 'تشغيل السائق وإرسال الموقع'),
            ),
          ],
        ),
      ),
    );
  }
}
