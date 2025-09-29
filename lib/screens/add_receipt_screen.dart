import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _priceController = TextEditingController();
  final _storeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _commentController = TextEditingController();

  XFile? _receiptImage;
  final ImagePicker _picker = ImagePicker();

  DateTime? _purchaseDate;
  DateTime? _warrantyDate;

  Future<void> _pickImage() async {
    final XFile? image =
    await _picker.pickImage(source: ImageSource.camera, imageQuality: 80);
    if (image != null) setState(() => _receiptImage = image);
  }

  Future<void> _pickDate(TextEditingController controller, DateTime? initialDate,
      void Function(DateTime) onPicked) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked);
      onPicked(picked);
    }
  }

  void _saveReceipt() {
    if (_formKey.currentState!.validate()) {
      final newReceipt = {
        "title": _titleController.text,
        "date": _dateController.text,
        "warrantyEnd": _warrantyController.text,
        "price": _priceController.text,
        "store": _storeController.text,
        "category": _categoryController.text,
        "comment": _commentController.text,
        "image": _receiptImage?.path ?? "",
      };

      Navigator.pop(context, newReceipt);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Чек успешно сохранён!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить чек"), centerTitle: true),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickImage,
        child: const Icon(Icons.camera_alt_outlined),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Основные поля
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: "Название устройства",
                  filled: true,
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Введите название" : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Дата покупки",
                        filled: true,
                      ),
                      onTap: () => _pickDate(
                        _dateController,
                        _purchaseDate,
                            (picked) => _purchaseDate = picked,
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Выберите дату" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _warrantyController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Гарантия до",
                        filled: true,
                      ),
                      onTap: () => _pickDate(
                        _warrantyController,
                        _warrantyDate ?? _purchaseDate,
                            (picked) => _warrantyDate = picked,
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Выберите дату окончания"
                          : (_purchaseDate != null &&
                          _warrantyDate != null &&
                          _warrantyDate!.isBefore(_purchaseDate!)
                          ? "Гарантия раньше покупки"
                          : null),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Дополнительные поля
              ExpansionTile(
                title: const Text("Дополнительно"),
                children: [
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Сумма",
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _storeController,
                    decoration: const InputDecoration(
                      labelText: "Магазин",
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: "Категория",
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: "Комментарий",
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_receiptImage != null)
                    Image.file(File(_receiptImage!.path), height: 150),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.save),
                label: const Text("Сохранить чек"),
                onPressed: _saveReceipt,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
