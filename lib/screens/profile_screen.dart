import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/app_providers.dart';
import 'help_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    // Ambil data awal dari provider untuk ditampilkan di dialog
    final userData = ref.read(userProvider);
    _nameController = TextEditingController(text: userData.name);
    _phoneController = TextEditingController(text: userData.phone);
  }

  @override
  void dispose() {
    // Bersihkan controller saat widget dihapus
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Fungsi untuk memilih foto dari galeri
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Update provider dengan path foto baru
      ref.read(userProvider.notifier).updateProfile(newPhotoPath: image.path);
    }
  }

  // Fungsi untuk menyimpan profil yang telah diedit
  void _saveProfile() {
    ref
        .read(userProvider.notifier)
        .updateProfile(
          newName: _nameController.text,
          newPhone: _phoneController.text,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui!')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    // "Mendengarkan" perubahan data dari provider
    final userData = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Akun Saya'),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade200,
                    backgroundImage: userData.photoPath != null
                        ? FileImage(File(userData.photoPath!))
                        : null,
                    child: userData.photoPath == null
                        ? const Icon(
                            Icons.account_circle,
                            size: 40,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tampilkan nama dan telepon dari userData
                      Text(
                        userData.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userData.phone,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Tombol untuk mengedit profil
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Edit Profil'),
                        content: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: "Nama",
                                ),
                                autofocus: true,
                              ),
                              TextField(
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: "No. Telepon",
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: _saveProfile,
                            child: const Text('Simpan'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.account_balance_wallet,
                  color: Colors.blue,
                ),
                title: const Text('Saldo ServisKilat'),
                subtitle: const Text('Rp 150.000'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Fitur saldo segera hadir!')),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.history, color: Colors.blue),
                title: const Text('Riwayat Pesanan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ref.read(currentIndexProvider.notifier).state = 1;
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text('Pengaturan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fitur pengaturan segera hadir!'),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: ListTile(
                leading: const Icon(Icons.help_center, color: Colors.blue),
                title: const Text('Bantuan'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HelpScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
