import 'package:flutter/material.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

//Когда экран уничтожается (пользователь ушёл с него), нужно очистить контроллеры, чтобы не было утечек памяти.
  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
//Если пользователь выбрал дату (picked != null), она преобразуется в строку dd.mm.yyyy и записывается в поле _dateController.
    if (picked != null) {
      _dateController.text = "${picked.day.toString().padLeft(2, '0')}"
          ".${picked.month.toString().padLeft(2, '0')}"
          ".${picked.year}";
    }
  }

  void _saveReceipt() {
    if (_formKey.currentState!.validate()) {
      final receipt = {
        "title": _titleController.text,
        "date": _dateController.text,
        "comment": _commentController.text,
      };
      Navigator.pop(context, receipt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.outline,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Добавить чек"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Название покупки
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Название покупки",
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Введите название" : null,
              ),
              const SizedBox(height: 16),

              // Дата покупки
              TextFormField(
                controller: _dateController,
                readOnly: true, // запрещаем ручной ввод
                decoration: InputDecoration(
                  labelText: "Дата покупки",
                  filled: true,
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                ),
                validator: (value) =>
                value == null || value.isEmpty ? "Выберите дату" : null,
              ),
              const SizedBox(height: 16),

              // Комментарий
              TextFormField(
                controller: _commentController,
                decoration: const InputDecoration(
                  labelText: "Комментарий (необязательно)",
                  filled: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),

              // Кнопка Сохранить
              FilledButton.tonal(
                onPressed: _saveReceipt,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save),
                    SizedBox(width: 8),
                    Text("Сохранить"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
