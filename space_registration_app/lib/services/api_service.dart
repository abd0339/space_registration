import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer_model.dart';
import '../models/ledger_model.dart';
import '../models/campaign_dashboard_model.dart';

class ApiService {
  // Use 10.0.2.2 if you use Android Emulator. Use localhost for Web.
  final String baseUrl = "http://localhost:8080/api";

  Future<List<Customer>> fetchCustomers() async {
    final response = await http.get(Uri.parse('$baseUrl/customers'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Customer.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load customers');
    }
  }

  Future<CampaignDashboard> fetchCampaignDashboard(int campaignId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/campaigns/$campaignId/dashboard'),
    );

    if (response.statusCode == 200) {
      return CampaignDashboard.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load dashboard');
    }
  }

  Future<List<LedgerEntry>> fetchCustomerHistory(int customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/finance/history/$customerId'),
    );

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => LedgerEntry.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load transaction history');
    }
  }

  Future<bool> addPayment(int customerId, double amount, String note) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/ledger/collect?customerId=$customerId&amount=$amount&note=$note',
      ),
    );
    return response.statusCode == 200;
  }

  Future<bool> createCustomer(
    String firstName,
    String lastName,
    String phone,
    int campaignId,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/customers?campaignId=$campaignId'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "phone": phone,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> fetchCampaignCustomers(
    int campaignId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/campaigns/$campaignId/customers'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load campaign customers');
    }
  }

  Future<List<dynamic>> fetchAllCampaigns() async {
    final response = await http.get(Uri.parse('$baseUrl/campaigns'));
    return jsonDecode(response.body);
  }

  Future<bool> createCampaign(
    String name,
    int maxCustomers,
    String startDate,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/campaigns'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "maxCustomers": maxCustomers,
        "startDate": startDate,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"username": username, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<bool> createService(
    String name,
    double cost,
    bool isInternal,
    String source,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/services'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": name,
        "cost": cost,
        "internal": isInternal,
        "providerName": source,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 201;
  }

  Future<List<Map<String, dynamic>>> fetchAllServices() async {
    final response = await http.get(Uri.parse('$baseUrl/services'));
    return List<Map<String, dynamic>>.from(jsonDecode(response.body));
  }

  Future<bool> enrollInService(int customerId, int serviceId) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/enrollments?customerId=$customerId&serviceId=$serviceId',
      ),
    );
    return response.statusCode == 200;
  }

  Future<bool> collectPayment(
    int customerId,
    double amount,
    String note,
  ) async {
    final response = await http.post(
      // Change this line in collectPayment and addPayment
      Uri.parse(
        '$baseUrl/ledger/collect?customerId=$customerId&amount=$amount&note=$note',
      ),
    );
    return response.statusCode == 200;
  }

  Future<double> getCustomerBalance(int customerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/finance/balance/$customerId'),
    );

    if (response.statusCode == 200) {
      return double.parse(response.body);
    } else {
      throw Exception("Failed to fetch balance");
    }
  }

  Future<List<dynamic>> fetchEmployees() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));
    return jsonDecode(response.body);
  }

  Future<void> toggleEmployeeStatus(int id) async {
    await http.put(Uri.parse('$baseUrl/users/$id/toggle-status'));
  }

  Future<bool> createEmployee(String user, String pass, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "username": user,
        "password": pass,
        "role": role,
        "active": true,
      }),
    );
    return response.statusCode == 200;
  }

  Future<bool> updateAdminInvestment(int campaignId, double amount) async {
    final response = await http.put(
      Uri.parse('$baseUrl/campaigns/$campaignId/invest?amount=$amount'),
    );
    return response.statusCode == 200;
  }

  Future<bool> joinCampaign(int customerId, int campaignId) async {
    final response = await http.post(
      Uri.parse(
        '$baseUrl/campaigns/join?customerId=$customerId&campaignId=$campaignId',
      ),
    );
    return response.statusCode == 200;
  }
}
