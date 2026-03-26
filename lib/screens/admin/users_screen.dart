import 'package:flutter/material.dart';
import 'package:ecomapp/models/order_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  /// Get total orders for a user
  Future<int> getUserOrderCount(String userId) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService().getAllUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found"));
          }

          var users = snapshot.data!.docs;

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var userDoc = users[index];
              var userData = userDoc.data() as Map<String, dynamic>;
              String role = userData['role'] ?? 'user';

              return FutureBuilder<int>(
                future: getUserOrderCount(userDoc.id),
                builder: (context, orderSnapshot) {
                  int totalOrders = orderSnapshot.data ?? 0;

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: Text(userData['name'] ?? 'No Name'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Email: ${userData['email'] ?? 'No Email'}"),
                          Text("Role: $role"),
                          Text("Total Orders: $totalOrders"),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}