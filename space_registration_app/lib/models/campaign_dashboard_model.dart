class CampaignDashboard {
  final String campaignName;
  final double totalInvested;
  final double totalCollected;
  final double totalRemaining;
  final double netProfit;
  final int totalCustomers;

  CampaignDashboard({
    required this.campaignName,
    required this.totalInvested,
    required this.totalCollected,
    required this.totalRemaining,
    required this.netProfit,
    required this.totalCustomers,
  });

  factory CampaignDashboard.fromJson(Map<String, dynamic> json) {
    return CampaignDashboard(
      campaignName: json['campaignName'] ?? 'Unnamed',
      totalInvested: (json['totalInvested'] as num).toDouble(),
      totalCollected: (json['totalCollected'] as num).toDouble(),
      totalRemaining: (json['totalRemaining'] as num).toDouble(),
      netProfit: (json['netProfit'] as num).toDouble(),
      totalCustomers: json['totalCustomers'] ?? 0,
    );
  }
}
