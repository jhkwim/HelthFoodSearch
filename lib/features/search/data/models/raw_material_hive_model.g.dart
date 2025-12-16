// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_material_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RawMaterialHiveModelAdapter extends TypeAdapter<RawMaterialHiveModel> {
  @override
  final int typeId = 1;

  @override
  RawMaterialHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RawMaterialHiveModel(
      reportNo: fields[0] as String,
      rawMtrlNms: (fields[1] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RawMaterialHiveModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.reportNo)
      ..writeByte(1)
      ..write(obj.rawMtrlNms);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RawMaterialHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
