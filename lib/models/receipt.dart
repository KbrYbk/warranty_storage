import 'package:hive/hive.dart';

part 'receipt.g.dart'; // нужно для автогенерации адаптера

@HiveType(typeId: 0)
class Receipt extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  DateTime date;

  @HiveField(2)
  DateTime warrantyEnd;

  @HiveField(3)
  String price;

  @HiveField(4)
  String store;

  @HiveField(5)
  String category;

  @HiveField(6)
  String comment;

  @HiveField(7)
  String imagePath;

  Receipt({
    required this.title,
    required this.date,
    required this.warrantyEnd,
    required this.price,
    required this.store,
    required this.category,
    required this.comment,
    required this.imagePath,
  });
}
