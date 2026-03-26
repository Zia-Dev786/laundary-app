import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ServiceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new service
  Future<void> addService(Service service) async {
    try {
      await _firestore.collection('services').add(service.toMap());
      Fluttertoast.showToast(msg: "Service added successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error adding service: $e");
    }
  }

  /// Get all services (stream for real-time updates)
  Stream<QuerySnapshot> getAllServices() {
    return _firestore.collection('services').snapshots();
  }

  /// Get a single service by ID
  Future<DocumentSnapshot> getServiceById(String serviceId) async {
    return await _firestore.collection('services').doc(serviceId).get();
  }

  /// Update an existing service
  Future<void> updateService(Service service) async {
    try {
      await _firestore.collection('services').doc(service.id).update(service.toMap());
      Fluttertoast.showToast(msg: "Service updated successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating service: $e");
    }
  }

  /// Delete a service
  Future<void> deleteService(String serviceId) async {
    try {
      await _firestore.collection('services').doc(serviceId).delete();
      Fluttertoast.showToast(msg: "Service deleted successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error deleting service: $e");
    }
  }
}

class Service {
  String id;
  String name;
  double pricePerKg;
  String description;
  bool isActive;

  Service({
    required this.id,
    required this.name,
    required this.pricePerKg,
    required this.description,
    required this.isActive,
  });

  /// Create a Service object from Firestore document
  factory Service.fromMap(String id, Map<String, dynamic> data) {
    return Service(
      id: id,
      name: data['name'] ?? '',
      pricePerKg: (data['pricePerKg'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      isActive: data['isActive'] ?? true,
    );
  }

  /// Convert Service object to Map to store in Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'pricePerKg': pricePerKg,
      'description': description,
      'isActive': isActive,
    };
  }
}