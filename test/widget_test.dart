// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stocking_billing_app/main.dart';
import 'package:stocking_billing_app/screens/auth/login_screen.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login screen is displayed
    expect(find.byType(LoginScreen), findsOneWidget);
    
    // Verify that the email field is present
    expect(find.byKey(const Key('emailField')), findsOneWidget);
    
    // Verify that the password field is present
    expect(find.byKey(const Key('passwordField')), findsOneWidget);
    
    // Verify that the login button is present
    expect(find.byKey(const Key('loginButton')), findsOneWidget);
  });
}
