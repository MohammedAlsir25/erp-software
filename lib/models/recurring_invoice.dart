import 'package:flutter/material.dart';

class RecurringInvoice {
  final String id;
  final String customerName;
  final String details;
  final double amount;
  final String frequency;
  final DateTime startDate;
  final DateTime? endDate;

  RecurringInvoice({
    required this.id,
    required this.customerName,
    required this.details,
    required this.amount,
    required this.frequency,
    required this.startDate,
    this.endDate,
  });

  factory RecurringInvoice.fromJson(Map<String, dynamic> json) => RecurringInvoice(
        id: json['id'],
        customerName: json['customerName'],
        details: json['details'],
        amount: json['amount'].toDouble(),
        frequency: json['frequency'],
        startDate: DateTime.parse(json['startDate']),
        endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'customerName': customerName,
        'details': details,
        'amount': amount,
        'frequency': frequency,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate?.toIso8601String(),
      };
}
