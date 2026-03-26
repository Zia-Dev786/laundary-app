import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ecomapp/models/order_service.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  /// Helper to get service name from serviceId
  Future<String> getServiceName(String serviceId) async {
    var doc = await OrderService().getServiceById(serviceId);
    var data = doc.data() as Map<String, dynamic>;
    return data['name'] ?? "Unknown Service";
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text('Order History')),
      body: StreamBuilder<QuerySnapshot>(
        stream: OrderService().getUserOrders(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No orders yet"));
          }

          var orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              var order = orders[index];
              var orderData = order.data() as Map<String, dynamic>;

              return FutureBuilder<String>(
                future: getServiceName(orderData['serviceId']),
                builder: (context, serviceSnapshot) {
                  String serviceName = serviceSnapshot.data ?? "Loading...";

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            serviceName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const SizedBox(height: 5),
                          Text("Status: ${orderData['status']}"),
                          Text("Pickup: ${DateFormat.yMd().format(orderData['pickupDate'].toDate())}"),
                          Text("Drop: ${DateFormat.yMd().format(orderData['dropDate'].toDate())}"),
                          Text("Address: ${orderData['address']}"),
                          const SizedBox(height: 5),
                          const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
                          ...List.generate(orderData['items'].length, (i) {
                            var item = orderData['items'][i];
                            return Text(
                              "${item['name']}: ${item['quantityKg']} kg x ₹${item['pricePerKg']} = ₹${item['total']}",
                            );
                          }),
                          const SizedBox(height: 5),
                          Text(
                            "Total Amount: ₹${orderData['totalAmount']}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
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