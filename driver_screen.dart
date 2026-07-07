import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../services/socket_service.dart';

class DriverScreen extends StatefulWidget {
  final String driverId;
  const DriverScreen({super.key, required this.driverId});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final SocketService _socketService = SocketService();
  Timer? _timer;
  String _status = 'غير متصل';
  Position? _lastPosition;

  @override
  void initState() {
    super.initState();
    _socketService.connect();
    _socketService.socket.onConnect((_) {
      _socketService.driverOnline(widget.driverId);
      setState(() => _status = 'متصل وجاهز لإرسال الموقع');
    });
  }

  Future<void> _startSendingLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      setState(() => _status = 'صلاحية الموقع مرفوضة');
      return;
    }
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) async {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _socketService.sendLocation(widget.driverId, pos.latitude, pos.longitude);
      if (mounted) setState(() => _lastPosition = pos);
    });
    setState(() => _status = 'يتم إرسال الموقع كل 3 ثوان');
  }

  void _stopSendingLocation() {
    _timer?.cancel();
    setState(() => _status = 'تم إيقاف إرسال الموقع');
  }

  @override
  void dispose() {
    _timer?.cancel();
    _socketService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('واجهة السائق')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      const Icon(Icons.delivery_dining, size: 72),
                      const SizedBox(height: 12),
                      Text(_status, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),
                      Text(_lastPosition == null ? 'لا يوجد موقع مرسل بعد' : 'Lat: ${_lastPosition!.latitude}\nLng: ${_lastPosition!.longitude}'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(onPressed: _startSendingLocation, icon: const Icon(Icons.play_arrow), label: const Text('بدء إرسال الموقع')),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: _stopSendingLocation, icon: const Icon(Icons.stop), label: const Text('إيقاف الإرسال')),
            ],
          ),
        ),
      ),
    );
  }
}
