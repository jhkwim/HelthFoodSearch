import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_food_search/features/search/data/datasources/food_data_parser.dart';

void main() {
  group('FoodDataParser 테스트', () {
    test('Gzip 압축된 JSON 바이트를 정상적으로 파싱하고 원격 정제 룰을 적용한다', () async {
      // 1. Mock JSON 데이터 준비
      final mockData = [
        {
          'PRDLST_REPORT_NO': '20200001',
          'PRDLST_NM': '테스트 비타민C',
          'RAWMTRL_NM': '키토산제품,비타민 C',
          'BSSH_NM': '테스트 제약',
          'PRMS_DT': '2020-01-01',
          'PRIMARY_FNCLTY': '항산화',
        },
      ];

      final jsonString = jsonEncode(mockData);
      final jsonBytes = utf8.encode(jsonString);

      // Gzip 압축
      final compressedBytes =
          Uint8List.fromList(GZipEncoder().encode(jsonBytes)!);

      // 2. FoodDataParser 호출
      final result = await FoodDataParser.parseGzBytes(
        compressedBytes,
        refinementRules: {'비타민 C': '비타민C'},
      );

      // 3. 검증
      expect(result.length, 1);
      expect(result.first.reportNo, '20200001');
      expect(result.first.prdlstNm, '테스트 비타민C');
      // '키토산제품' -> '키토산/키토올리고당' (기본 룰), '비타민 C' -> '비타민C' (원격 룰)
      expect(result.first.mainIngredients.contains('키토산/키토올리고당'), isTrue);
      expect(result.first.mainIngredients.contains('비타민C'), isTrue);
    });

    test('압축되지 않은 일반 JSON 바이트도 방어적으로 정상 파싱한다', () async {
      final mockData = [
        {
          'PRDLST_REPORT_NO': '20200002',
          'PRDLST_NM': '일반 오메가3',
          'RAWMTRL_NM': '오메가-3지방산함유유지',
          'BSSH_NM': '건강생활',
          'PRMS_DT': '2021-05-01',
          'PRIMARY_FNCLTY': '혈행 개선',
        },
      ];

      final jsonBytes = Uint8List.fromList(utf8.encode(jsonEncode(mockData)));

      final result = await FoodDataParser.parseGzBytes(jsonBytes);

      expect(result.length, 1);
      expect(result.first.reportNo, '20200002');
      expect(result.first.prdlstNm, '일반 오메가3');
      expect(result.first.mainIngredients.contains('EPA및DHA함유유지'), isTrue);
    });
  });
}
