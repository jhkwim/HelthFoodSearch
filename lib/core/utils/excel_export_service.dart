import 'package:flutter/foundation.dart'; // for compute
import 'package:health_food_search/core/utils/ingredient_refiner.dart'; // for analyze
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:universal_io/io.dart';
import '../../features/search/domain/entities/food_item.dart';

@lazySingleton
class ExcelExportService {
  /// 주어진 FoodItem 리스트를 엑셀 파일로 변환하고, 저장된 경로를 반환하거나 공유합니다.
  Future<void> exportFoodItems(List<FoodItem> items) async {
    // 백그라운드에서 엑셀 생성 처리 (Isolate)
    final List<int>? fileBytes = await compute(_generateExcelBytes, items);

    if (fileBytes != null) {
      final String timestamp = DateTime.now()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final String fileName = 'food_items_$timestamp.xlsx';

      try {
        // 임시 디렉토리에 저장
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/$fileName';

        final File file = File(filePath);
        await file.writeAsBytes(fileBytes, flush: true);

        // 공유 실행
        // ignore: deprecated_member_use
        await Share.shareXFiles([XFile(filePath)], text: '저장된 식품 정보 엑셀 파일입니다.');
      } catch (e) {
        throw Exception('파일 저장 또는 공유 중 오류가 발생했습니다: $e');
      }
    }
  }

  // Static function for compute
  static List<int>? _generateExcelBytes(List<FoodItem> items) {
    // Import needed packages inside if strictly needed? No, top level imports work for compute.
    // However, IngredientRefiner must be accessible.

    final Excel excel = Excel.createExcel();

    // --- Sheet 1: 식품 정보 (Food Info) ---
    final String sheetName = '식품 정보';
    excel.rename(excel.getDefaultSheet()!, sheetName);
    final Sheet sheetObject = excel[sheetName];

    // 헤더 추가
    final List<String> headers = [
      '품목제조신고번호', // reportNo
      '제품명', // prdlstNm
      '원재료명(원본)', // rawmtrlNm
      '주원료(정제됨)', // mainIngredients
      '제조사', // bsshNm
      '허가일자', // prmsDt
      '유통기한', // pogDaycnt
    ];
    _appendRow(sheetObject, headers);

    // --- Sheet 2: 정제 리포트 (Refinement Report) ---
    final String reportSheetName = '정제 리포트';
    final Sheet reportSheet = excel[reportSheetName];
    _appendRow(reportSheet, ['원본 원재료명', '정제된 원재료명', '빈도수']);

    // Stats Accumulators
    final Map<String, int> frequencyMap = {};
    final Map<String, String> mappingMap = {};

    // 데이터 처리 Loop
    for (var item in items) {
      // Sheet 1 Row
      final List<String> row = [
        item.reportNo,
        item.prdlstNm,
        item.rawmtrlNm,
        item.mainIngredients.join(', '),
        item.bsshNm,
        item.prmsDt,
        item.pogDaycnt,
      ];
      _appendRow(sheetObject, row);

      // Analyze for Report
      final analysis = IngredientRefiner.analyze(item.rawmtrlNm);
      analysis.forEach((raw, refined) {
        mappingMap[raw] = refined;
        frequencyMap[raw] = (frequencyMap[raw] ?? 0) + 1;
      });
    }

    // Build Report Rows
    final sortedKeys = frequencyMap.keys.toList()
      ..sort((a, b) => frequencyMap[b]!.compareTo(frequencyMap[a]!));

    for (var raw in sortedKeys) {
      final refined = mappingMap[raw] ?? '';
      final count = frequencyMap[raw] ?? 0;
      _appendRow(reportSheet, [
        raw,
        refined,
        '$count', // Just number
      ]);
    }

    return excel.save();
  }

  static void _appendRow(Sheet sheet, List<String> rowData) {
    sheet.appendRow(rowData.map(TextCellValue.new).toList());
  }
}
