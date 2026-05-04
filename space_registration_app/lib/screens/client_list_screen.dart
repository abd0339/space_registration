import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/client_details_screen.dart';

// Change ClientListScreen to a StatefulWidget
class ClientListScreen extends StatefulWidget {
  final int campaignId;
  const ClientListScreen({super.key, required this.campaignId});

  @override
  State<ClientListScreen> createState() => _ClientListScreenState();
}

class _ClientListScreenState extends State<ClientListScreen> {
  final ApiService apiService = ApiService();
  List<Map<String, dynamic>> allClients = [];
  List<Map<String, dynamic>> filteredClients = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final clients = await apiService.fetchCampaignCustomers(widget.campaignId);
    setState(() {
      allClients = clients;
      filteredClients = clients;
      isLoading = false;
    });
  }

  void _filterSearch(String query) {
    setState(() {
      filteredClients = allClients
          .where(
            (c) => c['firstName'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Campaign Debtors"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterSearch,
              decoration: InputDecoration(
                hintText: "Search by name...",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: filteredClients.length,
              itemBuilder: (context, index) {
                final client = filteredClients[index];
                return ListTile(
                  title: Text("${client['firstName']} ${client['lastName']}"),
                  subtitle: Text(client['phone']),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ClientDetailsScreen(client: client),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
