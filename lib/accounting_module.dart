import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Assuming ERPState is here

class AccountingModule extends StatelessWidget {
  const AccountingModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounting'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _showFinancialStatements(context),
            icon: const Icon(Icons.assessment),
            label: const Text('Financial Statements'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          if (state.transactions.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.account_balance_wallet, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No transactions yet.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.type == 'income' ? Colors.green : Colors.red,
                    child: Icon(transaction.type == 'income' ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white),
                  ),
                  title: Text(transaction.description, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${transaction.category}'),
                      Text('Date: ${transaction.date.toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Text(
                    '\$${transaction.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                        color: transaction.type == 'income' ? Colors.green : Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showFinancialStatements(BuildContext context) {
    // TODO: Implement financial statement generation
  }
}
