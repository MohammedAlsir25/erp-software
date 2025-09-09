import 'package:flutter_test/flutter_test.dart';
import 'package:taj_al_amal_erp/models/user.dart';

void main() {
  group('User Model Tests', () {
    test('User constructor creates user with correct values', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        isVerified: true,
      );

      expect(user.id, 'test_id');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.password, 'password123');
      expect(user.isVerified, true);
    });

    test('User constructor defaults isVerified to false', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
      );

      expect(user.isVerified, false);
    });

    test('User.fromJson creates user from JSON map', () {
      final json = {
        'id': 'test_id',
        'username': 'testuser',
        'email': 'test@example.com',
        'password': 'password123',
        'isVerified': 1,
      };

      final user = User.fromJson(json);

      expect(user.id, 'test_id');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.password, 'password123');
      expect(user.isVerified, true);
    });

    test('User.fromJson handles isVerified as 0 (false)', () {
      final json = {
        'id': 'test_id',
        'username': 'testuser',
        'email': 'test@example.com',
        'password': 'password123',
        'isVerified': 0,
      };

      final user = User.fromJson(json);

      expect(user.isVerified, false);
    });

    test('User.toJson converts user to JSON map', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        isVerified: true,
      );

      final json = user.toJson();

      expect(json['id'], 'test_id');
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
      expect(json['isVerified'], 1);
    });

    test('User.toJson converts isVerified false to 0', () {
      final user = User(
        id: 'test_id',
        username: 'testuser',
        email: 'test@example.com',
        password: 'password123',
        isVerified: false,
      );

      final json = user.toJson();

      expect(json['isVerified'], 0);
    });
  });
}
