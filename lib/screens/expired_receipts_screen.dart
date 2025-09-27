import 'package:flutter/material.dart';

class ExpiredReceiptsScreen extends StatelessWidget {
  const ExpiredReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Истёкшие чеки")),
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
