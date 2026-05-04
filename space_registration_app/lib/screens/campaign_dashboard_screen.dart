import 'package:flutter/material.dart';
import '../models/campaign_dashboard_model.dart';
import 'add_customer_screen.dart';
import '../services/api_service.dart';

class CampaignDashboardScreen extends StatefulWidget {
  final dynamic campaign;
  const CampaignDashboardScreen({super.key, required this.campaign});

  @override
  State<CampaignDashboardScreen> createState() =>
      _CampaignDashboardScreenState();
}

class _CampaignDashboardScreenState extends State<CampaignDashboardScreen> {
  final ApiService apiService = ApiService();
  CampaignDashboard? dashboardData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  void _loadDashboard() async {
    final data = await apiService.fetchCampaignDashboard(widget.campaign['id']);

    setState(() {
      dashboardData = data;
      isLoading = false;
    });
  }

  void _showInvestDialog() {
    TextEditingController investController = TextEditingController(
      text: dashboardData?.totalInvested.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Trip Investment"),
        content: TextField(
          controller: investController,
          decoration: const InputDecoration(
            labelText: "Investment (Bus, Hotels, etc.)",
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              bool success = await apiService.updateAdminInvestment(
                widget.campaign['id'],
                double.parse(investController.text),
              );
              if (success) {
                Navigator.pop(context);
                _loadDashboard(); // Refresh
              }
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: Text("${dashboardData!.campaignName} Finance")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _financeCard(
              "Total Customers",
              "${dashboardData!.totalCustomers} / ${widget.campaign['maxCustomers']}",
              Colors.purple,
            ),
            _financeCard(
              "Total Collected",
              "\$${dashboardData!.totalCollected}",
              Colors.green,
            ),
            _financeCard(
              "Total Remaining Debt",
              "\$${dashboardData!.totalRemaining}",
              Colors.orange,
            ),
            _financeCard(
              "Admin Investment",
              "\$${dashboardData!.totalInvested}",
              Colors.blue,
            ),
            const Divider(height: 40, thickness: 2),
            _financeCard(
              "NET PROFIT",
              "\$${dashboardData!.netProfit}",
              (dashboardData!.netProfit) >= 0 ? Colors.indigo : Colors.red,
              isMain: true,
            ),
            const Spacer(),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddCustomerScreen(campaignId: widget.campaign['id']),
                  ),
                ).then(
                  (_) => _loadDashboard(),
                ); // Refresh stats when you come back!
              },
              icon: const Icon(Icons.person_add),
              label: const Text("Add Customer to this Trip"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _showInvestDialog,
              icon: const Icon(Icons.edit),
              label: const Text("Manage Trip Investment"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _financeCard(
    String title,
    String value,
    Color color, {
    bool isMain = false,
  }) {
    return Card(
      color: isMain ? color : Colors.white,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(color: isMain ? Colors.white : Colors.black54),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: isMain ? Colors.white : color,
            fontWeight: FontWeight.bold,
            fontSize: isMain ? 22 : 18,
          ),
        ),
      ),
    );
  }
}
