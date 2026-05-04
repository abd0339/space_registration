import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AddServiceScreen extends StatefulWidget {
  const AddServiceScreen({super.key});

  @override
  State<AddServiceScreen> createState() => _AddServiceScreenState();
}

class _AddServiceScreenState extends State<AddServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  double cost = 0.0;
  bool isInternal = true;
  String officeSource = 'Space Travel';

  void _saveService() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // We will add the createService call to ApiService next
      bool success = await ApiService().createService(name, cost, isInternal, officeSource);
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Service Created!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Service")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Service Name (e.g., Visa Processing)"),
                validator: (v) => v!.isEmpty ? "Enter name" : null,
                onSaved: (v) => name = v!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Cost (\$)"),
                keyboardType: TextInputType.number,
                onSaved: (v) => cost = double.parse(v!),
              ),
              SwitchListTile(
                title: const Text("Internal Service (Our Office)"),
                value: isInternal,
                onChanged: (v) => setState(() => isInternal = v),
              ),
              if (!isInternal)
                TextFormField(
                  decoration: const InputDecoration(labelText: "External Office Name"),
                  onSaved: (v) => officeSource = v!,
                ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _saveService, child: const Text("Confirm Service")),
            ],
          ),
        ),
      ),
    );
  }
}