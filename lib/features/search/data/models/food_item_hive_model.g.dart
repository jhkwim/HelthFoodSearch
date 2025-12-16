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
      primaryFnclty: fields[6] == null ? '' : fields[6] as String,
      iftknAtntMatrCn: fields[7] == null ? '' : fields[7] as String,
      ntkMthd: fields[8] == null ? '' : fields[8] as String,
      cstdyMthd: fields[9] == null ? '' : fields[9] as String,
      pogDaycnt: fields[10] == null ? '' : fields[10] as String,
      dispos: fields[11] == null ? '' : fields[11] as String,
      lcnsNo: fields[12] == null ? '' : fields[12] as String,
      prdlstCdnm: fields[13] == null ? '' : fields[13] as String,
      stdrStnd: fields[14] == null ? '' : fields[14] as String,
      hiengLntrtDvsNm: fields[15] == null ? '' : fields[15] as String,
      production: fields[16] == null ? '' : fields[16] as String,
      childCrtfcYn: fields[17] == null ? '' : fields[17] as String,
      prdtShapCdNm: fields[18] == null ? '' : fields[18] as String,
      frmlcMtrqlt: fields[19] == null ? '' : fields[19] as String,
      indutyCdNm: fields[20] == null ? '' : fields[20] as String,
      lastUpdtDtm: fields[21] == null ? '' : fields[21] as String,
      indivRawmtrlNm: fields[22] == null ? '' : fields[22] as String,
      etcRawmtrlNm: fields[23] == null ? '' : fields[23] as String,
      capRawmtrlNm: fields[24] == null ? '' : fields[24] as String,
      frmlcMthd: fields[25] == null ? '' : fields[25] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItemHiveModel obj) {
    writer
      ..writeByte(26)
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
      ..write(obj.prmsDt)
      ..writeByte(6)
      ..write(obj.primaryFnclty)
      ..writeByte(7)
      ..write(obj.iftknAtntMatrCn)
      ..writeByte(8)
      ..write(obj.ntkMthd)
      ..writeByte(9)
      ..write(obj.cstdyMthd)
      ..writeByte(10)
      ..write(obj.pogDaycnt)
      ..writeByte(11)
      ..write(obj.dispos)
      ..writeByte(12)
      ..write(obj.lcnsNo)
      ..writeByte(13)
      ..write(obj.prdlstCdnm)
      ..writeByte(14)
      ..write(obj.stdrStnd)
      ..writeByte(15)
      ..write(obj.hiengLntrtDvsNm)
      ..writeByte(16)
      ..write(obj.production)
      ..writeByte(17)
      ..write(obj.childCrtfcYn)
      ..writeByte(18)
      ..write(obj.prdtShapCdNm)
      ..writeByte(19)
      ..write(obj.frmlcMtrqlt)
      ..writeByte(20)
      ..write(obj.indutyCdNm)
      ..writeByte(21)
      ..write(obj.lastUpdtDtm)
      ..writeByte(22)
      ..write(obj.indivRawmtrlNm)
      ..writeByte(23)
      ..write(obj.etcRawmtrlNm)
      ..writeByte(24)
      ..write(obj.capRawmtrlNm)
      ..writeByte(25)
      ..write(obj.frmlcMthd);
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
