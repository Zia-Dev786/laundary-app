import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecomapp/models/order_service.dart';
import 'package:ecomapp/models/service_services.dart';
import '../../widgets/custom_button.dart';

class PlaceOrderScreen extends StatefulWidget {
  const PlaceOrderScreen({super.key});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  final _addressController = TextEditingController();

  String? selectedServiceId;
  Map<String, dynamic>? selectedService;

  final List<Map<String, dynamic>> _items = [];
  DateTime? pickupDate;
  DateTime? dropDate;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get service passed from HomeScreen
    final args = ModalRoute.of(context)!.settings.arguments;
    if (args != null && args is Service) {
      selectedServiceId = args.id;
      selectedService = {
        'name': args.name,
        'pricePerKg': args.pricePerKg,
        'description': args.description,
        'isActive': args.isActive,
      };
    }
  }

  /// Total amount
  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + (item['quantityKg'] * item['pricePerKg']));
  }

  /// Add a new item
  void addItem() {
    final nameController = TextEditingController();
    final kgController = TextEditingController();
    final priceController = TextEditingController(
        text: selectedService != null ? selectedService!['pricePerKg'].toString() : '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Add Item"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Item Name")),
            TextField(controller: kgController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Quantity (kg)")),
            TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Price per kg")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (nameController.text.isEmpty || kgController.text.isEmpty || priceController.text.isEmpty) return;

              setState(() {
                final kg = double.tryParse(kgController.text) ?? 0;
                final price = double.tryParse(priceController.text) ?? 0;
                _items.add({
                  'name': nameController.text,
                  'quantityKg': kg,
                  'pricePerKg': price,
                  'total': kg * price,
                });
              });
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"))
        ],
      ),
    );
  }

  /// Pick date
  Future<void> pickDate(bool isPickup) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null) {
      setState(() {
        if (isPickup) {
          pickupDate = date;
        } else {
          dropDate = date;
        }
      });
    }
  }

  /// Place order
  void placeOrder() {
    if (selectedServiceId == null || _items.isEmpty || pickupDate == null || dropDate == null || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please fill all details")));
      return;
    }

    OrderService().placeOrder(
      userId: FirebaseAuth.instance.currentUser!.uid,
      serviceId: selectedServiceId!,
      items: _items,
      totalAmount: totalAmount,
      pickupDate: pickupDate!,
      dropDate: dropDate!,
      address: _addressController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Order placed successfully!")));

    // Reset form
    setState(() {
      _items.clear();
      selectedServiceId = null;
      selectedService = null;
      pickupDate = null;
      dropDate = null;
      _addressController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Place Order")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show preselected service
            if (selectedService != null)
              Text(
                "${selectedService!['name']} - ₹${selectedService!['pricePerKg']} per kg",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),

            // Items
            const Text("Items:", style: TextStyle(fontWeight: FontWeight.bold)),
            ..._items.map((item) => ListTile(
                  title: Text(item['name']),
                  subtitle: Text("${item['quantityKg']} kg x ₹${item['pricePerKg']} = ₹${item['total']}"),
                )),
            ElevatedButton(onPressed: addItem, child: const Text("Add Item")),
            const SizedBox(height: 10),

            // Pickup Address
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: "Pickup Address"),
            ),
            const SizedBox(height: 10),

            // Pickup & Drop Date
            Row(
              children: [
                Text("Pickup: ${pickupDate != null ? DateFormat.yMd().format(pickupDate!) : 'Select'}"),
                const Spacer(),
                TextButton(onPressed: () => pickDate(true), child: const Text("Pick Date")),
              ],
            ),
            Row(
              children: [
                Text("Drop: ${dropDate != null ? DateFormat.yMd().format(dropDate!) : 'Select'}"),
                const Spacer(),
                TextButton(onPressed: () => pickDate(false), child: const Text("Pick Date")),
              ],
            ),
            const SizedBox(height: 20),

            // Total Amount
            Text("Total Amount: ₹$totalAmount", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 20),

            CustomButton(text: "Place Order", onPressed: placeOrder),
          ],
        ),
      ),
    );
  }
}