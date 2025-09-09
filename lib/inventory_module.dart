import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'main.dart';

class InventoryModule extends StatefulWidget {
  const InventoryModule({super.key});

  @override
  State<InventoryModule> createState() => _InventoryModuleState();
}

class _InventoryModuleState extends State<InventoryModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _addProduct(context),
            child: const Text('Add Product'),
          ),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Text(product.name[0]),
                  ),
                  title: Text(product.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \$${product.price.toStringAsFixed(2)}'),
                      Text('Stock: ${product.stockQuantity}'),
                      Text('Category: ${product.category}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editProduct(context, index, product),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteProduct(context, index),
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

  void _addProduct(BuildContext context) {
    // Implementation for adding product dialog
  }

  void _editProduct(BuildContext context, int index, Product product) {
    // Implementation for editing product dialog
  }

  void _confirmDeleteProduct(BuildContext context, int index) {
    // Implementation for confirming product deletion
  }
}
