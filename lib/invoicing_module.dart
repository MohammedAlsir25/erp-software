import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart'; // Assuming ERPState is here
import 'models/invoice.dart';
import 'invoice_details_screen.dart';

class InvoicingModule extends StatelessWidget {
  const InvoicingModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoicing'),
        actions: [
          ElevatedButton.icon(
            onPressed: () => _createNewInvoice(context),
            icon: const Icon(Icons.add),
            label: const Text('Create Invoice'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.onPrimary, 
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16)
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          final invoices = state.invoices;

          if (invoices.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No invoices yet.\nClick \'Create Invoice\' to get started!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: invoices.length,
            itemBuilder: (context, index) {
              final invoice = invoices[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _getStatusColor(invoice.status),
                    child: const Icon(Icons.receipt_long, color: Colors.white),
                  ),
                  title: Text(invoice.customerName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoice.details),
                      Text('Date: ${invoice.date.toString().split(' ')[0]}'),
                      Text('Status: ${invoice.status}', style: TextStyle(color: _getStatusColor(invoice.status), fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                       Text(
                        '\$${invoice.amount.toStringAsFixed(2)}',
                        style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoiceDetailsScreen(invoice: invoice),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editInvoice(context, invoice),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteInvoice(context, invoice.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Paid':
        return Colors.green;
      case 'Sent':
        return Colors.blue;
      case 'Draft':
      default:
        return Colors.grey;
    }
  }

  void _confirmDeleteInvoice(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this invoice?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false)
                    .removeInvoice(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _createNewInvoice(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        String customerName = '';
        String invoiceDetails = '';
        double amount = 0.0;
        bool isRecurring = false;
        String recurringFrequency = 'Monthly';

        return AlertDialog(
          title: const Text('Create New Invoice'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        onChanged: (value) => customerName = value,
                        decoration: const InputDecoration(labelText: 'Customer Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a customer name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        onChanged: (value) => invoiceDetails = value,
                        decoration: const InputDecoration(labelText: 'Invoice Details'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the invoice details';
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
                      SwitchListTile(
                        title: const Text('Recurring Invoice'),
                        value: isRecurring,
                        onChanged: (bool value) {
                          setState(() {
                            isRecurring = value;
                          });
                        },
                      ),
                      if (isRecurring)
                        DropdownButtonFormField<String>(
                          value: recurringFrequency,
                          items: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              recurringFrequency = value ?? 'Monthly';
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Frequency'),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // TODO: Handle recurring invoice logic
                  Provider.of<ERPState>(context, listen: false).addInvoice(
                    customerName,
                    invoiceDetails,
                    amount,
                  );
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }
  
  void _editInvoice(BuildContext context, Invoice invoice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final formKey = GlobalKey<FormState>();
        String customerName = invoice.customerName;
        String invoiceDetails = invoice.details;
        double amount = invoice.amount;
        String status = invoice.status;
        bool isRecurring = false; // TODO: Get from invoice model
        String recurringFrequency = 'Monthly'; // TODO: Get from invoice model

        return AlertDialog(
          title: const Text('Edit Invoice'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        initialValue: customerName,
                        onChanged: (value) => customerName = value,
                        decoration: const InputDecoration(labelText: 'Customer Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a customer name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: invoiceDetails,
                        onChanged: (value) => invoiceDetails = value,
                        decoration: const InputDecoration(labelText: 'Invoice Details'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the invoice details';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        initialValue: amount.toString(),
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
                      DropdownButtonFormField<String>(
                        value: status,
                        items: ['Draft', 'Sent', 'Paid'].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) {
                          status = value ?? 'Draft';
                        },
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                      SwitchListTile(
                        title: const Text('Recurring Invoice'),
                        value: isRecurring,
                        onChanged: (bool value) {
                          setState(() {
                            isRecurring = value;
                          });
                        },
                      ),
                      if (isRecurring)
                        DropdownButtonFormField<String>(
                          value: recurringFrequency,
                          items: ['Daily', 'Weekly', 'Monthly', 'Yearly'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              recurringFrequency = value ?? 'Monthly';
                            });
                          },
                          decoration: const InputDecoration(labelText: 'Frequency'),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  // TODO: Handle recurring invoice logic
                  final updatedInvoice = Invoice(
                    id: invoice.id,
                    customerName: customerName,
                    details: invoiceDetails,
                    amount: amount,
                    status: status,
                    date: invoice.date,
                  );
                  Provider.of<ERPState>(context, listen: false)
                      .updateInvoice(updatedInvoice);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }
}
