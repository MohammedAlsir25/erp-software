import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Assuming ERPState is here

class IncomeModule extends StatelessWidget {
  const IncomeModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Income'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _addIncomeTransaction(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Income'),
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
          final incomeTransactions =
              state.transactions.where((t) => t.type == 'income').toList();

          if (incomeTransactions.isEmpty) {
            return const Center(
              child: Text(
                'No income transactions yet.\nClick \'Add Income\' to get started!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            itemCount: incomeTransactions.length,
            itemBuilder: (context, index) {
              final transaction = incomeTransactions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.arrow_upward, color: Colors.white),
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
                    '+\$${transaction.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        color: Colors.green,
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

  void _addIncomeTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        double amount = 0.0;
        String description = '';
        String category = '';
        final formKey = GlobalKey<FormState>();

        return AlertDialog(
          title: const Text('Add New Income'),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) => description = value,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
                    decoration: const InputDecoration(labelText: 'Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty || (double.tryParse(value) ?? 0) <= 0) {
                        return 'Please enter a valid amount';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => category = value,
                    decoration: const InputDecoration(labelText: 'Category'),
                     validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a category';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Provider.of<ERPState>(context, listen: false)
                      .addTransaction('income', amount, description, category);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
