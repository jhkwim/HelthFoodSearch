
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dartz/dartz.dart' show Either; // or just dartz
import '../../../../core/di/injection.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_raw_materials_usecase.dart';
import '../../domain/entities/food_item.dart';
import '../../../../core/utils/ingredient_refiner.dart';

class DetailScreen extends StatefulWidget {
  final FoodItem item;
  final Function(List<String>)? onIngredientSelected;

  const DetailScreen({super.key, required this.item, this.onIngredientSelected});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final Set<String> _selectedIngredients = {};

  List<String> _getCombinedIngredients() {
    // Only show RAWMTRL_NM in the main list
    return widget.item.mainIngredients;
  }

  int _selectedTabIndex = 0;

  void _toggleIngredient(String ingredient) {
    setState(() {
      if (_selectedIngredients.contains(ingredient)) {
        _selectedIngredients.remove(ingredient);
      } else {
        _selectedIngredients.add(ingredient);
      }
    });
  }

  Widget _buildIngredientTabs() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Custom Tab Bar
        Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildTabItem(0, '기능성 원료'),
              _buildTabItem(1, '기타 원자재'),
              _buildTabItem(2, '복합/캡슐'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Tab Content
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _buildTabUniqueContent(),
        ),
      ],
    );
  }

  Widget _buildTabItem(int index, String label) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            boxShadow: isSelected ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2, offset: const Offset(0, 1))] : null,
          ),
          margin: const EdgeInsets.all(2),
            alignment: Alignment.center,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                    fontSize: 13, // Slight adjustment if labelLarge is too big, but aim for consistency
                  ),
            ),
          ),
      ),
    );
  }

  Widget _buildTabUniqueContent() {
    switch (_selectedTabIndex) {
      case 0:
        return widget.item.indivRawmtrlNm.isEmpty 
          ? const Text('-', style: TextStyle(color: Colors.grey)) 
          : _buildNumberedList(widget.item.indivRawmtrlNm);
      case 1:
        return widget.item.etcRawmtrlNm.isEmpty 
          ? const Text('-', style: TextStyle(color: Colors.grey)) 
          : _buildNumberedList(widget.item.etcRawmtrlNm);
      case 2:
        return widget.item.capRawmtrlNm.isEmpty 
          ? const Text('-', style: TextStyle(color: Colors.grey)) 
          : _buildNumberedList(widget.item.capRawmtrlNm);
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 상세 정보'),
        elevation: 0,
      ),
      body: Center(
                child: SelectionArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header Section (Product Name)
                        _buildHeader(context),
                        const SizedBox(height: 24),

                        // 2. Basic Info (Company, Report, Date, Expiration, Appearance, Form)
                        _buildInfoCard(
                          context,
                          title: '기본 정보',
                          icon: Icons.info_outline,
                          child: _buildTable([
                            _InfoRow('업소명', widget.item.bsshNm),
                            _InfoRow('신고번호', widget.item.reportNo),
                            _InfoRow('등록일자', widget.item.prmsDt),
                            _InfoRow('소비기한', widget.item.pogDaycnt),
                            _InfoRow('성상', widget.item.dispos),
                            _InfoRow('제품형태', widget.item.prdtShapCdNm),
                          ]),
                        ),
                        const SizedBox(height: 16),

                         // 3. Packaging (Material/Method)
                        _buildInfoCard(
                          context,
                          title: '포장 정보',
                          icon: Icons.inventory_2_outlined,
                          child: _buildTable([
                            _InfoRow('포장재질', widget.item.frmlcMtrqlt),
                            _InfoRow('포장방법', widget.item.frmlcMthd),
                          ]),
                        ),
                         const SizedBox(height: 16),

                        // 4. Intake (Method/Amount)
                        _buildInfoCard(
                          context,
                          title: '섭취량 및 섭취방법',
                          icon: Icons.restaurant_menu,
                          child: Text(
                            widget.item.ntkMthd.isEmpty ? '-' : widget.item.ntkMthd, 
                            style: const TextStyle(height: 1.5)
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 5. Functionality Content
                        _buildInfoCard(
                          context,
                          title: '기능성 내용',
                          icon: Icons.verified_user_outlined,
                          color: Theme.of(context).primaryColor.withOpacity(0.05),
                          child: Text(
                            widget.item.primaryFnclty.isEmpty ? '-' : widget.item.primaryFnclty,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.6),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 6. Standards
                        _buildInfoCard(
                          context,
                          title: '기준 및 규격',
                          icon: Icons.gavel_outlined,
                          child: Text(
                            widget.item.stdrStnd.isEmpty ? '-' : widget.item.stdrStnd, 
                            style: const TextStyle(height: 1.5)
                          ),
                        ),
                        const SizedBox(height: 16),

                        // 7. Cautions & Storage
                         _buildInfoCard(
                          context,
                          title: '주의사항 및 보관',
                          icon: Icons.warning_amber_rounded,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                _buildSubTitle('섭취 시 주의사항', color: Colors.red),
                                Text(
                                  widget.item.iftknAtntMatrCn.isEmpty ? '-' : widget.item.iftknAtntMatrCn, 
                                  style: const TextStyle(height: 1.5, color: Colors.black87)
                                ),
                                const SizedBox(height: 16),
                              
                                _buildSubTitle('보존 및 유통기준'),
                                Text(
                                  widget.item.cstdyMthd.isEmpty ? '-' : widget.item.cstdyMthd, 
                                  style: const TextStyle(height: 1.5)
                                ),
                            ],
                          ),
                        ),
                         const SizedBox(height: 16),

                        // 8. Ingredients
                        // 8. Ingredients
                        _buildInfoCard(
                          context,
                          title: '원료 정보',
                          icon: Icons.grass,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               // 8.1 Primary: Raw Materials (Searchable)
                               Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('원재료 정보 (검색 가능)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                                  if (widget.onIngredientSelected != null)
                                    Text('${_selectedIngredients.length}개 선택됨', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: _getCombinedIngredients().asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final ing = entry.value;
                                  final isSelected = _selectedIngredients.contains(ing);
                                  return ActionChip(
                                    label: Text(ing),
                                    onPressed: () {
                                      if (widget.onIngredientSelected != null) {
                                         _toggleIngredient(ing);
                                      }
                                    },
                                    avatar: isSelected 
                                      ? const Icon(Icons.check, size: 16, color: Colors.white)
                                      : CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(fontSize: 10, color: Colors.black87),
                                          ),
                                        ),
                                    backgroundColor: isSelected ? Theme.of(context).primaryColor : Theme.of(context).cardColor,
                                    labelStyle: TextStyle(
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    side: BorderSide(
                                      color: isSelected ? Colors.transparent : Theme.of(context).primaryColor.withOpacity(0.2)
                                    ),
                                  );
                                }).toList(),
                              ),
                              const Divider(height: 32),
                              
                              // 8.2 Secondary: Detail Tabs (Functional, Etc, Capsule)
                              _buildIngredientTabs(),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        // C003 Raw Materials Section (Separate Card)
                        FutureBuilder<Either<Failure, List<String>?>>(
                          future: getIt<GetRawMaterialsUseCase>()(widget.item.reportNo),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return snapshot.data?.fold(
                                (l) => const SizedBox(), 
                                (r) {
                                  if (r == null || r.isEmpty) return const SizedBox();
                                  return _buildInfoCard(
                                    context, 
                                    title: '품목제조신고 원재료', 
                                    icon: Icons.science_outlined,
                                    child: _buildBulletList(r),
                                  );
                                }
                              ) ?? const SizedBox();
                            }
                            return const Center(child: CircularProgressIndicator());
                          },
                        ),
                        const SizedBox(height: 80), // Space for FAB
                      ],
                      ),
                    ),
                  ),
              ),
      floatingActionButton: _selectedIngredients.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                if (widget.onIngredientSelected != null) {
                  widget.onIngredientSelected!(_selectedIngredients.toList());
                }
              },
              icon: const Icon(Icons.search),
              label: Text('${_selectedIngredients.length}개 원료로 검색'),
            )
          : null,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          widget.item.prdlstNm,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String title, required IconData icon, required Widget child, Color? color}) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      color: color ?? Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildTable(List<_InfoRow> rows) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(100),
        1: FlexColumnWidth(),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: rows.map((row) {
        if (row.value.isEmpty) return null;
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                row.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700], // Darker grey for better legibility
                      fontWeight: FontWeight.w600, // Slightly bolder
                    ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                row.value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                    ),
              ),
            ),
          ],
        );
      }).whereType<TableRow>().toList(),
    );
  }

  Widget _buildSubTitle(String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black87,
        ),
      ),
    );
  }

  Widget _buildNumberedList(String rawString) {
    if (rawString.isEmpty) return const SizedBox.shrink();
    
    // Split by comma and filter empty
    final list = rawString.split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    return _buildListContent(list);
  }



  Widget _buildListContent(List<String> list) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(list.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${index + 1}. ',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
              ),
              Expanded(
                child: Text(
                  list[index],
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: Colors.black87,
                      ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
  Widget _buildBulletList(List<String> list) {
    if (list.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('•  ', 
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: Colors.black54
                )
              ),
              Expanded(
                child: Text(
                  item,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
