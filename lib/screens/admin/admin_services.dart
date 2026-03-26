import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomapp/screens/widgets/custom_button.dart';

class AdminServiceScreen extends StatelessWidget {
  final _serviceNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;

  void addService() {
    _firestore.collection('services').add({
      'name': _serviceNameController.text,
      'pricePerKg': double.tryParse(_priceController.text) ?? 0,
      'description': _descriptionController.text,
      'isActive': true,
    });
  }

  void toggleService(String serviceId, bool currentStatus) {
    _firestore.collection('services').doc(serviceId).update({'isActive': !currentStatus});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Services")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(controller: _serviceNameController, decoration: InputDecoration(labelText: "Service Name")),
                TextField(controller: _priceController, decoration: InputDecoration(labelText: "Price per Kg"), keyboardType: TextInputType.number),
                TextField(controller: _descriptionController, decoration: InputDecoration(labelText: "Description")),
                CustomButton(text: "Add Service", onPressed: addService),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('services').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                var services = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    var service = services[index];
                    return ListTile(
                      title: Text("${service['name']} - ₹${service['pricePerKg']}"),
                      subtitle: Text(service['description']),
                      trailing: Switch(
                        value: service['isActive'],
                        onChanged: (val) => toggleService(service.id, service['isActive']),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}