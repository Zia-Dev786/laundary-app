import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Place a new order
  Future<void> placeOrder({
    required String userId,
    required String serviceId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    required DateTime pickupDate,
    required DateTime dropDate,
    required String address,
  }) async {
    try {
      await _firestore.collection('orders').add({
        'userId': userId,
        'serviceId': serviceId,
        'items': items, // list of {name, quantityKg, pricePerKg, total}
        'totalAmount': totalAmount,
        'pickupDate': pickupDate,
        'dropDate': dropDate,
        'address': address,
        'status': 'Pending',
        'createdAt': FieldValue.serverTimestamp(),
      });
      Fluttertoast.showToast(msg: "Order placed successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error placing order: $e");
    }
  }

  /// Get orders for a specific user
  Stream<QuerySnapshot> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true) // use createdAt instead of date to avoid missing field issues
        .snapshots();
  }

  /// Get all orders (Admin)
  Stream<QuerySnapshot> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Update order status (Admin)
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({'status': status});
      Fluttertoast.showToast(msg: "Order status updated!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating status: $e");
    }
  }

  /// Get all users (Admin)
  Stream<QuerySnapshot> getAllUsers() {
    return _firestore.collection('users').snapshots();
  }

  /// Optional: Get service details by ID
  Future<DocumentSnapshot> getServiceById(String serviceId) async {
    return await _firestore.collection('services').doc(serviceId).get();
  }

  /// Optional: Get all active services (for user dropdown)
  Stream<QuerySnapshot> getActiveServices() {
    return _firestore.collection('services').where('isActive', isEqualTo: true).snapshots();
  }
}