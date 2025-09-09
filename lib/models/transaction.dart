class Transaction {
  final String id;
  String type;
  double amount;
  DateTime date;
  String description;
  String category;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    required this.category,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: json['amount'],
      date: DateTime.parse(json['date']),
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'date': date.toIso8601String(),
      'description': description,
      'category': category,
    };
  }
}
