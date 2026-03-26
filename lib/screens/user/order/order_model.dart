class LaundryItem {
  String name;
  double quantityKg;
  double pricePerKg;

  LaundryItem({required this.name, required this.quantityKg, required this.pricePerKg});

  double get total => quantityKg * pricePerKg;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'quantityKg': quantityKg,
      'pricePerKg': pricePerKg,
      'total': total,
    };
  }
}

class Order {
  String id;
  String userId;
  List<LaundryItem> items;
  double totalAmount;
  String serviceType;
  DateTime pickupDate;
  DateTime dropDate;
  String address;
  String status;

  Order({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.serviceType,
    required this.pickupDate,
    required this.dropDate,
    required this.address,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'serviceType': serviceType,
      'items': items.map((e) => e.toMap()).toList(),
      'totalAmount': totalAmount,
      'pickupDate': pickupDate,
      'dropDate': dropDate,
      'address': address,
      'status': status,
      'createdAt': DateTime.now(),
    };
  }
}