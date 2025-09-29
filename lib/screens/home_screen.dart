import 'package:flutter/material.dart';
import 'package:warranty_storage/screens/add_receipt_screen.dart';
import 'package:warranty_storage/screens/receipt_details_screen.dart';
import 'package:warranty_storage/screens/expired_receipts_screen.dart';
import 'package:warranty_storage/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(ThemeMode) onThemeChanged;

  const HomeScreen({super.key, required this.onThemeChanged});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// Виджет для вывода даты покупки и окончания гарантии
class ReceiptSubtitle extends StatelessWidget {
  final Map<String, String> receipt;

  const ReceiptSubtitle({super.key, required this.receipt});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Дата покупки: ${receipt["date"] ?? "-"}"),
        Text("Гарантия до: ${receipt["warrantyEnd"] ?? "-"}"),
      ],
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _notificationsEnabled = true;

  final List<Map<String, String>> _receipts = [
    {
      "title": "Ноутбук Acer",
      "date": "12.03.2024",
      "warrantyEnd": "12.03.2025",
      "comment": "",
    },
    {
      "title": "Телефон Samsung",
      "date": "01.05.2024",
      "warrantyEnd": "01.09.2025",
      "comment": "",
    },
    {
      "title": "Наушники Sony",
      "date": "01.12.2024",
      "warrantyEnd": "01.12.2025",
      "comment": "",
    },
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  bool _isValidReceipt(Map<String, String>? receipt) {
    return receipt != null &&
        receipt["title"]?.isNotEmpty == true &&
        receipt["date"]?.isNotEmpty == true;
  }

  Future<void> _addReceipt() async {
    final newReceipt = await Navigator.push<Map<String, String>?>(
      context,
      MaterialPageRoute(builder: (_) => const AddReceiptScreen()),
    );

    if (_isValidReceipt(newReceipt)) {
      setState(() => _receipts.add(newReceipt!));
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

  Widget? _buildFloatingButton() {
    if (_selectedIndex != 0) return null;
    return FloatingActionButton(
      onPressed: _addReceipt,
      child: const Icon(Icons.add),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = {
      0: ListView.builder(
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
              leading: const CircleAvatar(child: Icon(Icons.receipt_long)),
              title: Text(receipt["title"] ?? "Без названия"),
              subtitle: ReceiptSubtitle(receipt: receipt),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openReceiptDetails(receipt),
            ),
          );
        },
      ),
      1: ExpiredReceiptsScreen(receipts: _receipts),
      2: const Center(child: Text("Профиль", style: TextStyle(fontSize: 18))),
      3: SettingsScreen(
        onThemeChanged: widget.onThemeChanged,
        notificationsEnabled: _notificationsEnabled,
        onNotificationsChanged: (val) =>
            setState(() => _notificationsEnabled = val),
      ),
    };

    /* if (_selectedIndex == 0) {
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
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Дата покупки: ${receipt["date"] ?? "-"}"),
                  Text("Гарантия до: ${receipt["warrantyEnd"] ?? "-"}"),
                ],
              ),
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
      } else if (_selectedIndex == 1) {
        body = ExpiredReceiptsScreen(receipts: _receipts);
      } else {
      String text;
      text = "Профиль";
      body = Center(child: Text(text, style: const TextStyle(fontSize: 18)));
    }*/

    return Scaffold(
      appBar: AppBar(title: const Text("Гарантийные чеки"), centerTitle: true),
      body: pages[_selectedIndex]!,
      floatingActionButton: _buildFloatingButton(),
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
