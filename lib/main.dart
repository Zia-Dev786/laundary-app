import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ecomapp/firebase_options.dart';
import 'package:ecomapp/routes.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp( LaundryApp());
}
class LaundryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Laundry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: Routes.login,
      routes: Routes.getRoutes(),
    );
  }
}