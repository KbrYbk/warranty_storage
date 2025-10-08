// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptAdapter extends TypeAdapter<Receipt> {
  @override
  final int typeId = 0;

  @override
  Receipt read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Receipt(
      title: fields[0] as String,
      date: fields[1] as DateTime,
      warrantyEnd: fields[2] as DateTime,
      price: fields[3] as String,
      store: fields[4] as String,
      category: fields[5] as String,
      comment: fields[6] as String,
      imagePath: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Receipt obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.warrantyEnd)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.store)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.comment)
      ..writeByte(7)
      ..write(obj.imagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
