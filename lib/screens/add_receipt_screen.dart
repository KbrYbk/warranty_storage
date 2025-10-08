import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:warranty_storage/models/receipt.dart';
import 'package:warranty_storage/screens/qr_scanner_screen.dart';

class AddReceiptScreen extends StatefulWidget {
  const AddReceiptScreen({super.key});

  @override
  State<AddReceiptScreen> createState() => _AddReceiptScreenState();
}

class _AddReceiptScreenState extends State<AddReceiptScreen> {
  //  Ключ формы для валидации
  final _formKey = GlobalKey<FormState>();

  //  Контроллеры текстовых полей
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _warrantyController = TextEditingController();
  final _priceController = TextEditingController();
  final _storeController = TextEditingController();
  final _categoryController = TextEditingController();
  final _commentController = TextEditingController();

  //  Работа с изображениями
  XFile? _receiptImage;
  final ImagePicker _picker = ImagePicker();

  //  Даты покупки и гарантии
  DateTime? _purchaseDate;
  DateTime? _warrantyDate;

  //  Состояние FAB меню (открыто/закрыто)
  bool _fabMenuOpen = false;

  // Выбор изображения из камеры или галереи
  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() => _receiptImage = image);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Изображение выбрано')));
    }
  }

  //  Сканирование QR-кода (автоматическое заполнение даты и суммы)
  Future<void> _scanQR() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QRScannerScreen()),
    );

    if (result != null && result is String) {
      try {
        final qrData = Uri.splitQueryString(result, encoding: utf8);

        final rawDate = qrData["t"];
        final rawSum = qrData["s"];

        if (rawDate != null) {
          final parsedDate = DateTime.parse(rawDate.replaceFirst("T", ""));
          _dateController.text = DateFormat('dd.MM.yyyy').format(parsedDate);
          _purchaseDate = parsedDate;
        }

        if (rawSum != null) _priceController.text = rawSum;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("QR-код успешно отсканирован")),
        );
      } catch (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Не удалось распознать QR-код")),
        );
      }
    }
  }

  //  Выбор даты с помощью календаря
  Future<void> _pickDate(TextEditingController controller, DateTime? initialDate, void Function(DateTime) onPicked) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      controller.text = DateFormat('dd.MM.yyyy').format(picked); // для UI
      onPicked(picked); // сохраняем как DateTime
    }
  }

  //  Сохранение чека (возвращаем объект Receipt в HomeScreen)
  void _saveReceipt() {
    if (_formKey.currentState!.validate()) {
      final newReceipt = Receipt(
        title: _titleController.text,
        date: _purchaseDate!,
        warrantyEnd: _warrantyDate!,
        price: _priceController.text,
        store: _storeController.text,
        category: _categoryController.text,
        comment: _commentController.text,
        imagePath: _receiptImage?.path ?? "",
      );

      Navigator.pop(context, newReceipt);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Чек успешно сохранён!')));
    }
  }

  //  Основной UI экрана
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Добавить чек"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Название устройства
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

              // Даты покупки и окончания гарантии
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
      //  Простое FAB-меню для выбора действия (QR, Камера, Галерея)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          //  Кнопка: Фото с камеры
          AnimatedScale(
            scale: _fabMenuOpen ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _pickImage(ImageSource.camera);
                  setState(() => _fabMenuOpen = false);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text("Фото"),
              ),
            ),
          ),
          //  Кнопка: Выбор из галереи
          AnimatedScale(
            scale: _fabMenuOpen ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _pickImage(ImageSource.gallery);
                  setState(() => _fabMenuOpen = false);
                },
                icon: const Icon(Icons.photo_library),
                label: const Text("Галерея"),
              ),
            ),
          ),
          //  Кнопка: Сканирование QR
          AnimatedScale(
            scale: _fabMenuOpen ? 1 : 0,
            duration: const Duration(milliseconds: 200),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: FloatingActionButton.extended(
                onPressed: () {
                  _scanQR();
                  setState(() => _fabMenuOpen = false);
                },
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text("QR"),
              ),
            ),
          ),
          //  Главная кнопка (открывает/закрывает меню)
          FloatingActionButton(
            onPressed: () => setState(() => _fabMenuOpen = !_fabMenuOpen),
            child: Icon(_fabMenuOpen ? Icons.close : Icons.add),
          ),
        ],
      ),
    );
  }
}
