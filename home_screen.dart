import 'package:flutter/material.dart';
import 'customer_tracking_screen.dart';
import 'driver_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planet Logistics')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(22),
                  child: Column(
                    children: [
                      Icon(Icons.local_shipping_rounded, size: 72, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(height: 14),
                      const Text('منصة لوجستية للتتبع اللحظي', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text('نسخة المرحلة الأولى: عميل + سائق + تتبع مباشر عبر Socket.IO', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.person_pin_circle),
                label: const Text('الدخول كعميل وتتبع سائق'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CustomerTrackingScreen(driverId: '1'))),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.drive_eta),
                label: const Text('الدخول كسائق وإرسال الموقع'),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverScreen(driverId: '1'))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
