import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/service_model.dart';
import '../models/order_model.dart';
import '../providers/app_providers.dart';

class BookingScreen extends ConsumerStatefulWidget {
  final Service service;

  const BookingScreen({Key? key, required this.service}) : super(key: key);

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  final _alamatController = TextEditingController();
  final _catatanController = TextEditingController();
  bool _isLoading = false;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final MapController _mapController = MapController();
  // Titik awal (Misal: Monas, Jakarta)
  final LatLng _initialLocation = const LatLng(-6.175392, 106.827153);
  late LatLng _selectedLocation;

  String _selectedService = 'Ganti Oli';
  String _paymentMethod = 'Tunai';

  // Opsi untuk dropdown
  final List<String> _serviceOptions = [
    'Ganti Oli',
    'Servis Rem',
    'Servis AC',
    'Ganti Ban',
    'Lainnya',
  ];
  final List<String> _paymentOptions = ['Tunai', 'Transfer Bank', 'E-Wallet'];

  @override
  void initState() {
    super.initState();
    _selectedLocation = _initialLocation;
  }

  @override
  void dispose() {
    _alamatController.dispose();
    _catatanController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  // --- FUNGSI PILIH TANGGAL ---
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 1),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --- FUNGSI PILIH WAKTU ---
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // --- FUNGSI KONFIRMASI PESANAN ---
  void _confirmOrder() async {
    if (_alamatController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Alamat tidak boleh kosong')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulasi proses async
    await Future.delayed(const Duration(seconds: 2));

    // Gabungkan tanggal dan waktu
    final orderDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Buat pesanan baru (Sesuai Model Order yang baru)
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      serviceName: widget.service.name,
      status: OrderStatus.menunggu,
      date: orderDateTime,
      alamat: _alamatController.text,
      catatan: _catatanController.text,
      selectedService: _selectedService,
      paymentMethod: _paymentMethod,
      lat: _selectedLocation.latitude,
      lng: _selectedLocation.longitude,
    );

    // Tambahkan pesanan ke provider
    ref.read(orderNotifierProvider.notifier).addOrder(newOrder);

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Pesanan berhasil dibuat!')));

    // Kembali ke halaman utama dan pindah ke tab Pesanan
    Navigator.popUntil(context, (route) => route.isFirst);
    ref.read(currentIndexProvider.notifier).state = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan ${widget.service.name}'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Detail Layanan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Text(widget.service.name, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 24),

            // --- WIDGET PETA (FLUTTER MAP V8) ---
            const Text(
              'Lokasi Anda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _initialLocation,
                    initialZoom: 15.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        _selectedLocation = point;
                      });
                      _mapController.move(point, 15.0);
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.serviskilat_app',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _selectedLocation,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ketuk pada peta untuk memindahkan lokasi',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            const Text(
              'Pilih Layanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedService,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _serviceOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null)
                  setState(() => _selectedService = newValue);
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Metode Pembayaran',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _paymentMethod,
              decoration: const InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
              items: _paymentOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) setState(() => _paymentMethod = newValue);
              },
            ),
            const SizedBox(height: 24),

            const Text(
              'Tanggal & Waktu',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _selectDate,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _selectTime,
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedTime.format(context),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // --- INPUT ALAMAT ---
            const Text(
              'Alamat Lengkap',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _alamatController,
              decoration: const InputDecoration(
                hintText: 'Masukkan alamat Anda',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // --- INPUT CATATAN ---
            const Text(
              'Catatan (Opsional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _catatanController,
              decoration: const InputDecoration(
                hintText: 'Contoh: Depan rumah warna merah',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),

            // --- TOMBOL KONFIRMASI ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _confirmOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Konfirmasi Pesanan',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
