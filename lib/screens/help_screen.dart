// lib/screens/help_screen.dart
import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: const [
          ExpansionTile(
            leading: Icon(Icons.question_answer, color: Colors.blue),
            title: Text('Bagaimana cara memesan layanan?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Memesan layanan di ServisKilat sangat mudah:\n'
                  '1. Buka halaman Beranda.\n'
                  '2. Pilih layanan yang Anda inginkan (misal: ServisKilat Motor).\n'
                  '3. Di halaman detail, tekan tombol "Pesan Sekarang".\n'
                  '4. Pilih tanggal & waktu, lalu isi alamat lengkap.\n'
                  '5. Tekan "Konfirmasi Pesanan" dan selesai!',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.list_alt, color: Colors.blue),
            title: Text('Bagaimana cara melihat pesanan saya?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Untuk melihat semua pesanan Anda, baik yang sedang proses maupun yang sudah selesai, cukup pilih tab "Pesanan" yang ada di bagian bawah aplikasi.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.security, color: Colors.blue),
            title: Text('Apakah data saya aman?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Tentu saja! Kami sangat menjaga privasi Anda. Semua data pribadi dan riwayat pesanan Anda disimpan secara aman di perangkat HP Anda sendiri dan tidak akan kami bagikan kepada pihak ketiga tanpa izin Anda.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: Icon(Icons.payment, color: Colors.blue),
            title: Text('Bagaimana cara pembayarannya?'),
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Saat ini, pembayaran dapat dilakukan secara tunjung (cash) langsung kepada montir atau petugas kami setelah layanan selesai. Kami sedang mengembangkan metode pembayaran non-tunang untuk kemudahan Anda.',
                  style: TextStyle(height: 1.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
