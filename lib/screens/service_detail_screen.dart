import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/service_model.dart';
import 'booking_screen.dart';

class ServiceDetailScreen extends ConsumerWidget {
  final Service service;

  const ServiceDetailScreen({Key? key, required this.service})
    : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(service.name),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Layanan
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: service.color.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _getIconData(service.iconPath),
                  size: 80,
                  color: service.color,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Nama Layanan
            Text(
              service.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Layanan profesional dan terpercaya untuk kebutuhan Anda. Montir kami siap datang ke lokasi Anda.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            // Tombol Pesan
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingScreen(service: service),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi helper untuk mendapatkan IconData
  IconData _getIconData(String iconPath) {
    switch (iconPath) {
      case 'motorcycle':
        return Icons.motorcycle;
      case 'directions_car':
        return Icons.directions_car;
      case 'local_car_wash':
        return Icons.local_car_wash;
      case 'build':
        return Icons.build;
      case 'local_shipping':
        return Icons.local_shipping;
      default:
        return Icons.miscellaneous_services;
    }
  }
}
