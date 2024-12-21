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
