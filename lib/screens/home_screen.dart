import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../widgets/service_card.dart';
import '../widgets/promo_banner.dart';
import '../screens/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Fungsi untuk mendapatkan sapaan berdasarkan waktu
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 15) {
      return 'Selamat Siang';
    } else if (hour < 18) {
      return 'Selamat Sore';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredServices = ref.watch(filteredServicesProvider);

    final userData = ref.watch(userProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Bagian Kiri: Teks Sapaan
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_getGreeting()}, ${userData.name}!',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Apa yang ingin Anda lakukan hari ini?',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(30),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue.shade100,
                        // Tampilkan foto jika path-nya ada, jika tidak tampilkan ikon
                        backgroundImage: userData.photoPath != null
                            ? FileImage(File(userData.photoPath!))
                            : null,
                        child: userData.photoPath == null
                            ? Icon(
                                Icons.account_circle,
                                size: 30,
                                color: Colors.blue.shade600,
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Sliver untuk kotak pencarian
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16.0,
                  right: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      ref.read(searchQueryProvider.notifier).state = query;
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari layanan...',
                      hintStyle: const TextStyle(color: Colors.grey),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                    ),
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: PromoBanner()),

            if (filteredServices.isEmpty)
              const SliverFillRemaining(
                child: Center(child: Text('Tidak ada layanan ditemukan.')),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 0.9,
                  ),
                  delegate: SliverChildBuilderDelegate((
                    BuildContext context,
                    int index,
                  ) {
                    final service = filteredServices[index];

                    return ServiceCard(service: service);
                  }, childCount: filteredServices.length),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
