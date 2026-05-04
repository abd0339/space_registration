import 'package:flutter/material.dart';
import 'models/customer_model.dart';
import 'screens/ceo_dashboard_screen.dart';
import 'screens/login_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Customer>> futureCustomers;

  @override
  void initState() {
    super.initState();
    // This calls your Spring Boot API when the app starts
    futureCustomers = apiService.fetchCustomers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Space Registration - Clients")),
      body: FutureBuilder<List<Customer>>(
        future: futureCustomers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No customers found in Database."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final customer = snapshot.data![index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text("${customer.firstName} ${customer.lastName}"),
                subtitle: Text("Phone: ${customer.phone}"),
              );
            },
          );
        },
      ),
    );
  }
}
