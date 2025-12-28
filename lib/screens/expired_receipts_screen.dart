import 'dart:io';
import 'package:flutter/material.dart';
import 'package:safecheck/models/receipt.dart';
import 'package:safecheck/screens/receipt_details_screen.dart';
import 'package:intl/intl.dart';


class ExpiredReceiptsScreen extends StatelessWidget {
  final List<Receipt> receipts;

  const ExpiredReceiptsScreen({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Фильтруем истёкшие чеки
    final expiredReceipts = receipts
        .where((r) => r.warrantyEnd.isBefore(DateTime.now()))
        .toList();

    if (expiredReceipts.isEmpty) {
      return const Center(
        child: Text("Нет истёкших чеков", style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      itemCount: expiredReceipts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final receipt = expiredReceipts[index];

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: Text(receipt.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Дата покупки: ${receipt.date}"),
                Tooltip(
                  message: "Гарантия закончилась",
                  child: Text(
                    "Гарантия до: ${DateFormat('dd.MM.yyyy').format(receipt.warrantyEnd)}",
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReceiptDetailsScreen(receipt: receipt),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
