import 'package:flutter/material.dart';
import 'package:ecomapp/screens/admin/admin_dashboard.dart';
import 'package:ecomapp/screens/admin/admin_services.dart';
import 'package:ecomapp/screens/admin/orders_screen.dart';
import 'package:ecomapp/screens/admin/users_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/user/home_screen.dart';
import 'screens/user/order/order_screen.dart';
import 'screens/user/order_history_screen.dart';

class Routes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const order = '/order';
  static const history = '/history';

 static const adminDashboard = '/admin/dashboard';
static const adminOrders = '/admin/orders';
static const adminUsers = '/admin/users';
// ignore: constant_identifier_names
static const AdminService = '/admin/AdminServiceScreen';

static Map<String, WidgetBuilder> getRoutes() {
  return {
    login: (_) => LoginScreen(),
    register: (_) => RegisterScreen(),
    home: (_) => HomeScreen(),
    order: (_) => PlaceOrderScreen(),
    history: (_) => OrderHistoryScreen(),
    adminDashboard: (_) => AdminDashboard(),
    adminOrders: (_) => AdminOrdersScreen(),
    adminUsers: (_) => AdminUsersScreen(),
    AdminService: (_) => AdminServiceScreen(),
  };
}
}