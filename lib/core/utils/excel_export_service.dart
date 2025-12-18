
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
    final Excel excel = Excel.createExcel();
    
    // 기본 시트 이름 변경
    final String sheetName = 'SavedFoodItems';
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

    // 데이터 추가
    for (var item in items) {
      final List<String> row = [
        item.reportNo,
        item.prdlstNm,
        item.rawmtrlNm,
        item.mainIngredients.join(', '), // 리스트를 문자열로 변환
        item.bsshNm,
        item.prmsDt,
        item.pogDaycnt,
      ];
      _appendRow(sheetObject, row);
    }

    // 파일 저장
    final List<int>? fileBytes = excel.save();
    
    if (fileBytes != null) {
      final String timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').split('.').first;
      final String fileName = 'food_items_$timestamp.xlsx';
      
      try {
        // 임시 디렉토리에 저장
        final Directory tempDir = await getTemporaryDirectory();
        final String filePath = '${tempDir.path}/$fileName';
        
        final File file = File(filePath);
        await file.writeAsBytes(fileBytes, flush: true);
        
        // 공유 실행
        await Share.shareXFiles([XFile(filePath)], text: '저장된 식품 정보 엑셀 파일입니다.');
        
      } catch (e) {
        throw Exception('파일 저장 또는 공유 중 오류가 발생했습니다: $e');
      }
    }
  }

  void _appendRow(Sheet sheet, List<String> rowData) {
    sheet.appendRow(rowData.map((e) => TextCellValue(e)).toList());
  }
}
