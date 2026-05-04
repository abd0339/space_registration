import 'package:flutter/material.dart';
import '../services/api_service.dart';

class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> employees = [];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  void _loadEmployees() async {
    final data = await apiService.fetchEmployees();
    setState(() => employees = data);
  }

  void _toggleEmployee(int id) async {
    await apiService.toggleEmployeeStatus(id);
    _loadEmployees(); // Refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Staff Management")),
      body: ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          final emp = employees[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(emp['username'][0].toUpperCase()),
            ),
            title: Text(emp['username']),
            subtitle: Text("Role: ${emp['role']}"),
            trailing: Switch(
              value: emp['active'],
              onChanged: (val) => _toggleEmployee(emp['id']),
              activeColor: Colors.green,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEmployeeDialog(context),
        child: const Icon(Icons.person_add),
      ),
    );
  }

  // Dialog to add new employee username/password
  void _showAddEmployeeDialog(BuildContext context) {
    final TextEditingController userController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    String selectedRole = 'EMPLOYEE';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        // Use StatefulBuilder to update the dropdown inside dialog
        builder: (context, setDialogState) => AlertDialog(
          title: const Text("Register New Staff"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: userController,
                decoration: const InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: passController,
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedRole,
                isExpanded: true,
                items: ['ADMIN', 'EMPLOYEE']
                    .map(
                      (role) =>
                          DropdownMenuItem(value: role, child: Text(role)),
                    )
                    .toList(),
                onChanged: (val) => setDialogState(() => selectedRole = val!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool success = await apiService.createEmployee(
                  userController.text,
                  passController.text,
                  selectedRole,
                );
                if (success) {
                  Navigator.pop(context);
                  _loadEmployees(); // Refresh the list automatically
                }
              },
              child: const Text("Save Employee"),
            ),
          ],
        ),
      ),
    );
  }
}
