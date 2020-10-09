// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expends.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpendsAdapter extends TypeAdapter<Expends> {
  @override
  final int typeId = 1;

  @override
  Expends read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Expends(
      fields[0] as DateTime,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as String,
      fields[5] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Expends obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.price)
      ..writeByte(2)
      ..write(obj.placeId)
      ..writeByte(3)
      ..write(obj.catName)
      ..writeByte(4)
      ..write(obj.placeDesc)
      ..writeByte(5)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpendsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
