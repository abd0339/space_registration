import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:intl/intl.dart';

class AddCampaignScreen extends StatefulWidget {
  const AddCampaignScreen({super.key});

  @override
  State<AddCampaignScreen> createState() => _AddCampaignScreenState();
}

class _AddCampaignScreenState extends State<AddCampaignScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int maxCustomers = 0;
  DateTime selectedDate = DateTime.now();
  final ApiService apiService = ApiService();

  void _saveCampaign() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

      bool success = await apiService.createCampaign(
        name,
        maxCustomers,
        formattedDate,
      );
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Campaign Created!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Travel Campaign")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "Campaign Name (e.g., Summer Trip 2026)",
                ),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Max Customers"),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter limit" : null,
                onSaved: (v) => maxCustomers = int.parse(v!),
              ),
              ListTile(
                title: Text(
                  "Start Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _saveCampaign,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Create Campaign"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
