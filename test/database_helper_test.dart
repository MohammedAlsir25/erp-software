import 'package:flutter_test/flutter_test.dart';
import 'package:taj_al_amal_erp/database/database_helper.dart';
import 'package:taj_al_amal_erp/models/user.dart';

void main() {
  group('DatabaseHelper Tests', () {
    late DatabaseHelper dbHelper;

    setUp(() async {
      dbHelper = DatabaseHelper();
      // Note: In a real test environment, you would mock the database
      // For now, we'll test the methods that don't require actual database operations
    });

    test('DatabaseHelper is a singleton', () {
      final dbHelper1 = DatabaseHelper();
      final dbHelper2 = DatabaseHelper();

      expect(dbHelper1, same(dbHelper2));
    });

    test('User JSON serialization works correctly', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        isVerified: false,
      );

      final json = user.toJson();
      final reconstructedUser = User.fromJson(json);

      expect(reconstructedUser.id, user.id);
      expect(reconstructedUser.username, user.username);
      expect(reconstructedUser.email, user.email);
      expect(reconstructedUser.password, user.password);
      expect(reconstructedUser.isVerified, user.isVerified);
    });

    test('User verification status can be updated', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        isVerified: false,
      );

      expect(user.isVerified, false);

      user.isVerified = true;

      expect(user.isVerified, true);
    });

    // Note: Integration tests for actual database operations would require
    // setting up a test database. For now, we focus on unit tests for the model.
    // In a production environment, you would use dependency injection or
    // mocking to test database operations properly.
  });
}
