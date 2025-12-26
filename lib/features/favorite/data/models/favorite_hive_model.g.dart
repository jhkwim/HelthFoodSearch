// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteHiveModelAdapter extends TypeAdapter<FavoriteHiveModel> {
  @override
  final int typeId = 3;

  @override
  FavoriteHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteHiveModel(
      reportNo: fields[0] as String,
      prdlstNm: fields[1] as String,
      addedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.reportNo)
      ..writeByte(1)
      ..write(obj.prdlstNm)
      ..writeByte(2)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
