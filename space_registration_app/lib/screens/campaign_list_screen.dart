import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../screens/campaign_dashboard_screen.dart';
import 'add_campaign_screen.dart';

class CampaignListScreen extends StatefulWidget {
  const CampaignListScreen({super.key});

  @override
  State<CampaignListScreen> createState() => _CampaignListScreenState();
}

class _CampaignListScreenState extends State<CampaignListScreen> {
  final ApiService apiService = ApiService();
  List<dynamic> campaigns = [];

  @override
  void initState() {
    super.initState();
    _loadCampaigns();
  }

  void _loadCampaigns() async {
    final data = await apiService.fetchAllCampaigns();
    setState(() => campaigns = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Active Campaigns")),
      body: ListView.builder(
        itemCount: campaigns.length,
        itemBuilder: (context, index) {
          final camp = campaigns[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: ListTile(
              title: Text(
                camp['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Starts: ${camp['startDate']} | Limit: ${camp['maxCustomers']}",
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CampaignDashboardScreen(campaign: camp),
                  ),
                ).then((_) => _loadCampaigns());
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCampaignScreen()),
          ).then((_) => _loadCampaigns());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
