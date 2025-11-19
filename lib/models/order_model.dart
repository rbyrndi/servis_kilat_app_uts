enum OrderStatus { selesai, proses, menunggu }

class Order {
  final String id;
  final String serviceName;
  final OrderStatus status;
  final DateTime date;
  final String? alamat;
  final String? catatan;

  final String? selectedService;
  final String? paymentMethod;
  final double? lat;
  final double? lng;

  Order({
    required this.id,
    required this.serviceName,
    required this.status,
    required this.date,
    this.alamat,
    this.catatan,
    this.selectedService,
    this.paymentMethod,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serviceName': serviceName,
      'status': status.toString(),
      'date': date.toIso8601String(),
      'alamat': alamat,
      'catatan': catatan,
      'selectedService': selectedService,
      'paymentMethod': paymentMethod,
      'lat': lat,
      'lng': lng,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      serviceName: json['serviceName'],
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == json['status'],
        orElse: () => OrderStatus.menunggu,
      ),
      date: DateTime.parse(json['date']),
      alamat: json['alamat'],
      catatan: json['catatan'],
      selectedService: json['selectedService'],
      paymentMethod: json['paymentMethod'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
    );
  }
}
