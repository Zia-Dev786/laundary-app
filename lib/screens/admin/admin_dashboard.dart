import 'package:flutter/material.dart';
import 'package:ecomapp/models/auth_service.dart';
import 'package:ecomapp/routes.dart';
import 'package:ecomapp/screens/widgets/custom_button.dart';
import '../../constants/colors.dart';
import '../../constants/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  /// Helper to get count of documents with optional condition
  Future<int> getCount({String? collection, String? field, String? value}) async {
    Query query = FirebaseFirestore.instance.collection(collection!);
    if (field != null && value != null) {
      query = query.where(field, isEqualTo: value);
    }
    var snapshot = await query.get();
    return snapshot.docs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: AppColors.primary,
        actions: [IconButton(onPressed: (){
          Navigator.pushNamed(context, Routes.AdminService);
        }, icon: Icon(Icons.add)),
        IconButton(onPressed: (){
          AuthService().logout().then((e)=>{
          Navigator.pushNamed(context, Routes.login)
          });
          
        }, icon: Icon(Icons.logout))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Stats Cards
            FutureBuilder<List<int>>(
              future: Future.wait([
                getCount(collection: 'orders'), // total orders
                getCount(collection: 'orders', field: 'status', value: 'Pending'),
                getCount(collection: 'orders', field: 'status', value: 'Completed'),
                getCount(collection: 'users'),
              ]),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const CircularProgressIndicator();

                var totalOrders = snapshot.data![0];
                var pending = snapshot.data![1];
                var completed = snapshot.data![2];
                var users = snapshot.data![3];

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Total Orders', totalOrders.toString(), Colors.blue),
                        _buildStatCard('Pending', pending.toString(), Colors.orange),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildStatCard('Completed', completed.toString(), Colors.green),
                        _buildStatCard('Users', users.toString(), Colors.purple),
                      ],
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 40),
            CustomButton(
              text: 'Manage Orders',
              onPressed: () {
                Navigator.pushNamed(context, Routes.adminOrders);
              },
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Manage Users',
              onPressed: () {
                Navigator.pushNamed(context, Routes.adminUsers);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 10),
          Text(title, style: Styles.subHeading),
        ],
      ),
    );
  }
}