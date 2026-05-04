import 'package:flutter/material.dart';
import '../models/ledger_model.dart';
import '../models/receipt_model.dart';
import '../models/campaign_dashboard_model.dart';
import '../widgets/receipt_dialog.dart';
import '../screens/enroll_service_screen.dart';
import '../services/api_service.dart';

class ClientDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> client;
  const ClientDetailsScreen({super.key, required this.client});

  @override
  State<ClientDetailsScreen> createState() => _ClientDetailsScreenState();
}

class _ClientDetailsScreenState extends State<ClientDetailsScreen> {
  final ApiService apiService = ApiService();
  late Future<List<LedgerEntry>> historyData;

  @override
  void initState() {
    super.initState();
    historyData = apiService.fetchCustomerHistory(widget.client['id']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("${widget.client['firstName']}'s Profile")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.indigo,
            width: double.infinity,
            child: Column(
              children: [
                const Icon(Icons.account_circle, size: 80, color: Colors.white),
                Text(
                  "${widget.client['firstName']} ${widget.client['lastName']}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  widget.client['phone'],
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      EnrollServiceScreen(client: widget.client),
                ),
              );
            },
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text("Enroll in Services"),
          ),
          ElevatedButton.icon(
            onPressed: () => _showCampaignSelection(context),
            icon: const Icon(Icons.map, color: Colors.orange),
            label: const Text("Join a Trip / Campaign"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange,
            ),
          ),
          ElevatedButton.icon(
            onPressed: () => _showPaymentDialog(context),
            icon: const Icon(Icons.payments, color: Colors.green),
            label: const Text("Collect Payment"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.green,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Payment History",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<LedgerEntry>>(
              future: historyData,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const Center(child: CircularProgressIndicator());
                if (snapshot.data!.isEmpty)
                  return const Center(child: Text("No payments made yet."));

                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];
                    return ListTile(
                      leading: const Icon(
                        Icons.receipt_long,
                        color: Colors.green,
                      ),
                      title: Text(item.note),
                      subtitle: Text(item.date),
                      trailing: Text(
                        "+${item.amount}\$",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 2. Add this method to show the list of campaigns to pick from
  void _showCampaignSelection(BuildContext context) async {
    List<dynamic> campaigns = await apiService.fetchAllCampaigns();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Select a Trip"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: campaigns.length,
            itemBuilder: (context, index) {
              final camp = campaigns[index];
              return ListTile(
                title: Text(camp['name']),
                subtitle: Text("Starts: ${camp['startDate']}"),
                onTap: () async {
                  bool success = await apiService.joinCampaign(
                    widget.client['id'],
                    camp['id'],
                  );
                  if (success) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Successfully joined the trip!"),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    TextEditingController amountController = TextEditingController();
    TextEditingController noteController = TextEditingController(
      text: "Partial Payment",
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Collect Cash Payment"),
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
              decoration: const InputDecoration(labelText: "Note"),
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
              double paidAmount = double.tryParse(amountController.text) ?? 0;
              bool success = await apiService.collectPayment(
                widget.client['id'],
                paidAmount,
                noteController.text,
              );
              if (success) {
                // 1. Fetch updated balance from backend
                double newBalance = await apiService.getCustomerBalance(
                  widget.client['id'],
                );

                // 2. Close payment dialog
                Navigator.pop(context);

                // 3. SHOW THE PROFESSIONAL RECEIPT
                showDialog(
                  context: context,
                  builder: (context) => ReceiptDialog(
                    receipt: Receipt(
                      customerName:
                          "${widget.client['firstName']} ${widget.client['lastName']}",
                      amountPaid: paidAmount,
                      remainingBalance: newBalance,
                      date: DateTime.now(),
                      transactionId: DateTime.now().millisecondsSinceEpoch
                          .toString(),
                    ),
                  ),
                );
                // 4. Refresh history
                setState(() {
                  historyData = apiService.fetchCustomerHistory(
                    widget.client['id'],
                  );
                });
              }
            },
            child: const Text("Confirm Payment"),
          ),
        ],
      ),
    );
  }
}
