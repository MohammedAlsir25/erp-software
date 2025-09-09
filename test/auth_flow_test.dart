import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taj_al_amal_erp/main.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  testWidgets('Sign up, email verification, and login flow',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify we are on the LoginScreen by checking for unique text
    expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);

    // Navigate to Sign Up screen
    await tester.tap(find.text('Don\'t have an account? Sign Up'));
    await tester.pumpAndSettle();

    // Verify we are on the SignUpScreen
    expect(find.text('Already have an account? Login'), findsOneWidget);

    // Fill in sign up form with valid data
    await tester.enterText(find.bySemanticsLabel('Username'), 'testuser2');
    await tester.enterText(
        find.bySemanticsLabel('Email'), 'testuser2@example.com');
    await tester.enterText(find.bySemanticsLabel('Password'), 'password123');
    await tester.enterText(
        find.bySemanticsLabel('Confirm Password'), 'password123');

    // Tap Sign Up button
    await tester.tap(find.text('Sign Up').last);
    await tester.pumpAndSettle();

    // Expect to see verification code dialog
    expect(find.textContaining('Your verification code is:'), findsOneWidget);

    // Tap OK to close dialog and navigate to EmailVerificationScreen
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify we are on EmailVerificationScreen
    expect(find.text('Email Verification'), findsOneWidget);

    // Enter incorrect verification code and verify error snackbar
    await tester.enterText(
        find.bySemanticsLabel('Verification Code'), '000000');
    await tester.tap(find.text('Verify'));
    await tester.pump(); // Start animation
    await tester
        .pump(const Duration(seconds: 1)); // Wait for snackbar to appear

    expect(find.text('Invalid verification code'), findsOneWidget);

    // Enter correct verification code (simulate by reading from widget tree)
    final verificationCodeText = find
        .textContaining('Your verification code is:')
        .evaluate()
        .single
        .widget as Text;
    final code = verificationCodeText.data!.split(': ')[1].split('\n')[0];

    await tester.enterText(find.bySemanticsLabel('Verification Code'), code);
    await tester.tap(find.text('Verify'));
    await tester.pumpAndSettle();

    // After successful verification, should navigate back to LoginScreen
    expect(find.text('Don\'t have an account? Sign Up'), findsOneWidget);

    // Enter login credentials
    await tester.enterText(
        find.bySemanticsLabel('Email'), 'testuser2@example.com');
    await tester.enterText(find.bySemanticsLabel('Password'), 'password123');

    // Tap Login button
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    // Verify we are navigated to MainLayout (Dashboard title visible)
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
