import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import '../models/service_model.dart';
import '../models/order_model.dart';

// Provider untuk mengontrol index BottomNavigationBar
final currentIndexProvider = StateProvider<int>((ref) => 0);

// Provider untuk menyimpan teks yang sedang dicari
final searchQueryProvider = StateProvider<String>((ref) => '');

// Provider yang akan menghasilkan daftar layanan yang sudah difilter
final filteredServicesProvider = Provider<List<Service>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  final allServices = ref.watch(servicesProvider);

  if (searchQuery.isEmpty) {
    return allServices;
  }

  return allServices.where((service) {
    return service.name.toLowerCase().contains(searchQuery);
  }).toList();
});

// Provider untuk daftar layanan lengkap (data hardcode)
final servicesProvider = Provider<List<Service>>((ref) {
  return [
    Service(
      id: '1',
      name: 'ServisKilat Motor',
      iconPath: 'motorcycle',
      color: Colors.indigo.shade400,
    ),
    Service(
      id: '2',
      name: 'ServisKilat Mobil',
      iconPath: 'directions_car',
      color: Colors.blue.shade400,
    ),
    Service(
      id: '3',
      name: 'CuciKilat',
      iconPath: 'local_car_wash',
      color: Colors.cyan.shade400,
    ),
    Service(
      id: '4',
      name: 'BengkelKilat',
      iconPath: 'build',
      color: Colors.orange.shade400,
    ),
    Service(
      id: '5',
      name: 'TowingKilat',
      iconPath: 'local_shipping',
      color: Colors.red.shade400,
    ),
    Service(
      id: '6',
      name: 'KirimPaketKilat',
      iconPath: 'local_shipping',
      color: Colors.purple.shade400,
    ),
  ];
});

class OrderNotifier extends StateNotifier<List<Order>> {
  OrderNotifier() : super([]) {
    _loadOrders();
  }

  // Fungsi untuk memuat pesanan dari penyimpanan lokal saat aplikasi dibuka
  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String? ordersString = prefs.getString('orders');

    if (ordersString != null) {
      final List<dynamic> jsonList = json.decode(ordersString);
      state = jsonList.map((json) => Order.fromJson(json)).toList();
    }
  }

  // Fungsi untuk menambah pesanan baru dan langsung menyimpannya
  Future<void> addOrder(Order order) async {
    state = [...state, order];
    await _saveOrders();
  }

  // Fungsi untuk menyimpan seluruh daftar pesanan ke penyimpanan lokal
  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final String ordersString = json.encode(
      state.map((order) => order.toJson()).toList(),
    );
    await prefs.setString('orders', ordersString);
  }
}

// Provider yang mengekspos OrderNotifier ke UI
final orderNotifierProvider = StateNotifierProvider<OrderNotifier, List<Order>>(
  (ref) {
    return OrderNotifier();
  },
);

// Model data pengguna yang lebih lengkap
class UserData {
  final String name;
  final String phone;
  final String? photoPath;

  UserData({required this.name, required this.phone, this.photoPath});
}

class UserNotifier extends StateNotifier<UserData> {
  UserNotifier() : super(UserData(name: 'User', phone: '+62 812-3456-7890')) {
    _loadUserData();
  }

  // Fungsi untuk memuat data pengguna dari penyimpanan lokal
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('user_name') ?? 'User';
    final phone = prefs.getString('user_phone') ?? '+62 812-3456-7890';
    final photoPath = prefs.getString('user_photo_path');
    state = UserData(name: name, phone: phone, photoPath: photoPath);
  }

  // Fungsi untuk memperbarui dan menyimpan data pengguna
  Future<void> updateProfile({
    String? newName,
    String? newPhone,
    String? newPhotoPath,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    if (newName != null) {
      await prefs.setString('user_name', newName);
      state = UserData(
        name: newName,
        phone: state.phone,
        photoPath: state.photoPath,
      );
    }
    if (newPhone != null) {
      await prefs.setString('user_phone', newPhone);
      state = UserData(
        name: state.name,
        phone: newPhone,
        photoPath: state.photoPath,
      );
    }
    if (newPhotoPath != null) {
      await prefs.setString('user_photo_path', newPhotoPath);
      state = UserData(
        name: state.name,
        phone: state.phone,
        photoPath: newPhotoPath,
      );
    }
  }
}

// Provider yang mengekspos UserNotifier ke UI
final userProvider = StateNotifierProvider<UserNotifier, UserData>((ref) {
  return UserNotifier();
});
