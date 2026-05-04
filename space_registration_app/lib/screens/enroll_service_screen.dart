import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EnrollServiceScreen extends StatefulWidget {
  final Map<String, dynamic> client;
  const EnrollServiceScreen({super.key, required this.client});

  @override
  State<EnrollServiceScreen> createState() => _EnrollServiceScreenState();
}

class _EnrollServiceScreenState extends State<EnrollServiceScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> services = [];
  Set<int> selectedServiceIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  void _loadServices() async {
    final data = await apiService.fetchAllServices();
    setState(() {
      services = data;
      isLoading = false;
    });
  }

  void _submitEnrollment() async {
    if (selectedServiceIds.isEmpty) return;

    setState(() => isLoading = true);
    bool allSuccess = true;

    for (int id in selectedServiceIds) {
      bool success = await apiService.enrollInService(widget.client['id'], id);
      if (!success) allSuccess = false;
    }

    if (allSuccess) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All Services Enrolled Successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double total = services
        .where((s) => selectedServiceIds.contains(s['id']))
        .fold(0, (sum, s) => sum + (s['cost'] as num).toDouble());

    return Scaffold(
      appBar: AppBar(title: Text("Enroll ${widget.client['firstName']}")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final s = services[index];
                      return CheckboxListTile(
                        title: Text(s['name']),
                        subtitle: Text(
                          "${s['cost']}\$ - ${s['internal'] ? 'Our Office' : s['providerName']}",
                        ),
                        value: selectedServiceIds.contains(s['id']),
                        onChanged: (val) {
                          setState(() {
                            val!
                                ? selectedServiceIds.add(s['id'])
                                : selectedServiceIds.remove(s['id']);
                          });
                        },
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total: ${total.toStringAsFixed(2)}\$",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _submitEnrollment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Confirm Enrollment"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
