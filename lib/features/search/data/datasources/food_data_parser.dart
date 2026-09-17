import 'dart:convert';
import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:archive/archive.dart';
import 'package:universal_io/io.dart';
import 'package:health_food_search/core/utils/ingredient_refiner.dart';
import '../models/dto/food_item_dto.dart';
import '../models/food_item_hive_model.dart';

/// Gzip 압축 해제 및 대용량 JSON 파싱을 담당하는 전담 파서
class FoodDataParser {
  /// 플랫폼에 맞게 Isolate 또는 Web 협력 루프를 통해 파싱 수행
  static Future<List<FoodItemHiveModel>> parseGzBytes(
    Uint8List gzBytes, {
    Map<String, String>? refinementRules,
  }) async {
    if (kIsWeb) {
      return _parseInternal(gzBytes, refinementRules);
    } else {
      return compute(_parseInIsolate, {
        'bytes': gzBytes,
        'rules': refinementRules ?? <String, String>{},
      });
    }
  }

  static List<FoodItemHiveModel> _parseInIsolate(Map<String, dynamic> params) {
    final bytes = params['bytes'] as Uint8List;
    final rules = params['rules'] as Map<String, String>;
    if (rules.isNotEmpty) {
      IngredientRefiner.updateRules(rules);
    }
    return _parseInternal(bytes, rules);
  }

  static List<FoodItemHiveModel> _parseInternal(
    Uint8List bytes,
    Map<String, String>? rules,
  ) {
    List<int> uncompressed;

    // Gzip Magic Number (0x1F, 0x8B) 검사
    if (bytes.length >= 2 && bytes[0] == 0x1F && bytes[1] == 0x8B) {
      if (kIsWeb) {
        uncompressed = GZipDecoder().decodeBytes(bytes);
      } else {
        uncompressed = gzip.decode(bytes);
      }
    } else {
      uncompressed = bytes; // 이미 압축 해제된 경우
    }

    final jsonString = utf8.decode(uncompressed);
    final dynamic decoded = jsonDecode(jsonString);
    final List<dynamic> list =
        decoded is List ? decoded : (decoded['items'] as List<dynamic>? ?? []);

    return list.map((item) {
      final dto = FoodItemDto.fromJson(item as Map<String, dynamic>);
      return FoodItemHiveModel.fromEntity(dto.toEntity());
    }).toList();
  }
}
