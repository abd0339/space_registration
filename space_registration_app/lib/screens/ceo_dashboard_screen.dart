import 'package:flutter/material.dart';
import '../models/campaign_dashboard_model.dart';
import '../models/ledger_model.dart';
import '../screens/add_customer_screen.dart';
import '../screens/client_list_screen.dart';
import '../screens/add_service_screen.dart';
import '../screens/employee_management_screen.dart';
import '../screens/campaign_list_screen.dart';
import '../services/api_service.dart';

class CeoDashboardScreen extends StatefulWidget {
  final int campaignId;
  const CeoDashboardScreen({super.key, required this.campaignId});

  @override
  State<CeoDashboardScreen> createState() => _CeoDashboardScreenState();
}

class _CeoDashboardScreenState extends State<CeoDashboardScreen> {
  final ApiService apiService = ApiService();
  late Future<CampaignDashboard> dashboardData;
  late Future<List<LedgerEntry>> historyData;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      dashboardData = apiService.fetchCampaignDashboard(widget.campaignId);
      historyData = apiService.fetchCustomerHistory(
        1,
      ); // Testing with Customer 1
    });
  }

  void _showPaymentDialog() {
    final TextEditingController amountController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Collect Payment"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              decoration: const InputDecoration(labelText: "Amount (\$)"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                labelText: "Note (e.g., Cash, Bank Transfer)",
              ),
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
              double? amt = double.tryParse(amountController.text);
              if (amt != null) {
                // We are using Customer ID 1 for now to match our test
                bool success = await apiService.addPayment(
                  1,
                  amt,
                  noteController.text,
                );
                if (success) {
                  Navigator.pop(context);
                  _loadData(); // This refreshes the whole dashboard!
                }
              }
            },
            child: const Text("Confirm Payment"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showPaymentDialog();
          print("Add Payment Clicked");
        },
        label: const Text("Add Payment"),
        icon: const Icon(Icons.attach_money),
        backgroundColor: Colors.indigo,
      ),

      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text("CEO Financial Overview"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddCustomerScreen(campaignId: widget.campaignId),
                ),
              ).then((_) => _loadData()); // Refresh dashboard when coming back!
            },
          ),
          IconButton(
            icon: const Icon(Icons.add_business),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddServiceScreen(),
                ),
              );
            },
          ),
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: FutureBuilder<CampaignDashboard>(
        future: dashboardData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Campaign: ${data.campaignName}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard(
                      "Invested",
                      "${data.totalInvested}\$",
                      Colors.orange,
                    ),
                    _buildStatCard(
                      "Collected",
                      "${data.totalCollected}\$",
                      Colors.green,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _buildStatCard(
                      "Debt Owed",
                      "${data.totalRemaining}\$",
                      Colors.red,
                    ),
                    _buildStatCard(
                      "Net Profit",
                      "${data.netProfit}\$",
                      data.netProfit >= 0 ? Colors.blue : Colors.deepPurple,
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ClientListScreen(campaignId: widget.campaignId),
                      ),
                    );
                  },
                  icon: const Icon(Icons.people),
                  label: const Text("View Campaign Clients"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CampaignListScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.map),
                  label: const Text("Campaign Control"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmployeeManagementScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.group_work),
                  label: const Text("Staff Control"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                // Add this below the StatCards rows:
                const SizedBox(height: 30),
                const Text(
                  "Recent Transactions",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<LedgerEntry>>(
                  future: historyData,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return const CircularProgressIndicator();

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final item = snapshot.data![index];
                        final isCredit = item.transactionType == "CREDIT";

                        return Card(
                          child: ListTile(
                            leading: Icon(
                              isCredit
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: isCredit ? Colors.green : Colors.red,
                            ),
                            title: Text(item.note),
                            trailing: Text(
                              "${isCredit ? '+' : '-'}${item.amount}\$",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCredit ? Colors.green : Colors.red,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border(left: BorderSide(color: color, width: 8)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                value,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
