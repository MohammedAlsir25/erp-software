import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';

import 'models/customer.dart';
import 'models/product.dart';
import 'models/sale.dart';
import 'models/employee.dart';
import 'models/transaction.dart' as app_transaction;
import 'models/invoice.dart';
import 'models/recurring_invoice.dart';
import 'models/user.dart';

import 'database/firebase_database_helper.dart';

import 'invoicing_module.dart';
import 'accounting_module.dart';

class ERPState extends ChangeNotifier {
  final FirebaseDatabaseHelper _dbHelper = FirebaseDatabaseHelper();

  List<Customer> customers = [];
  List<Product> products = [];
  List<Sale> sales = [];
  List<Employee> employees = [];
  List<app_transaction.Transaction> transactions = [];
  List<Invoice> invoices = [];
  List<RecurringInvoice> recurringInvoices = [];

  ERPState() {
    fetchData();
    _checkRecurringInvoices();
  }

  Future<void> fetchData() async {
    try {
      customers = await _dbHelper.getAllCustomers();
      products = await _dbHelper.getAllProducts();
      sales = await _dbHelper.getAllSales();
      employees = await _dbHelper.getAllEmployees();
      transactions = await _dbHelper.getAllTransactions();
      invoices = await _dbHelper.getAllInvoices();
      recurringInvoices = await _dbHelper.getAllRecurringInvoices();
      notifyListeners();
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _checkRecurringInvoices() {
    Timer.periodic(const Duration(days: 1), (timer) {
      final now = DateTime.now();
      for (final rInvoice in recurringInvoices) {
        final lastCreated = invoices
            .where((i) => i.customerName == rInvoice.customerName && i.isRecurring)
            .map((i) => i.date)
            .fold<DateTime?>(null, (prev, current) => (prev == null || current.isAfter(prev)) ? current : prev);

        bool shouldCreate = false;
        if (lastCreated == null) {
          shouldCreate = true;
        } else {
          switch (rInvoice.frequency) {
            case 'Daily':
              if (now.difference(lastCreated).inDays >= 1) shouldCreate = true;
              break;
            case 'Weekly':
              if (now.difference(lastCreated).inDays >= 7) shouldCreate = true;
              break;
            case 'Monthly':
              if (now.month != lastCreated.month || now.year != lastCreated.year) {
                shouldCreate = true;
              }
              break;
            case 'Yearly':
              if (now.year != lastCreated.year) shouldCreate = true;
              break;
          }
        }

        if (shouldCreate) {
          addInvoice(rInvoice.customerName, rInvoice.details, rInvoice.amount, isRecurring: true);
        }
      }
    });
  }

  // Invoice Methods
  Future<void> addInvoice(String customerName, String details, double amount, {bool isRecurring = false}) async {
    final newInvoice = Invoice(
      id: 'inv_${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName,
      details: details,
      amount: amount,
      date: DateTime.now(),
      isRecurring: isRecurring,
    );
    await _dbHelper.addInvoice(newInvoice);
    await fetchData();
  }

  Future<void> removeInvoice(String id) async {
    await _dbHelper.deleteInvoice(id);
    await fetchData();
  }

  Future<void> addRecurringInvoice(String customerName, String details, double amount, String frequency) async {
    final newRInvoice = RecurringInvoice(
      id: 'rinv_${DateTime.now().millisecondsSinceEpoch}',
      customerName: customerName,
      details: details,
      amount: amount,
      frequency: frequency,
      startDate: DateTime.now(),
    );
    await _dbHelper.addRecurringInvoice(newRInvoice);
    await fetchData();
  }

  Future<void> removeRecurringInvoice(String id) async {
    await _dbHelper.deleteRecurringInvoice(id);
    await fetchData();
  }

  // Customer Methods
  Future<void> addCustomer(String name, String email, String phone) async {
    final newCustomer = Customer(
        id: 'cust_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        phone: phone);
    await _dbHelper.addCustomer(newCustomer);
    await fetchData();
  }

  Future<void> updateCustomer(Customer customer) async {
    await _dbHelper.updateCustomer(customer);
    await fetchData();
  }

  Future<void> removeCustomer(String id) async {
    await _dbHelper.deleteCustomer(id);
    await fetchData();
  }

  // Product Methods
  Future<void> addProduct(String name, String description, double price, int stockQuantity, String category) async {
    final newProduct = Product(
        id: 'prod_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        description: description,
        price: price,
        stockQuantity: stockQuantity,
        category: category);
    await _dbHelper.addProduct(newProduct);
    await fetchData();
  }

  Future<void> updateProduct(Product product) async {
    await _dbHelper.updateProduct(product);
    await fetchData();
  }

  Future<void> removeProduct(String id) async {
    await _dbHelper.deleteProduct(id);
    await fetchData();
  }

  // Sale Methods
  Future<void> addSale(String customerId, List<Product> products, String status) async {
    final totalAmount = products.fold(0.0, (sum, item) => sum + item.price);
    final newSale = Sale(
        id: 'sale_${DateTime.now().millisecondsSinceEpoch}',
        customerId: customerId,
        productIds: products.map((p) => p.id).toList(),
        totalAmount: totalAmount,
        date: DateTime.now(),
        status: status);
    await _dbHelper.addSale(newSale);
    await fetchData();
  }

  Future<void> removeSale(String id) async {
    await _dbHelper.deleteSale(id);
    await fetchData();
  }

  // Employee Methods
  Future<void> addEmployee(String name, String position, String department, double salary, String email, String phone) async {
    final newEmployee = Employee(
        id: 'emp_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        position: position,
        department: department,
        salary: salary,
        email: email,
        phone: phone,
        hireDate: DateTime.now());
    await _dbHelper.addEmployee(newEmployee);
    await fetchData();
  }

  Future<void> updateEmployee(Employee employee) async {
    await _dbHelper.updateEmployee(employee);
    await fetchData();
  }

  Future<void> removeEmployee(String id) async {
    await _dbHelper.deleteEmployee(id);
    await fetchData();
  }

  // Transaction Methods
  Future<void> addTransaction(String type, double amount, String description, String category) async {
    final newTransaction = app_transaction.Transaction(
      id: 'trans_${DateTime.now().millisecondsSinceEpoch}',
      type: type,
      amount: amount,
      date: DateTime.now(),
      description: description,
      category: category,
    );
    await _dbHelper.addTransaction(newTransaction);
    await fetchData();
  }

  Future<void> removeTransaction(String id) async {
    await _dbHelper.deleteTransaction(id);
    await fetchData();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ERPState(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TAJ AL AMAL ERP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.white,
          onPrimary: Colors.black,
          secondary: Colors.white,
          onSecondary: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF121212),
          onBackground: Colors.white,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainLayout(),
      },
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  static const List<String> _moduleTitles = [
    'Dashboard', 'CRM', 'Sales', 'Inventory', 'Accounting', 'HR', 'Invoicing'
  ];

  final List<Widget> _moduleWidgets = [
    const DashboardModule(),
    const CRMModule(),
    const SalesModule(),
    const InventoryModule(),
    const AccountingModule(),
    const HRModule(),
    const InvoicingModule(),
  ];

  void _onSelectModule(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_moduleTitles[_selectedIndex]),
        actions: const [
          Icon(Icons.notifications),
          SizedBox(width: 16),
          CircleAvatar(backgroundImage: NetworkImage('https://placehold.co/100x100/')),
          SizedBox(width: 8),
          Text('Welcome, User'),
          SizedBox(width: 16),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: _onSelectModule,
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Icon(Icons.business, size: 48, color: Colors.blue),
                  SizedBox(height: 8),
                  Text('TAJ AL AMAL ERP', style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('CRM')),
              NavigationRailDestination(icon: Icon(Icons.shopping_cart), label: Text('Sales')),
              NavigationRailDestination(icon: Icon(Icons.inventory), label: Text('Inventory')),
              NavigationRailDestination(icon: Icon(Icons.account_balance), label: Text('Accounting')),
              NavigationRailDestination(icon: Icon(Icons.group), label: Text('HR')),
              NavigationRailDestination(icon: Icon(Icons.receipt), label: Text('Invoicing')),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _moduleWidgets[_selectedIndex]),
        ],
      ),
    );
  }
}


// --- Modules ---

class DashboardModule extends StatelessWidget {
  const DashboardModule({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Dashboard"));
}

class CRMModule extends StatefulWidget {
  const CRMModule({super.key});

  @override
  _CRMModuleState createState() => _CRMModuleState();
}

class _CRMModuleState extends State<CRMModule> {
  void _showCustomerDialog({Customer? customer}) {
    final _formKey = GlobalKey<FormState>();
    String name = customer?.name ?? '';
    String email = customer?.email ?? '';
    String phone = customer?.phone ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(customer == null ? 'Add Customer' : 'Edit Customer'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                  onSaved: (value) => name = value!,
                ),
                TextFormField(
                  initialValue: email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      value != null && !EmailValidator.validate(value) ? 'Invalid Email' : null,
                  onSaved: (value) => email = value!,
                ),
                TextFormField(
                  initialValue: phone,
                  decoration: const InputDecoration(labelText: 'Phone'),
                  validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                  onSaved: (value) => phone = value!,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final erpState = Provider.of<ERPState>(context, listen: false);
                  if (customer == null) {
                    erpState.addCustomer(name, email, phone);
                  } else {
                    erpState.updateCustomer(Customer(id: customer.id, name: name, email: email, phone: phone));
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Customer customer) {
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete ${customer.name}?'),
            actions: [
                TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                        Provider.of<ERPState>(context, listen: false).removeCustomer(customer.id);
                        Navigator.of(context).pop();
                    },
                ),
            ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final customers = Provider.of<ERPState>(context).customers;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCustomerDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return ListTile(
            title: Text(customer.name),
            subtitle: Text(customer.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showCustomerDialog(customer: customer)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(customer)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class SalesModule extends StatelessWidget {
  const SalesModule({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Sales"));
}


class InventoryModule extends StatefulWidget {
  const InventoryModule({super.key});

  @override
  _InventoryModuleState createState() => _InventoryModuleState();
}

class _InventoryModuleState extends State<InventoryModule> {
  void _showProductDialog({Product? product}) {
    final _formKey = GlobalKey<FormState>();
    String name = product?.name ?? '';
    String description = product?.description ?? '';
    double price = product?.price ?? 0.0;
    int stock = product?.stockQuantity ?? 0;
    String category = product?.category ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => name = value!,
                  ),
                  TextFormField(
                    initialValue: description,
                    decoration: const InputDecoration(labelText: 'Description'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => description = value!,
                  ),
                  TextFormField(
                    initialValue: price.toString(),
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (double.tryParse(value ?? '') == null) ? 'Invalid Number' : null,
                    onSaved: (value) => price = double.parse(value!),
                  ),
                   TextFormField(
                    initialValue: stock.toString(),
                    decoration: const InputDecoration(labelText: 'Stock Quantity'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (int.tryParse(value ?? '') == null) ? 'Invalid Number' : null,
                    onSaved: (value) => stock = int.parse(value!),
                  ),
                   TextFormField(
                    initialValue: category,
                    decoration: const InputDecoration(labelText: 'Category'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => category = value!,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final erpState = Provider.of<ERPState>(context, listen: false);
                  if (product == null) {
                    erpState.addProduct(name, description, price, stock, category);
                  } else {
                    erpState.updateProduct(Product(id: product.id, name: name, description: description, price: price, stockQuantity: stock, category: category));
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Product product) {
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete ${product.name}?'),
            actions: [
                TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                        Provider.of<ERPState>(context, listen: false).removeProduct(product.id);
                        Navigator.of(context).pop();
                    },
                ),
            ],
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ERPState>(context).products;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showProductDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('Stock: ${product.stockQuantity} - \$${product.price.toStringAsFixed(2)}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showProductDialog(product: product)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(product)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class HRModule extends StatefulWidget {
  const HRModule({super.key});

  @override
  _HRModuleState createState() => _HRModuleState();
}

class _HRModuleState extends State<HRModule> {
  void _showEmployeeDialog({Employee? employee}) {
    final _formKey = GlobalKey<FormState>();
    String name = employee?.name ?? '';
    String position = employee?.position ?? '';
    String department = employee?.department ?? '';
    double salary = employee?.salary ?? 0.0;
    String email = employee?.email ?? '';
    String phone = employee?.phone ?? '';


    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(employee == null ? 'Add Employee' : 'Edit Employee'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => name = value!,
                  ),
                  TextFormField(
                    initialValue: email,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        value != null && !EmailValidator.validate(value) ? 'Invalid Email' : null,
                    onSaved: (value) => email = value!,
                ),
                TextFormField(
                    initialValue: phone,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => phone = value!,
                ),
                  TextFormField(
                    initialValue: position,
                    decoration: const InputDecoration(labelText: 'Position'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => position = value!,
                  ),
                  TextFormField(
                    initialValue: department,
                    decoration: const InputDecoration(labelText: 'Department'),
                    validator: (value) => (value?.isEmpty ?? true) ? 'Required' : null,
                    onSaved: (value) => department = value!,
                  ),
                  TextFormField(
                    initialValue: salary.toString(),
                    decoration: const InputDecoration(labelText: 'Salary'),
                    keyboardType: TextInputType.number,
                    validator: (value) => (double.tryParse(value ?? '') == null) ? 'Invalid Number' : null,
                    onSaved: (value) => salary = double.parse(value!),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  final erpState = Provider.of<ERPState>(context, listen: false);
                  if (employee == null) {
                    erpState.addEmployee(name, position, department, salary, email, phone);
                  } else {
                    erpState.updateEmployee(Employee(id: employee.id, name: name, email: email, phone: phone, position: position, department: department, salary: salary, hireDate: employee.hireDate));
                  }
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(Employee employee) {
     showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text('Confirm Deletion'),
            content: Text('Are you sure you want to delete ${employee.name}?'),
            actions: [
                TextButton(child: const Text('Cancel'), onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: const Text('Delete'),
                    onPressed: () {
                        Provider.of<ERPState>(context, listen: false).removeEmployee(employee.id);
                        Navigator.of(context).pop();
                    },
                ),
            ],
        ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final employees = Provider.of<ERPState>(context).employees;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Employees'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showEmployeeDialog(),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final employee = employees[index];
          return ListTile(
            title: Text(employee.name),
            subtitle: Text('${employee.position} - ${employee.department}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEmployeeDialog(employee: employee)),
                IconButton(icon: const Icon(Icons.delete), onPressed: () => _confirmDelete(employee)),
              ],
            ),
          );
        },
      ),
    );
  }
}

// --- Login/Signup Screens (Placeholder) ---

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login'),
            ElevatedButton(
              child: const Text('Go to Main App'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/main'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Sign Up')));
}
