import 'package:flutter/material.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final Map<String, String> receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали чека"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Верх: иконка, название и тег
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.receipt_long, size: 40, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    receipt["title"] ?? "",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text("Покупка"),
                  backgroundColor: colorScheme.primaryContainer,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Дата
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined),
                const SizedBox(width: 8),
                Text(
                  "Дата: ${receipt["date"] ?? ""}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Комментарий
            if ((receipt["comment"] ?? "").isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Комментарий",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    receipt["comment"]!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

            const Spacer(),

            // Кнопка удаления
            SizedBox(
              width: double.infinity,
              child: FilledButton.tonal(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Удалить чек?"),
                      content: const Text(
                          "Вы уверены, что хотите удалить этот чек?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text("Отмена"),
                        ),
                        FilledButton.tonal(
                          onPressed: () {
                            Navigator.pop(ctx); // закрыть диалог
                            Navigator.pop(context, {"delete": true});
                          },
                          child: const Text("Удалить"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("Удалить чек"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
