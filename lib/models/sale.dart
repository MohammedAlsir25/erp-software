class Sale {
  final String id;
  String customerId;
  List<String> productIds;
  double totalAmount;
  DateTime date;
  String status;

  Sale({
    required this.id,
    required this.customerId,
    required this.productIds,
    required this.totalAmount,
    required this.date,
    required this.status,
  });

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      customerId: json['customerId'],
      productIds: List<String>.from(json['productIds']),
      totalAmount: json['totalAmount'],
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'productIds': productIds,
      'totalAmount': totalAmount,
      'date': date.toIso8601String(),
      'status': status,
    };
  }
}
