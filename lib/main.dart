import 'package:flutter/material.dart';
//import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TanairCargoApp());
}

class TanairCargoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TANAIR CARGO',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class Order {
  final String id;
  final String customerName;
  final String productName;
  final int quantity;
  final double price;
  String status;

  Order({
    required this.id,
    required this.customerName,
    required this.productName,
    required this.quantity,
    required this.price,
    this.status = 'pending',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? '',
      customerName: json['customerName'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'productName': productName,
        'quantity': quantity,
        'price': price,
        'status': status,
      };
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final String _demoUsername = 'admin';
  final String _demoPassword = 'password123';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_usernameController.text == _demoUsername &&
          _passwordController.text == _demoPassword) {
        final token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderListPage()),
        );
      } else {
        _showErrorDialog('Invalid credentials. Use admin/password123');
      }
    } catch (e) {
      _showErrorDialog('Login error. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TANAIR CARGO Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                hintText: 'Demo: admin',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
                hintText: 'Demo: password123',
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _login,
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  final List<Order> _demoOrders = [
    Order(
        id: 'TNC001',
        customerName: 'John Doe',
        productName: 'Cargo Container',
        quantity: 2,
        price: 5000.00,
        status: 'pending'),
    Order(
        id: 'TNC002',
        customerName: 'Jane Smith',
        productName: 'Freight Shipment',
        quantity: 1,
        price: 7500.00,
        status: 'shipped'),
    Order(
        id: 'TNC003',
        customerName: 'Alice Johnson',
        productName: 'Logistics Package',
        quantity: 3,
        price: 2500.00,
        status: 'delivered'),
    Order(
        id: 'TNC004',
        customerName: 'Michael Brown',
        productName: 'Oversized Shipment',
        quantity: 1,
        price: 12000.00,
        status: 'pending'),
    Order(
        id: 'TNC005',
        customerName: 'Emily Davis',
        productName: 'Small Package',
        quantity: 5,
        price: 150.00,
        status: 'shipped'),
    Order(
        id: 'TNC006',
        customerName: 'David Lee',
        productName: 'Hazardous Material',
        quantity: 2,
        price: 3000.00,
        status: 'delivered'),
    Order(
        id: 'TNC007',
        customerName: 'Olivia Miller',
        productName: 'Refrigerated Shipment',
        quantity: 3,
        price: 4500.00,
        status: 'pending'),
    Order(
        id: 'TNC008',
        customerName: 'William Taylor',
        productName: 'Fragile Item',
        quantity: 10,
        price: 200.00,
        status: 'shipped'),
    Order(
        id: 'TNC009',
        customerName: 'Sophia Wilson',
        productName: 'Document Shipment',
        quantity: 1,
        price: 50.00,
        status: 'delivered'),
    Order(
        id: 'TNC010',
        customerName: 'Benjamin Carter',
        productName: 'Bulk Shipment',
        quantity: 20,
        price: 8000.00,
        status: 'pending'),
    Order(
        id: 'TNC011',
        customerName: 'Sarah Nelson',
        productName: 'Standard Package',
        quantity: 5,
        price: 250.00,
        status: 'shipped'),
    Order(
        id: 'TNC012',
        customerName: 'James Alexander',
        productName: 'Perishable Goods',
        quantity: 4,
        price: 1200.00,
        status: 'delivered'),
    Order(
        id: 'TNC013',
        customerName: 'Chloe Lewis',
        productName: 'Oversized Equipment',
        quantity: 1,
        price: 15000.00,
        status: 'pending'),
    Order(
        id: 'TNC014',
        customerName: 'Ethan Hall',
        productName: 'Small Parcel',
        quantity: 10,
        price: 75.00,
        status: 'shipped'),
    Order(
        id: 'TNC015',
        customerName: 'Ava Mitchell',
        productName: 'High-Value Item',
        quantity: 1,
        price: 50000.00,
        status: 'delivered'),
    Order(
        id: 'TNC016',
        customerName: 'Noah Campbell',
        productName: 'Liquid Shipment',
        quantity: 5,
        price: 1800.00,
        status: 'pending'),
    Order(
        id: 'TNC017',
        customerName: 'Ella Harris',
        productName: 'Standard Mail',
        quantity: 20,
        price: 20.00,
        status: 'shipped'),
    Order(
        id: 'TNC018',
        customerName: 'Liam Wilson',
        productName: 'Heavy Equipment',
        quantity: 2,
        price: 25000.00,
        status: 'delivered'),
    Order(
        id: 'TNC019',
        customerName: 'Olivia Young',
        productName: 'Gift Package',
        quantity: 5,
        price: 100.00,
        status: 'pending'),
    Order(
        id: 'TNC020',
        customerName: 'Jacob King',
        productName: 'Document Envelope',
        quantity: 10,
        price: 15.00,
        status: 'shipped'),
    Order(
        id: 'TNC021',
        customerName: 'Sophia Moore',
        productName: 'Fragile Artwork',
        quantity: 1,
        price: 8000.00,
        status: 'delivered'),
    Order(
        id: 'TNC022',
        customerName: 'William Brown',
        productName: 'Pallet Shipment',
        quantity: 3,
        price: 3000.00,
        status: 'pending'),
    Order(
        id: 'TNC023',
        customerName: 'Emma Jones',
        productName: 'Small Box',
        quantity: 15,
        price: 50.00,
        status: 'shipped'),
    Order(
        id: 'TNC024',
        customerName: 'Benjamin Davis',
        productName: 'Oversized Crate',
        quantity: 1,
        price: 10000.00,
        status: 'delivered'),
    Order(
        id: 'TNC025',
        customerName: 'Sarah Miller',
        productName: 'Envelope',
        quantity: 50,
        price: 5.00,
        status: 'pending'),
    Order(
        id: 'TNC026',
        customerName: 'James Wilson',
        productName: 'Furniture Shipment',
        quantity: 2,
        price: 8000.00,
        status: 'shipped'),
    Order(
        id: 'TNC027',
        customerName: 'Chloe Carter',
        productName: 'Electronics Package',
        quantity: 3,
        price: 1500.00,
        status: 'delivered'),
    Order(
        id: 'TNC028',
        customerName: 'Ethan Lee',
        productName: 'Drum Shipment',
        quantity: 4,
        price: 2000.00,
        status: 'pending'),
    Order(
        id: 'TNC029',
        customerName: 'Ava Harris',
        productName: 'Small Envelope',
        quantity: 20,
        price: 10.00,
        status: 'shipped'),
    Order(
        id: 'TNC030',
        customerName: 'Noah Smith',
        productName: 'Oversized Parcel',
        quantity: 1,
        price: 3000.00,
        status: 'delivered')
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
    final _formKey = GlobalKey<FormState>();
    final _customerNameController = TextEditingController();
    final _productNameController = TextEditingController();
    final _quantityController = TextEditingController();
    final _priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Create New Order'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _customerNameController,
                  decoration: InputDecoration(labelText: 'Customer Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _productNameController,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _quantityController,
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isEmpty ? 'Required' : null,
                ),
                TextFormField(
                  controller: _priceController,
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
              if (_formKey.currentState!.validate()) {
                final newOrder = Order(
                  id: 'TNC${_demoOrders.length + 1}',
                  customerName: _customerNameController.text,
                  productName: _productNameController.text,
                  quantity: int.parse(_quantityController.text),
                  price: double.parse(_priceController.text),
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
  Widget build(BuildContext context) {
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
                            child: Text(status),
                            value: status,
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
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: ListTile(
                          title: Text(order.customerName),
                          subtitle: Text(
                            '${order.productName} - Qty: ${order.quantity}',
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
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

class OrderDetailsBottomSheet extends StatelessWidget {
  final Order order;
  final Function(Order, String) onStatusUpdate;

  const OrderDetailsBottomSheet({
    required this.order,
    required this.onStatusUpdate,
  });

  @override
  Widget build(BuildContext context) {
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

  List<Widget> _buildStatusUpdateButtons(BuildContext context) {
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
