import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/receipt_model.dart';

class ReceiptDialog extends StatelessWidget {
  final Receipt receipt;

  const ReceiptDialog({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 60),
            const SizedBox(height: 10),
            const Text(
              "Payment Successful",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.green,
              ),
            ),
            const Divider(thickness: 2),
            const SizedBox(height: 10),
            const Text(
              "SPACE TRAVEL OFFICE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                letterSpacing: 1.5,
              ),
            ),
            const Text(
              "Registration & Financial System",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            _receiptRow(
              "Date:",
              DateFormat('yyyy-MM-dd HH:mm').format(receipt.date),
            ),
            _receiptRow("Customer:", receipt.customerName),
            _receiptRow(
              "Transaction ID:",
              "#${receipt.transactionId.substring(0, 8)}",
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "------------------------------------------",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            _receiptRow(
              "PAID AMOUNT:",
              "\$${receipt.amountPaid.toStringAsFixed(2)}",
              isBold: true,
            ),
            _receiptRow(
              "REMAINING:",
              "\$${receipt.remainingBalance.toStringAsFixed(2)}",
              color: Colors.red,
            ),
            const SizedBox(height: 30),
            const Text(
              "Authorized Signature",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            Container(
              width: 150,
              height: 1,
              color: Colors.black26,
              margin: const EdgeInsets.only(top: 5),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size.fromHeight(45),
              ),
              child: const Text(
                "CLOSE & PRINT",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _receiptRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? Colors.black87,
              fontSize: isBold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
