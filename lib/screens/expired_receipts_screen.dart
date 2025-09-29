import 'package:flutter/material.dart';

class ExpiredReceiptsScreen extends StatelessWidget {
  final List<Map<String, String>> receipts;

  const ExpiredReceiptsScreen({super.key, required this.receipts});

  // Метод для преобразования строки "dd.MM.yyyy" в DateTime
  DateTime? _parseDate(String? dateStr) {
    if (dateStr == null) return null;
    try {
      final parts = dateStr.split('.');
      if (parts.length != 3) return null;
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Фильтруем истёкшие чеки
    final expiredReceipts = receipts.where((r) {
      final warrantyEnd = _parseDate(r['warrantyEnd']);
      return warrantyEnd != null && warrantyEnd.isBefore(now);
    }).toList();

    if (expiredReceipts.isEmpty) {
      return const Center(
        child: Text(
          "Нет истёкших чеков",
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: expiredReceipts.length,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (context, index) {
        final receipt = expiredReceipts[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
            title: Text(receipt['title'] ?? 'Без названия'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Дата покупки: ${receipt['date'] ?? "-"}"),
                Text("Гарантия до: ${receipt['warrantyEnd'] ?? "-"}"),
              ],
            ),
          ),
        );
      },
    );
  }
}
