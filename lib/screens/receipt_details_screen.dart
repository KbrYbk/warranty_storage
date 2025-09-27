import 'package:flutter/material.dart';

class ReceiptDetailsScreen extends StatelessWidget {
  const ReceiptDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить чек")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text("Войти (заглушка)"),
        ),
      ),
    );
  }
}
