import 'package:flutter/material.dart';
import 'package:ecomapp/models/auth_service.dart';
import 'package:ecomapp/routes.dart';
import 'package:ecomapp/screens/widgets/custom_button.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void login() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please fill all fields");
      return;
    }

    AuthService().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
      onSuccess: (role) {
        if (role == "admin") {
          Navigator.pushReplacementNamed(context, Routes.adminDashboard);
        } else {
          Navigator.pushReplacementNamed(context, Routes.home);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            CustomButton(text: "Login", onPressed: login),
            TextButton(onPressed: (){
              Navigator.pushReplacementNamed(context, '/register');
            }, child: Text('Register'))
          ],
        ),
      ),
    );
  }
}