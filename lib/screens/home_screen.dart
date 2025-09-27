import 'package:flutter/material.dart';
import 'package:warranty_storage/screens/add_receipt_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Пример чеков
  final List<Map<String, String>> _receipts = [
    {"title": "Ноутбук Acer", "date": "12.03.2024"},
    {"title": "Телефон Samsung", "date": "01.05.2024"},
    {"title": "Наушники Sony", "date": "20.08.2024"},
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Гарантийные чеки"),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
        onPressed: () async {
          final newReceipt = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddReceiptScreen()),
          );

          if (newReceipt != null) {
            setState(() => _receipts.add(newReceipt));
          }
        },
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

  Widget _buildBody() {
    if (_selectedIndex == 0) {
      return ListView.builder(
        itemCount: _receipts.length,
        itemBuilder: (context, index) {
          final receipt = _receipts[index];
          return ListTile(
            leading: const Icon(Icons.receipt_long),
            title: Text(receipt["title"]!),
            subtitle: Text("Дата: ${receipt["date"]}"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, "/details"),
          );
        },
      );
    } else if (_selectedIndex == 1) {
      return const Center(child: Text("Истёкшие чеки"));
    } else if (_selectedIndex == 2) {
      return const Center(child: Text("Профиль"));
    } else {
      return const Center(child: Text("Настройки"));
    }
  }
}
