import 'package:flutter/material.dart';
import 'package:tanair/models/orders.dart';


class OrderDetailsBottomSheet extends StatelessWidget {
  final Order order;
  final Function(Order, String) onStatusUpdate;

  const OrderDetailsBottomSheet({super.key, 
    required this.order,
    required this.onStatusUpdate,
  });

  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Order Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildDetailRow('Order ID', order.id),
          _buildDetailRow('Customer', order.customerName),
          _buildDetailRow('Product', order.productName),
          _buildDetailRow('Quantity', order.quantity.toString()),
          _buildDetailRow('Price', '\$${order.price.toStringAsFixed(2)}'),
          _buildDetailRow('Current Status', order.status.toUpperCase()),
          SizedBox(height: 16),
          Text(
            'Update Order Status',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildStatusUpdateButtons(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  List<Widget> _buildStatusUpdateButtons(context) {
    List<Map<String, String>> statusTransitions = [
      {'from': 'pending', 'to': 'shipped', 'label': 'Mark as Shipped'},
      {'from': 'shipped', 'to': 'delivered', 'label': 'Mark as Delivered'},
    ];

    return statusTransitions
        .where((transition) => order.status.toLowerCase() == transition['from'])
        .map((transition) => ElevatedButton(
              onPressed: () => onStatusUpdate(order, transition['to']!),
              child: Text(transition['label']!),
            ))
        .toList();
  }
}