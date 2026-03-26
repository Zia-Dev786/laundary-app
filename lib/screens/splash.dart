
// // Decide where to go on app start
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:ecomapp/routes.dart';

// class SplashRouter extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     User? user = FirebaseAuth.instance.currentUser;

//     if (user != null) {
//       // User logged in, get role
//       return FutureBuilder<DocumentSnapshot>(
//         future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Scaffold(body: Center(child: CircularProgressIndicator()));
//           String role = snapshot.data!['role'];
//           if (role == 'admin') {
//             return Routes.adminDashboardPage();
//           } else {
//             return Routes.homePage();
//           }
//         },
//       );
//     } else {
//       // Not logged in
//       return Routes.loginPage();
//     }
//   }
// }