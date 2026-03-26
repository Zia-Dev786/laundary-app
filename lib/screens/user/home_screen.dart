import 'package:flutter/material.dart';
import 'package:ecomapp/models/auth_service.dart';
import 'package:ecomapp/models/service_services.dart';
import 'package:ecomapp/screens/widgets/service_card.dart';
import '../../routes.dart';
import '../../constants/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Laundry Services'),
        backgroundColor: AppColors.primary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(context, Routes.history);
            },
            icon: const Icon(Icons.history),
          ),
          IconButton(
            onPressed: () {
              AuthService().logout().then((_) {
                Navigator.pushReplacementNamed(context, Routes.login);
              });
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: StreamBuilder(
          stream: ServiceService().getAllServices(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

            var servicesDocs = snapshot.data!.docs;
            // Filter only active services
            var activeServices = servicesDocs
                .map((doc) => Service.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                .where((service) => service.isActive)
                .toList();

            if (activeServices.isEmpty) {
              return const Center(child: Text("No services available"));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: activeServices.length,
              itemBuilder: (context, index) {
                var service = activeServices[index];
                return ServiceCard(
                  title: service.name,
                  icon: Icons.local_laundry_service, // You can map icon per service
                  onTap: () {
                    // Navigate to order page with serviceId
                    Navigator.pushNamed(context, Routes.order, arguments: service);
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}