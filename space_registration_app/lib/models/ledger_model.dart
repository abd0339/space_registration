class LedgerEntry {
  final double amount;
  final String transactionType; // CREDIT or DEBIT
  final String note;
  final String date;

  LedgerEntry({
    required this.amount,
    required this.transactionType,
    required this.note,
    required this.date,
  });

  factory LedgerEntry.fromJson(Map<String, dynamic> json) {
    return LedgerEntry(
      amount: (json['amount'] as num).toDouble(),
      transactionType: json['transactionType'],
      note: json['note'] ?? '',
      date: json['transactionDate'] ?? '',
    );
  }
}
