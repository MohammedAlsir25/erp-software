import 'package:flutter/material.dart';

class WaveFeaturesModule extends StatelessWidget {
  const WaveFeaturesModule({super.key});

  final List<String> features = const [
    'Invoicing: Create and send professional invoices.',
    'Payments: Accept online payments from customers.',
    'Accounting: Track income, expenses, and generate financial reports.',
    'Payroll: Manage employee payroll and tax filings.',
    'Receipts: Scan and organize receipts.',
    'Financial Dashboard: Overview of cash flow and financial health.',
    'Integrations: Connect with banks and other financial tools.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wave Website Features'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
              title: Text(features[index]),
            ),
          );
        },
      ),
    );
  }
}
