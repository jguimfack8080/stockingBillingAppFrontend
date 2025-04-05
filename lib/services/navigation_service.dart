import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentState?.context;

  static Future<dynamic> navigateTo(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    navigatorKey.currentState!.pop();
  }

  static Future<dynamic> replaceWith(String routeName, {dynamic arguments}) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName, arguments: arguments);
  }
}