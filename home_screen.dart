import 'package:flutter/material.dart';
import 'customer_tracking_screen.dart';
import 'driver_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.local_shipping, color: Colors.white, size: 42),
              ),
              const SizedBox(height: 22),
              const Text(
                'Planet Logistics',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'نظام احترافي لإدارة وتتبع الشحنات والسائقين لحظيًا.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const Spacer(),
              _RoleCard(
                title: 'دخول العميل',
                subtitle: 'تتبع السائق والشحنة على الخريطة',
                icon: Icons.map,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CustomerTrackingScreen()),
                ),
              ),
              const SizedBox(height: 14),
              _RoleCard(
                title: 'دخول السائق',
                subtitle: 'إرسال الموقع الحالي وتحديثه مباشرة',
                icon: Icons.drive_eta,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverScreen()),
                ),
              ),
              const SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _RoleCard({required this.title, required this.subtitle, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Color(0x16000000), blurRadius: 18, offset: Offset(0, 8))],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              child: Icon(icon, size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.black54)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 18),
          ],
        ),
      ),
    );
  }
}
