class Receipt {
  final String customerName;
  final double amountPaid;
  final double remainingBalance;
  final DateTime date;
  final String transactionId;

  Receipt({
    required this.customerName,
    required this.amountPaid,
    required this.remainingBalance,
    required this.date,
    required this.transactionId,
  });
}
