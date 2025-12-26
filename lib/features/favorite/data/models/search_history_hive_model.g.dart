// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_history_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SearchHistoryHiveModelAdapter
    extends TypeAdapter<SearchHistoryHiveModel> {
  @override
  final int typeId = 4;

  @override
  SearchHistoryHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SearchHistoryHiveModel(
      query: fields[0] as String,
      type: fields[1] as String,
      searchedAt: fields[2] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SearchHistoryHiveModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.query)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.searchedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchHistoryHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
