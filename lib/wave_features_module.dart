import 'package:flutter/material.dart';

class WaveFeaturesModule extends StatelessWidget {
  const WaveFeaturesModule({super.key});

  final List<String> features = const [
    'Invoicing',
    'Accounting',
    'Payments',
    'Payroll',
    'Advisors',
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
