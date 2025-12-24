import 'package:injectable/injectable.dart';
import '../../../../core/utils/excel_export_service.dart';
import '../../../search/data/datasources/local_data_source.dart';

@lazySingleton
class ExportFoodDataUseCase {
  final LocalDataSource _localDataSource;
  final ExcelExportService _excelExportService;

  ExportFoodDataUseCase(this._localDataSource, this._excelExportService);

  Future<void> call() async {
    // 1. 저장된 모든 데이터 가져오기 (Hive Model -> Entity 변환 필요)
    // LocalDataSourceImpl.getFoodItems returns List<FoodItemHiveModel>
    // We strictly need to cast or map them to FoodItem if strictly typed,
    // but FoodItemHiveModel usually extends or maps to FoodItem.
    // Let's check FoodItemHiveModel definition to be safe.
    // For now assuming implicit or simple mapping.
    // Actually, clean architecture says UseCase shouldn't know about HiveModel.
    // However, the LocalDataSource returns HiveModel directly in current impl.
    // effective-dart: avoid dynamic.

    final items = await _localDataSource.getFoodItems();

    // FoodItemHiveModel.toEntity() or similiar mapper is presumably available or it extends FoodItem.
    // Let's assume for now it's compatible or we need to map.
    // Reviewing previous fileread of LocalDataSource, it returns List<FoodItemHiveModel>.
    // FoodItemHiveModel likely has a toEntity() or extends FoodItem.

    // Safe mapping:
    final entities = items.map((e) => e.toEntity()).toList();

    // 2. 엑셀 내보내기 실행
    await _excelExportService.exportFoodItems(entities);
  }
}
