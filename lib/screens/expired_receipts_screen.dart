import 'package:flutter/material.dart';

class ExpiredReceiptsScreen extends StatelessWidget {
  final List<Map<String, String>> receipts;

  const ExpiredReceiptsScreen({super.key, required this.receipts});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Фильтруем истёкшие чеки
    final expired = receipts.where((receipt) {
      final parts = receipt["date"]?.split('.') ?? [];
      if (parts.length != 3) return false;
      final day = int.tryParse(parts[0]);
      final month = int.tryParse(parts[1]);
      final year = int.tryParse(parts[2]);
      if (day == null || month == null || year == null) return false;
      final receiptDate = DateTime(year, month, day);
      return receiptDate.isBefore(now);
    }).toList();

    if (expired.isEmpty) {
      return const Center(
        child: Text("Нет истёкших чеков", style: TextStyle(fontSize: 18)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: expired.length,
      itemBuilder: (context, index) {
        final receipt = expired[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: ListTile(
            leading: CircleAvatar(
              child: const Icon(Icons.receipt_long),
            ),
            title: Text(receipt["title"] ?? "Без названия"),
            subtitle: Text("Дата: ${receipt["date"] ?? "-"}"),
          ),
        );
      },
    );
  }
}
