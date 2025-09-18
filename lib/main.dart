import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/customer.dart';
import 'models/product.dart';
import 'models/sale.dart';
import 'models/employee.dart';
import 'models/transaction.dart';
import 'database/database_helper.dart';
import 'models/user.dart';
import 'package:email_validator/email_validator.dart';
import 'dart:math';

class ERPState extends ChangeNotifier {
  List<Customer> customers = [
    Customer(
        id: '1',
        name: 'Ahmed Hassan',
        email: 'ahmed@example.com',
        phone: '+971 50 123 4567'),
    Customer(
        id: '2',
        name: 'Fatima Ali',
        email: 'fatima@example.com',
        phone: '+971 50 234 5678'),
    Customer(
        id: '3',
        name: 'Imran Khan',
        email: 'imran@example.com',
        phone: '+971 50 345 6789'),
  ];

  List<Product> products = [
    Product(
        id: 'prod1',
        name: 'Laptop',
        description: 'High-performance laptop',
        price: 1200.0,
        stockQuantity: 50,
        category: 'Electronics'),
    Product(
        id: 'prod2',
        name: 'Mouse',
        description: 'Wireless mouse',
        price: 25.0,
        stockQuantity: 200,
        category: 'Accessories'),
    Product(
        id: 'prod3',
        name: 'Keyboard',
        description: 'Mechanical keyboard',
        price: 80.0,
        stockQuantity: 100,
        category: 'Accessories'),
  ];
  List<Sale> sales = [];
  List<Employee> employees = [];
  List<Transaction> transactions = [
    Transaction(
      id: 'trans1',
      type: 'income',
      amount: 5000.0,
      date: DateTime.now().subtract(const Duration(days: 1)),
      description: 'Sale of products',
      category: 'Sales',
    ),
    Transaction(
      id: 'trans2',
      type: 'expense',
      amount: 2000.0,
      date: DateTime.now().subtract(const Duration(days: 2)),
      description: 'Office supplies',
      category: 'Operations',
    ),
  ];

  void addCustomer(String id, String name, String email, String phone) {
    customers.add(Customer(id: id, name: name, email: email, phone: phone));
    notifyListeners();
  }

  void removeCustomer(int index) {
    customers.removeAt(index);
    notifyListeners();
  }

  void updateCustomer(int index, String name, String email, String phone) {
    customers[index] = Customer(
        id: customers[index].id, name: name, email: email, phone: phone);
    notifyListeners();
  }

  void addSale(String customerId, List<String> productIds, double totalAmount,
      String status) {
    String id = 'sale_${DateTime.now().millisecondsSinceEpoch}';
    sales.add(Sale(
      id: id,
      customerId: customerId,
      productIds: productIds,
      totalAmount: totalAmount,
      date: DateTime.now(),
      status: status,
    ));
    notifyListeners();
  }

  void removeSale(int index) {
    sales.removeAt(index);
    notifyListeners();
  }

  void addProduct(String id, String name, String description, double price,
      int stockQuantity, String category) {
    products.add(Product(
      id: id,
      name: name,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      category: category,
    ));
    notifyListeners();
  }

  void removeProduct(int index) {
    products.removeAt(index);
    notifyListeners();
  }

  void updateProduct(int index, String name, String description, double price,
      int stockQuantity, String category) {
    products[index] = Product(
      id: products[index].id,
      name: name,
      description: description,
      price: price,
      stockQuantity: stockQuantity,
      category: category,
    );
    notifyListeners();
  }

  void updateStock(String productId, int newStock) {
    final productIndex = products.indexWhere((p) => p.id == productId);
    if (productIndex != -1) {
      products[productIndex] = Product(
        id: products[productIndex].id,
        name: products[productIndex].name,
        description: products[productIndex].description,
        price: products[productIndex].price,
        stockQuantity: newStock,
        category: products[productIndex].category,
      );
      notifyListeners();
    }
  }

  void addTransaction(
      String type, double amount, String description, String category) {
    String id = 'trans_${DateTime.now().millisecondsSinceEpoch}';
    transactions.add(Transaction(
      id: id,
      type: type,
      amount: amount,
      date: DateTime.now(),
      description: description,
      category: category,
    ));
    notifyListeners();
  }

  void removeTransaction(int index) {
    transactions.removeAt(index);
    notifyListeners();
  }

  void addEmployee(String id, String name, String position, String department,
      double salary) {
    employees.add(Employee(
      id: id,
      name: name,
      email: '',
      phone: '',
      position: position,
      department: department,
      salary: salary,
      hireDate: DateTime.now(),
    ));
    notifyListeners();
  }

  void removeEmployee(int index) {
    employees.removeAt(index);
    notifyListeners();
  }

  void updateEmployee(int index, String name, String position,
      String department, double salary) {
    employees[index] = Employee(
      id: employees[index].id,
      name: name,
      email: employees[index].email,
      phone: employees[index].phone,
      position: position,
      department: department,
      salary: salary,
      hireDate: employees[index].hireDate,
    );
    notifyListeners();
  }
}

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ERPState()),
      ],
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
          primary: Colors.white, // Changed from green to white
          onPrimary: Colors.black, // Changed to black for visibility on white
          secondary: Colors.white, // Changed from green to white
          onSecondary: Colors.black, // Changed to black for visibility on white
          error: Colors.red,
          onError: Colors.white,
          background: Color(0xFF121212), // Dark background
          onBackground: Colors.white,
          surface: Color(0xFF1E1E1E),
          onSurface: Colors.white,
        ),
        fontFamily: 'Roboto', // Use a modern, professional font
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  static const List<String> _moduleTitles = [
    'Dashboard',
    'CRM',
    'Sales',
    'Inventory',
    'Accounting',
    'HR',
    'Wave Features', // Added Wave Features title
  ];

  final List<Widget> _moduleWidgets = [
    const DashboardModule(),
    const CRMModule(),
    const SalesModule(),
    const InventoryModule(),
    const AccountingModule(),
    const HRModule(),
    const WaveFeaturesModule(), // Added Wave Features module
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSelectModule(int index) {
    setState(() {
      _selectedIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  Widget buildSidebar() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      onDestinationSelected: _onSelectModule,
      labelType: NavigationRailLabelType.all,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: const [
            Icon(Icons.business, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text('TAJ AL AMAL ERP',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
      destinations: const [
        NavigationRailDestination(
            icon: Icon(Icons.dashboard), label: Text('Dashboard')),
        NavigationRailDestination(icon: Icon(Icons.people), label: Text('CRM')),
        NavigationRailDestination(
            icon: Icon(Icons.shopping_cart), label: Text('Sales')),
        NavigationRailDestination(
            icon: Icon(Icons.inventory), label: Text('Inventory')),
        NavigationRailDestination(
            icon: Icon(Icons.account_balance), label: Text('Accounting')),
        NavigationRailDestination(icon: Icon(Icons.group), label: Text('HR')),
        NavigationRailDestination(
            icon: Icon(Icons.waves), label: Text('Wave Features')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_moduleTitles[_selectedIndex]),
        actions: [
          const Icon(Icons.notifications),
          const SizedBox(width: 16),
          CircleAvatar(
            backgroundImage: NetworkImage('https://placehold.co/100x100/'),
            radius: 16,
            onBackgroundImageError: (_, __) => Container(
                color: Colors.blue,
                child: const Icon(Icons.person, color: Colors.white)),
          ),
          const SizedBox(width: 8),
          const Text('Welcome, User'),
        ],
      ),
      body: Row(
        children: [
          buildSidebar(),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: _moduleWidgets[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  String? _verificationCode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _signUp() async {
    String username = _usernameController.text.trim();
    String email = _emailController.text.trim();
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    // Check if user already exists
    User? existingUser = await _dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User with this email already exists')),
      );
      return;
    }

    // Generate verification code
    String verificationCode = (Random().nextInt(900000) + 100000).toString();

    // Create user
    User newUser = User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: username,
      email: email,
      password: password,
      isVerified: false,
    );

    await _dbHelper.insertUser(newUser);

    // Show verification code dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verification Code'),
        content: Text('Your verification code is: $verificationCode'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => EmailVerificationScreen(
                    email: email,
                    verificationCode: verificationCode,
                    dbHelper: _dbHelper,
                  ),
                ),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity:
                _animationController.drive(CurveTween(curve: Curves.easeInOut)),
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business,
                      size: 72,
                      color: colorScheme.primary,
                      semanticLabel:
                          'Company building icon representing TAJ AL AMAL ERP',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon:
                            Icon(Icons.person, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon:
                            Icon(Icons.lock, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _signUp,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Sign Up',
                            style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: Text(
                        'Already have an account? Login',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    User? user = await _dbHelper.getUserByEmail(email);
    if (user == null || user.password != password) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
      return;
    }

    if (!user.isVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please verify your email first')),
      );
      return;
    }

    // Navigate to main app
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainLayout()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: 420,
              padding: const EdgeInsets.all(32),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.1),
                    spreadRadius: 8,
                    blurRadius: 24,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.business,
                      size: 72,
                      color: colorScheme.primary,
                      semanticLabel:
                          'Company building icon representing TAJ AL AMAL ERP',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            Icon(Icons.email, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            Icon(Icons.lock, color: colorScheme.primary),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _login,
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            const Text('Login', style: TextStyle(fontSize: 16)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        'Don\'t have an account? Sign Up',
                        style: TextStyle(color: colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EmailVerificationScreen extends StatefulWidget {
  final String email;
  final String verificationCode;
  final DatabaseHelper dbHelper;

  const EmailVerificationScreen({
    super.key,
    required this.email,
    required this.verificationCode,
    required this.dbHelper,
  });

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final TextEditingController _codeController = TextEditingController();

  void _verify() async {
    if (_codeController.text == widget.verificationCode) {
      User? user = await widget.dbHelper.getUserByEmail(widget.email);
      if (user != null) {
        user.isVerified = true;
        await widget.dbHelper.updateUser(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully!')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid verification code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 15,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.email,
                size: 64,
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              const Text(
                'Email Verification',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter the verification code sent to ${widget.email}',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Your verification code is: ${widget.verificationCode}',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                    labelText: 'Verification Code',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Color(0xFF686868),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    )),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _verify,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100, vertical: 16)),
                child: const Text('Verify'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CRMModule extends StatefulWidget {
  const CRMModule({super.key});

  @override
  State<CRMModule> createState() => _CRMModuleState();
}

class _CRMModuleState extends State<CRMModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Relationship Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _addCustomer(context),
            child: const Text('Add Customer'),
          ),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.customers.length,
            itemBuilder: (context, index) {
              final customer = state.customers[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(customer.name[0]),
                  ),
                  title: Text(customer.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(customer.email),
                      Text(customer.phone),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _editCustomer(context, index, customer),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteCustomer(context, index),
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

  void _addCustomer(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '', email = '', phone = '';
        return AlertDialog(
          title: const Text('Add New Customer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  onChanged: (value) => phone = value,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Add Customer'),
                        content:
                            Text('Name: $name\nEmail: $email\nPhone: $phone'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              String id =
                                  'cust_${DateTime.now().millisecondsSinceEpoch}';
                              Provider.of<ERPState>(context, listen: false)
                                  .addCustomer(id, name, email, phone);
                              Navigator.of(context).pop(); // close confirmation
                              Navigator.of(context).pop(); // close add dialog
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editCustomer(BuildContext context, int index, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = customer.name;
        String email = customer.email;
        String phone = customer.phone;
        return AlertDialog(
          title: const Text('Edit Customer'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: TextEditingController(text: email),
                  onChanged: (value) => email = value,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: TextEditingController(text: phone),
                  onChanged: (value) => phone = value,
                  decoration: const InputDecoration(labelText: 'Phone'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty) {
                  Provider.of<ERPState>(context, listen: false)
                      .updateCustomer(index, name, email, phone);
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

  void _confirmDeleteCustomer(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this customer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false)
                    .removeCustomer(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class SalesModule extends StatefulWidget {
  const SalesModule({super.key});

  @override
  State<SalesModule> createState() => _SalesModuleState();
}

class _SalesModuleState extends State<SalesModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _createSale(context),
            child: const Text('Create Sale'),
          ),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.sales.length,
            itemBuilder: (context, index) {
              final sale = state.sales[index];
              final customer = state.customers.firstWhere(
                (c) => c.id == sale.customerId,
                orElse: () =>
                    Customer(id: '', name: 'Unknown', email: '', phone: ''),
              );
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Text(sale.id.substring(0, 1).toUpperCase()),
                  ),
                  title: Text('Sale ${sale.id}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: ${customer.name}'),
                      Text('Total: \$${sale.totalAmount.toStringAsFixed(2)}'),
                      Text('Date: ${sale.date.toString().split(' ')[0]}'),
                      Text('Status: ${sale.status}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _confirmDeleteSale(context, index),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _createSale(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String selectedCustomerId = '';
        List<String> selectedProductIds = [];
        double totalAmount = 0.0;
        String status = 'Pending';

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Create New Sale'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Consumer<ERPState>(
                      builder: (context, state, child) {
                        return DropdownButtonFormField<String>(
                          value: selectedCustomerId.isEmpty
                              ? null
                              : selectedCustomerId,
                          hint: const Text('Select Customer'),
                          items: state.customers.map((customer) {
                            return DropdownMenuItem<String>(
                              value: customer.id,
                              child: Text(customer.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedCustomerId = value ?? '';
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Consumer<ERPState>(
                      builder: (context, state, child) {
                        return Column(
                          children: state.products.map((product) {
                            return CheckboxListTile(
                              title:
                                  Text('${product.name} - \$${product.price}'),
                              value: selectedProductIds.contains(product.id),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value == true) {
                                    selectedProductIds.add(product.id);
                                    totalAmount += product.price;
                                  } else {
                                    selectedProductIds.remove(product.id);
                                    totalAmount -= product.price;
                                  }
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('Total: \$${totalAmount.toStringAsFixed(2)}'),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: status,
                      items: ['Pending', 'Completed', 'Cancelled']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          status = value ?? 'Pending';
                        });
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (selectedCustomerId.isNotEmpty &&
                        selectedProductIds.isNotEmpty) {
                      Provider.of<ERPState>(context, listen: false).addSale(
                          selectedCustomerId,
                          selectedProductIds,
                          totalAmount,
                          status);
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Create'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _confirmDeleteSale(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this sale?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false).removeSale(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String id = '', name = '', description = '', category = '';
        double price = 0.0;
        int stock = 0;
        return AlertDialog(
          title: const Text('Add New Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => id = value,
                  decoration: const InputDecoration(labelText: 'Product ID'),
                ),
                TextField(
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  onChanged: (value) => description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  onChanged: (value) => price = double.tryParse(value) ?? 0.0,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => stock = int.tryParse(value) ?? 0,
                  decoration:
                      const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => category = value,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (id.isNotEmpty &&
                    name.isNotEmpty &&
                    price > 0 &&
                    stock >= 0 &&
                    category.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Add Product'),
                        content: Text(
                            'ID: $id\nName: $name\nDescription: $description\nPrice: $price\nStock: $stock\nCategory: $category'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Provider.of<ERPState>(context, listen: false)
                                  .addProduct(id, name, description, price,
                                      stock, category);
                              Navigator.of(context).pop(); // close confirmation
                              Navigator.of(context).pop(); // close add dialog
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editProduct(BuildContext context, int index, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = product.name;
        String description = product.description;
        double price = product.price;
        int stock = product.stockQuantity;
        String category = product.category;
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: TextEditingController(text: description),
                  onChanged: (value) => description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: TextEditingController(text: price.toString()),
                  onChanged: (value) => price = double.tryParse(value) ?? price,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(text: stock.toString()),
                  onChanged: (value) => stock = int.tryParse(value) ?? stock,
                  decoration:
                      const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: TextEditingController(text: category),
                  onChanged: (value) => category = value,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty &&
                    price > 0 &&
                    stock >= 0 &&
                    category.isNotEmpty) {
                  Provider.of<ERPState>(context, listen: false).updateProduct(
                      index, name, description, price, stock, category);
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

  void _confirmDeleteProduct(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false)
                    .removeProduct(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class AccountingModule extends StatefulWidget {
  const AccountingModule({super.key});

  @override
  State<AccountingModule> createState() => _AccountingModuleState();
}

class _AccountingModuleState extends State<AccountingModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounting Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _addTransaction(context),
            child: const Text('Add Transaction'),
          ),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.transactions.length,
            itemBuilder: (context, index) {
              final transaction = state.transactions[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: transaction.type == 'income'
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      transaction.type == 'income'
                          ? Icons.arrow_upward
                          : Icons.arrow_downward,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(transaction.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Category: ${transaction.category}'),
                      Text(
                          'Date: ${transaction.date.toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('\$${transaction.amount.toStringAsFixed(2)}'),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () =>
                            _confirmDeleteTransaction(context, index),
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

  void _addTransaction(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String type = 'income';
        double amount = 0.0;
        String description = '';
        String category = '';
        return AlertDialog(
          title: const Text('Add New Transaction'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: type,
                  items: ['income', 'expense'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    type = value ?? 'income';
                  },
                ),
                TextField(
                  onChanged: (value) => amount = double.tryParse(value) ?? 0.0,
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  onChanged: (value) => description = value,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  onChanged: (value) => category = value,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (amount > 0 &&
                    description.isNotEmpty &&
                    category.isNotEmpty) {
                  Provider.of<ERPState>(context, listen: false)
                      .addTransaction(type, amount, description, category);
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

  void _confirmDeleteTransaction(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content:
              const Text('Are you sure you want to delete this transaction?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false)
                    .removeTransaction(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class DashboardModule extends StatelessWidget {
  const DashboardModule({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Consumer<ERPState>(
          builder: (context, state, child) {
            double totalIncome = state.transactions
                .where((t) => t.type == 'income')
                .fold(0.0, (sum, t) => sum + t.amount);
            double totalExpense = state.transactions
                .where((t) => t.type == 'expense')
                .fold(0.0, (sum, t) => sum + t.amount);
            double balance = totalIncome - totalExpense;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: Theme.of(context).textTheme.headline4),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildDashboardCard(context, Icons.people, 'Customers',
                        state.customers.length.toString(), Colors.green),
                    const SizedBox(width: 16),
                    _buildDashboardCard(context, Icons.shopping_cart, 'Sales',
                        state.sales.length.toString(), Colors.blue),
                    const SizedBox(width: 16),
                    _buildDashboardCard(context, Icons.inventory, 'Products',
                        state.products.length.toString(), Colors.orange),
                    const SizedBox(width: 16),
                    _buildDashboardCard(context, Icons.group, 'Employees',
                        state.employees.length.toString(), Colors.purple),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    _buildDashboardCard(
                        context,
                        Icons.attach_money,
                        'Total Income',
                        '\$${totalIncome.toStringAsFixed(2)}',
                        Colors.green),
                    const SizedBox(width: 16),
                    _buildDashboardCard(
                        context,
                        Icons.money_off,
                        'Total Expense',
                        '\$${totalExpense.toStringAsFixed(2)}',
                        Colors.red),
                    const SizedBox(width: 16),
                    _buildDashboardCard(
                        context,
                        Icons.account_balance,
                        'Balance',
                        '\$${balance.toStringAsFixed(2)}',
                        Colors.blue),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Recent Transactions',
                    style: Theme.of(context).textTheme.headline6),
                const SizedBox(height: 8),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = state.transactions[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: transaction.type == 'income'
                              ? Colors.green
                              : Colors.red,
                          child: Icon(
                            transaction.type == 'income'
                                ? Icons.arrow_upward
                                : Icons.arrow_downward,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(transaction.description),
                        subtitle: Text(
                            '${transaction.category} - ${transaction.date.toString().split(' ')[0]}'),
                        trailing:
                            Text('\$${transaction.amount.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboardCard(BuildContext context, IconData icon, String title,
      String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, color: color, size: 48),
              const SizedBox(height: 8),
              Text(value,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              Text(title, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}

class HRModule extends StatefulWidget {
  const HRModule({super.key});

  @override
  State<HRModule> createState() => _HRModuleState();
}

class _HRModuleState extends State<HRModule> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Human Resources Management'),
        actions: [
          ElevatedButton(
            onPressed: () => _addEmployee(context),
            child: const Text('Add Employee'),
          ),
        ],
      ),
      body: Consumer<ERPState>(
        builder: (context, state, child) {
          return ListView.builder(
            itemCount: state.employees.length,
            itemBuilder: (context, index) {
              final employee = state.employees[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(employee.name[0]),
                  ),
                  title: Text(employee.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Position: ${employee.position}'),
                      Text('Salary: \$${employee.salary.toStringAsFixed(2)}'),
                      Text('Department: ${employee.department}'),
                      Text(
                          'Hire Date: ${employee.hireDate.toString().split(' ')[0]}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () =>
                            _editEmployee(context, index, employee),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _confirmDeleteEmployee(context, index),
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

  void _addEmployee(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = '', position = '', department = '';
        double salary = 0.0;
        return AlertDialog(
          title: const Text('Add New Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => position = value,
                  decoration: const InputDecoration(labelText: 'Position'),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => department = value,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                const SizedBox(height: 16),
                TextField(
                  onChanged: (value) => salary = double.tryParse(value) ?? 0.0,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty &&
                    position.isNotEmpty &&
                    department.isNotEmpty &&
                    salary > 0) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Add Employee'),
                        content: Text(
                            'Name: $name\nPosition: $position\nDepartment: $department\nSalary: $salary'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              String id =
                                  'emp_${DateTime.now().millisecondsSinceEpoch}';
                              Provider.of<ERPState>(context, listen: false)
                                  .addEmployee(
                                      id, name, position, department, salary);
                              Navigator.of(context).pop(); // close confirmation
                              Navigator.of(context).pop(); // close add dialog
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editEmployee(BuildContext context, int index, Employee employee) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String name = employee.name;
        String position = employee.position;
        String department = employee.department;
        double salary = employee.salary;
        return AlertDialog(
          title: const Text('Edit Employee'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: TextEditingController(text: name),
                  onChanged: (value) => name = value,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: position),
                  onChanged: (value) => position = value,
                  decoration: const InputDecoration(labelText: 'Position'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: department),
                  onChanged: (value) => department = value,
                  decoration: const InputDecoration(labelText: 'Department'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(text: salary.toString()),
                  onChanged: (value) =>
                      salary = double.tryParse(value) ?? salary,
                  decoration: const InputDecoration(labelText: 'Salary'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (name.isNotEmpty &&
                    position.isNotEmpty &&
                    department.isNotEmpty &&
                    salary > 0) {
                  Provider.of<ERPState>(context, listen: false).updateEmployee(
                      index, name, position, department, salary);
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

  void _confirmDeleteEmployee(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this employee?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<ERPState>(context, listen: false)
                    .removeEmployee(index);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
