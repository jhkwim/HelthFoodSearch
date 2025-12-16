// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_item_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FoodItemHiveModelAdapter extends TypeAdapter<FoodItemHiveModel> {
  @override
  final int typeId = 0;

  @override
  FoodItemHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItemHiveModel(
      reportNo: fields[0] as String,
      prdlstNm: fields[1] as String,
      rawmtrlNm: fields[2] as String,
      mainIngredients: (fields[3] as List).cast<String>(),
      bsshNm: fields[4] as String,
      prmsDt: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItemHiveModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.reportNo)
      ..writeByte(1)
      ..write(obj.prdlstNm)
      ..writeByte(2)
      ..write(obj.rawmtrlNm)
      ..writeByte(3)
      ..write(obj.mainIngredients)
      ..writeByte(4)
      ..write(obj.bsshNm)
      ..writeByte(5)
      ..write(obj.prmsDt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FoodItemHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
