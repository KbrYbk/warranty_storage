import 'dart:io';
import 'package:flutter/material.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  final Map<String, String> receipt;

  const ReceiptDetailsScreen({super.key, required this.receipt});

  void _deleteReceipt(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Удалить чек?"),
        content: const Text("Вы уверены, что хотите удалить этот чек?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Отмена")),
          FilledButton.tonalIcon(
            icon: const Icon(Icons.delete),
            label: const Text("Удалить"),
            onPressed: () {
              Navigator.pop(ctx); // закрыть диалог
              Navigator.pop(context, {"delete": true});
            },
          ),
        ],
      ),
    );
  }

  Widget _buildField(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value ?? "-"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Детали чека"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _deleteReceipt(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (receipt["image"] != null && receipt["image"]!.isNotEmpty)
              Center(
                child: Image.file(
                  File(receipt["image"]!),
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
            const SizedBox(height: 16),
            _buildField("Название", receipt["title"]),
            _buildField("Дата покупки", receipt["date"]),
            _buildField("Гарантия до", receipt["warrantyEnd"]),
            _buildField("Сумма", receipt["price"]),
            _buildField("Магазин", receipt["store"]),
            _buildField("Категория", receipt["category"]),
            _buildField("Комментарий", receipt["comment"]),
            const SizedBox(height: 24),
            Center(
              child: FilledButton.tonalIcon(
                icon: const Icon(Icons.delete),
                label: const Text("Удалить чек"),
                onPressed: () => _deleteReceipt(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
