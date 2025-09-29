import 'package:flutter/material.dart';
import 'package:warranty_storage/screens/add_receipt_screen.dart';
import 'package:warranty_storage/screens/receipt_details_screen.dart';
import 'package:warranty_storage/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _notificationsEnabled = true;
  final List<Map<String, String>> _receipts = [
    {"title": "Ноутбук Acer", "date": "12.03.2024", "comment": ""},
    {"title": "Телефон Samsung", "date": "01.05.2024", "comment": ""},
    {"title": "Наушники Sony", "date": "20.08.2024", "comment": ""},
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  Future<void> _addReceipt() async {
    final Map<String, String>? newReceipt = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddReceiptScreen()),
    );

    if (newReceipt != null &&
        newReceipt["title"] != null &&
        newReceipt["date"] != null) {
      setState(() => _receipts.add(newReceipt));
    }
  }

  Future<void> _openReceiptDetails(Map<String, String> receipt) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ReceiptDetailsScreen(receipt: receipt)),
    );

    if (result != null && result["delete"] == true) {
      setState(() => _receipts.remove(receipt));
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_selectedIndex == 0) {
      body = ListView.builder(
        itemCount: _receipts.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          final receipt = _receipts[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            child: ListTile(
              leading: CircleAvatar(child: const Icon(Icons.receipt_long)),
              title: Text(receipt["title"] ?? "Без названия"),
              subtitle: Text("Дата: ${receipt["date"] ?? "-"}"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openReceiptDetails(receipt),
            ),
          );
        },
      );
    } else if (_selectedIndex == 3) {
      // Настройки
      body = SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: (val) =>
            setState(() => _notificationsEnabled = val),
      );
    } else {
      String text;
      if (_selectedIndex == 1) {
        text = "Истёкшие чеки";
      } else {
        text = "Профиль";
      }
      body = Center(child: Text(text, style: const TextStyle(fontSize: 18)));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Гарантийные чеки"), centerTitle: true),
      body: body,
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addReceipt,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.receipt_outlined),
            selectedIcon: Icon(Icons.receipt),
            label: "Чеки",
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: "Истёкшие",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: "Профиль",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: "Настройки",
          ),
        ],
      ),
    );
  }
}
