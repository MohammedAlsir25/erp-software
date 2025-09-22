import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/invoice.dart';
import 'main.dart'; // Assuming ERPState is here

class InvoiceDetailsScreen extends StatelessWidget {
  final Invoice invoice;

  const InvoiceDetailsScreen({super.key, required this.invoice});

  @override
  Widget build(BuildContext context) {
    final erpState = Provider.of<ERPState>(context, listen: false);
    final customer = erpState.customers.firstWhere((c) => c.id == invoice.customerName, orElse: () => null);

    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice #${invoice.id}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              // TODO: Implement printing functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () {
                // TODO: Implement PDF generation
            },
          ),
          IconButton(
            icon: const Icon(Icons.email),
            onPressed: () {
                // TODO: Implement sending email
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'INVOICE',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('TAJ AL AMAL', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const Text('123 Business Rd.'),
                        const Text('Business City, 12345'),
                        const Text('contact@taj-al-amal.com'),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),

                // Customer and Invoice Details
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('BILLED TO', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                        if (customer != null)
                          Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        if (customer != null)
                          Text(customer.email),
                        if (customer != null)
                          Text(customer.phone),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Invoice Number:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(invoice.id),
                        const SizedBox(height: 8),
                        Text('Date of Issue:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(invoice.date.toString().split(' ')[0]),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 32),

                // Invoice Items Table
                const Text('INVOICE ITEMS', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                const Divider(),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(3),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                  },
                  children: [
                    const TableRow(
                      children: [
                        Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Qty', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Unit Price', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Amount', textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold)),
                      ]
                    ),
                    // TODO: Replace with dynamic product data from the invoice
                    _buildInvoiceItemRow('Product A', 2, 50.00),
                    _buildInvoiceItemRow('Service B', 1, 150.00),
                    _buildInvoiceItemRow('Product C', 5, 20.00),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 16),

                // Totals Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Tax (10%):', style: TextStyle(fontWeight: FontWeight.bold)),
                        const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    const SizedBox(width: 24),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('\$${invoice.amount.toStringAsFixed(2)}'),
                        Text('\$${(invoice.amount * 0.1).toStringAsFixed(2)}'),
                        Text(
                          '\$${(invoice.amount * 1.1).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Footer
                const Center(
                  child: Column(
                    children: [
                      Text('Thank you for your business!', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Please pay within 30 days.'),
                      Text('Payment Instructions: Please send a check to the address above.'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  TableRow _buildInvoiceItemRow(String description, int quantity, double unitPrice) {
    final total = quantity * unitPrice;
    return TableRow(
      children: [
        Text(description),
        Text(quantity.toString(), textAlign: TextAlign.center),
        Text('\$${unitPrice.toStringAsFixed(2)}', textAlign: TextAlign.right),
        Text('\$${total.toStringAsFixed(2)}', textAlign: TextAlign.right),
      ],
    );
  }
}
