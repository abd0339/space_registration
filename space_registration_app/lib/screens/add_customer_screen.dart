import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddCustomerScreen extends StatefulWidget {
  final int campaignId;
  const AddCustomerScreen({super.key, required this.campaignId});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();

  String firstName = '';
  String lastName = '';
  String phone = '';

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      bool success = await apiService.createCustomer(
        firstName,
        lastName,
        phone,
        widget.campaignId,
      );

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Customer Added Successfully!")),
        );
        Navigator.pop(context); // Go back to dashboard
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register New Client")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "First Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
                onSaved: (value) => firstName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Last Name"),
                validator: (value) => value!.isEmpty ? "Required" : null,
                onSaved: (value) => lastName = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Required" : null,
                onSaved: (value) => phone = value!,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: _submit,
                child: const Text("Save Customer"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
