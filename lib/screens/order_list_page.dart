import 'package:flutter/material.dart';
import 'package:tanair/models/orders.dart';
import 'package:tanair/screens/login_page.dart';
import 'package:tanair/widgets/bottom_sheet.dart';

class OrderListPage extends StatefulWidget {
  const OrderListPage({super.key});

  @override
  OrderListPageState createState() => OrderListPageState();
}

class OrderListPageState extends State<OrderListPage> {
  final List<Order> _demoOrders = [
    Order(
      id: 'TNC001',
      customerName: 'John Doe',
      productName: 'Cargo Container',
      quantity: 2,
      price: 5000.00,
      status: 'pending',
    ),
    Order(
      id: 'TNC002',
      customerName: 'Jane Smith',
      productName: 'Freight Shipment',
      quantity: 1,
      price: 7500.00,
      status: 'shipped',
    ),
    Order(
      id: 'TNC003',
      customerName: 'Alice Johnson',
      productName: 'Logistics Package',
      quantity: 3,
      price: 2500.00,
      status: 'delivered',
    ),
  ];

  List<Order> _orders = [];
  List<Order> _filteredOrders = [];
  String _selectedStatus = 'All';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _orders = _demoOrders;
      _filteredOrders = _orders;
    });
  }

  void _filterOrders() {
    setState(() {
      _filteredOrders = _orders.where((order) {
        final statusMatch = _selectedStatus == 'All' || 
            order.status == _selectedStatus.toLowerCase();
        final searchMatch = order.customerName.toLowerCase().contains(
              _searchController.text.toLowerCase(),
            );
        return statusMatch && searchMatch;
      }).toList();
    });
  }

  void _showOrderDetails(Order order) {
    showModalBottomSheet(
      context: context,
      builder: (context) => OrderDetailsBottomSheet(
        order: order,
        onStatusUpdate: _updateOrderStatus,
      ),
    );
  }

  void _updateOrderStatus(Order order, String newStatus) {
    setState(() {
      order.status = newStatus;
      _filterOrders();
    });
    Navigator.pop(context);
  }

  void _showCreateOrderDialog() {
    final formKey = GlobalKey<FormState>();
    final customerNameController = TextEditingController();
    final productNameController = TextEditingController();
    final quantityController = TextEditingController();
    final priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Order'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: priceController,
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Create'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final newOrder = Order(
                  id: 'TNC${_demoOrders.length + 1}',
                  customerName: customerNameController.text,
                  productName: productNameController.text,
                  quantity: int.parse(quantityController.text),
                  price: double.parse(priceController.text),
                  status: 'pending',
                );

                setState(() {
                  _demoOrders.add(newOrder);
                  _orders = _demoOrders;
                  _filteredOrders = _orders;
                });

                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TANAIR CARGO Orders'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showCreateOrderDialog,
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by Customer Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (_) => _filterOrders(),
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedStatus,
                  items: ['All', 'Pending', 'Shipped', 'Delivered']
                      .map((status) => DropdownMenuItem(
                            value: status,
                            child: Text(status),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedStatus = value ?? 'All';
                      _filterOrders();
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredOrders.isEmpty
                ? Center(child: Text('No orders found'))
                : ListView.builder(
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(order.customerName),
                          subtitle: Text(
                            '${order.productName} - Qty: ${order.quantity}',
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(order.status),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              order.status.toUpperCase(),
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          onTap: () => _showOrderDetails(order),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.blue;
      case 'delivered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
