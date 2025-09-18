import 'package:firebase_database/firebase_database.dart';
import '../models/user.dart';
import '../models/customer.dart';
import '../models/product.dart';
import '../models/sale.dart';
import '../models/employee.dart';
import '../models/transaction.dart';

class FirebaseDatabaseHelper {
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  // User
  Future<void> addUser(User user) async {
    await _dbRef.child('users').child(user.id).set(user.toJson());
  }

  Future<User?> getUser(String id) async {
    DataSnapshot snapshot = await _dbRef.child('users').child(id).get();
    if (snapshot.exists) {
      return User.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    await _dbRef.child('users').child(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String id) async {
    await _dbRef.child('users').child(id).remove();
  }

  // Customer
  Future<void> addCustomer(Customer customer) async {
    await _dbRef.child('customers').child(customer.id).set(customer.toJson());
  }

  Future<Customer?> getCustomer(String id) async {
    DataSnapshot snapshot = await _dbRef.child('customers').child(id).get();
    if (snapshot.exists) {
      return Customer.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<Customer>> getAllCustomers() async {
    DataSnapshot snapshot = await _dbRef.child('customers').get();
    if (snapshot.exists) {
      return (snapshot.value as Map).values.map((e) => Customer.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  Future<void> updateCustomer(Customer customer) async {
    await _dbRef.child('customers').child(customer.id).update(customer.toJson());
  }

  Future<void> deleteCustomer(String id) async {
    await _dbRef.child('customers').child(id).remove();
  }

  // Product
  Future<void> addProduct(Product product) async {
    await _dbRef.child('products').child(product.id).set(product.toJson());
  }

  Future<Product?> getProduct(String id) async {
    DataSnapshot snapshot = await _dbRef.child('products').child(id).get();
    if (snapshot.exists) {
      return Product.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<Product>> getAllProducts() async {
    DataSnapshot snapshot = await _dbRef.child('products').get();
    if (snapshot.exists) {
      return (snapshot.value as Map).values.map((e) => Product.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  Future<void> updateProduct(Product product) async {
    await _dbRef.child('products').child(product.id).update(product.toJson());
  }

  Future<void> deleteProduct(String id) async {
    await _dbRef.child('products').child(id).remove();
  }

  // Sale
  Future<void> addSale(Sale sale) async {
    await _dbRef.child('sales').child(sale.id).set(sale.toJson());
  }

  Future<Sale?> getSale(String id) async {
    DataSnapshot snapshot = await _dbRef.child('sales').child(id).get();
    if (snapshot.exists) {
      return Sale.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<Sale>> getAllSales() async {
    DataSnapshot snapshot = await _dbRef.child('sales').get();
    if (snapshot.exists) {
      return (snapshot.value as Map).values.map((e) => Sale.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  Future<void> updateSale(Sale sale) async {
    await _dbRef.child('sales').child(sale.id).update(sale.toJson());
  }

  Future<void> deleteSale(String id) async {
    await _dbRef.child('sales').child(id).remove();
  }

  // Employee
  Future<void> addEmployee(Employee employee) async {
    await _dbRef.child('employees').child(employee.id).set(employee.toJson());
  }

  Future<Employee?> getEmployee(String id) async {
    DataSnapshot snapshot = await _dbRef.child('employees').child(id).get();
    if (snapshot.exists) {
      return Employee.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<Employee>> getAllEmployees() async {
    DataSnapshot snapshot = await _dbRef.child('employees').get();
    if (snapshot.exists) {
      return (snapshot.value as Map).values.map((e) => Employee.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  Future<void> updateEmployee(Employee employee) async {
    await _dbRef.child('employees').child(employee.id).update(employee.toJson());
  }

  Future<void> deleteEmployee(String id) async {
    await _dbRef.child('employees').child(id).remove();
  }

  // Transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _dbRef.child('transactions').child(transaction.id).set(transaction.toJson());
  }

  Future<Transaction?> getTransaction(String id) async {
    DataSnapshot snapshot = await _dbRef.child('transactions').child(id).get();
    if (snapshot.exists) {
      return Transaction.fromJson(Map<String, dynamic>.from(snapshot.value as Map));
    }
    return null;
  }

  Future<List<Transaction>> getAllTransactions() async {
    DataSnapshot snapshot = await _dbRef.child('transactions').get();
    if (snapshot.exists) {
      return (snapshot.value as Map).values.map((e) => Transaction.fromJson(Map<String, dynamic>.from(e as Map))).toList();
    }
    return [];
  }

  Future<void> updateTransaction(Transaction transaction) async {
    await _dbRef.child('transactions').child(transaction.id).update(transaction.toJson());
  }

  Future<void> deleteTransaction(String id) async {
    await _dbRef.child('transactions').child(id).remove();
  }
}