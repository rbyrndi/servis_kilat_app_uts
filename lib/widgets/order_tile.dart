import 'package:flutter/material.dart';
import '../models/order_model.dart';

class OrderTile extends StatelessWidget {
  final Order order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (order.status) {
      case OrderStatus.selesai:
        statusColor = Colors.green;
        statusText = 'Selesai';
        break;
      case OrderStatus.proses:
        statusColor = Colors.orange;
        statusText = 'Dalam Proses';
        break;
      case OrderStatus.menunggu:
        statusColor = Colors.blue;
        statusText = 'Menunggu Konfirmasi';
        break;
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(
          Icons.receipt_long,
          color: Theme.of(context).primaryColor,
        ),
        title: Text(
          order.serviceName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Tanggal: ${order.date.day}-${order.date.month}-${order.date.year}',
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Chip(
          label: Text(
            statusText,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          backgroundColor: statusColor,
        ),
      ),
    );
  }
}
