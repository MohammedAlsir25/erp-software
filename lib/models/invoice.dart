import 'package:flutter/material.dart';

class Invoice {
  String id;
  String customerName;
  String details;
  double amount;
  String status;
  DateTime date;
  bool isRecurring;

  Invoice({
    required this.id,
    required this.customerName,
    required this.details,
    required this.amount,
    this.status = 'Draft',
    required this.date,
    this.isRecurring = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'details': details,
        'amount': amount,
        'status': status,
        'date': date.toIso8601String(),
        'isRecurring': isRecurring,
      };

  static Invoice fromJson(Map<String, dynamic> json) => Invoice(
        id: json['id'],
        customerName: json['customerName'],
        details: json['details'],
        amount: json['amount'],
        status: json['status'],
        date: DateTime.parse(json['date']),
        isRecurring: json['isRecurring'] ?? false,
      );
}
