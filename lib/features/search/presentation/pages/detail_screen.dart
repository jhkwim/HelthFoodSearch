import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';

class DetailScreen extends StatelessWidget {
  final FoodItem item;
  final Function(String)? onIngredientSelected;

  const DetailScreen({super.key, required this.item, this.onIngredientSelected});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('제품 상세 정보'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Section
            _buildHeader(context),
            const SizedBox(height: 24),

            // 1. Basic Information (기본 정보) -> Table
            _buildInfoCard(
              context,
              title: '기본 정보',
              icon: Icons.info_outline,
              child: _buildTable([
                _InfoRow('제조사', item.bsshNm),
                _InfoRow('신고번호', item.reportNo),
                _InfoRow('허가일자', item.prmsDt),
                _InfoRow('소비기한', item.pogDaycnt),
                _InfoRow('성상', item.dispos),
                _InfoRow('제품유형', item.prdlstCdnm),
              ]),
            ),
            const SizedBox(height: 16),

            // 2. Functionality (주된 기능성) -> Highlighted
            if (item.primaryFnclty.isNotEmpty)
              _buildInfoCard(
                context,
                title: '주된 기능성',
                icon: Icons.verified_user_outlined,
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                child: Text(
                  item.primaryFnclty,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.6),
                ),
              ),
            const SizedBox(height: 16),

            // 3. Intake & Caution (섭취 및 주의사항)
            _buildInfoCard(
              context,
              title: '섭취 및 보관',
              icon: Icons.medication_outlined,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   if (item.ntkMthd.isNotEmpty) ...[
                    _buildSubTitle('섭취 방법'),
                    Text(item.ntkMthd, style: const TextStyle(height: 1.5)),
                    const SizedBox(height: 16),
                  ],
                  if (item.iftknAtntMatrCn.isNotEmpty) ...[
                    _buildSubTitle('섭취 시 주의사항', color: Colors.red),
                    Text(item.iftknAtntMatrCn, style: const TextStyle(height: 1.5, color: Colors.black87)),
                    const SizedBox(height: 16),
                  ],
                  if (item.cstdyMthd.isNotEmpty) ...[
                    _buildSubTitle('보관 방법'),
                    Text(item.cstdyMthd, style: const TextStyle(height: 1.5)),
                  ],
                ],
              ),
            ),
             const SizedBox(height: 16),
            
            // 4. Detailed Specs (기준 규격 & 포장)
             _buildInfoCard(
              context,
              title: '상세 정보',
              icon: Icons.list_alt,
              child: _buildTable([
                _InfoRow('기준규격', item.stdrStnd),
                _InfoRow('포장재질', item.frmlcMtrqlt),
                _InfoRow('포장방법', item.frmlcMthd),
                _InfoRow('어린이 인증', item.childCrtfcYn),
                _InfoRow('생산종료', item.production),
                _InfoRow('인허가번호', item.lcnsNo),
              ]),
            ),
            const SizedBox(height: 16),

            // 5. Ingredients (원료 정보)
             _buildInfoCard(
              context,
              title: '원료 정보',
              icon: Icons.grass,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('주원료 (클릭하여 검색)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: item.mainIngredients.map((ing) {
                      return ActionChip(
                        label: Text(ing),
                        onPressed: () {
                          if (onIngredientSelected != null) {
                             onIngredientSelected!(ing);
                          }
                        },
                        backgroundColor: Theme.of(context).cardColor,
                        side: BorderSide(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                      );
                    }).toList(),
                  ),
                  const Divider(height: 32),
                  
                   if (item.indivRawmtrlNm.isNotEmpty) ...[
                    _buildSubTitle('기능성 원재료'),
                    Text(item.indivRawmtrlNm),
                    const SizedBox(height: 16),
                  ],
                  if (item.etcRawmtrlNm.isNotEmpty) ...[
                    _buildSubTitle('기타 원재료'),
                    Text(item.etcRawmtrlNm),
                    const SizedBox(height: 16),
                  ],
                   if (item.capRawmtrlNm.isNotEmpty) ...[
                    _buildSubTitle('캡슐 원재료'),
                    Text(item.capRawmtrlNm),
                    const SizedBox(height: 16),
                  ],
                  
                  // Expandable Full List
                  ExpansionTile(
                    title: const Text('전체 원료 목록 보기', style: TextStyle(fontSize: 14)),
                    tilePadding: EdgeInsets.zero,
                     children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(item.rawmtrlNm, style: const TextStyle(fontSize: 13, height: 1.5, color: Colors.black54)),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          item.prdlstNm,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            '신고번호: ${item.reportNo}',
            style: TextStyle(color: Colors.grey[700], fontSize: 12),
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
                style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                row.value,
                style: const TextStyle(color: Colors.black87, fontSize: 14),
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
        style: TextStyle(
          fontWeight: FontWeight.bold, 
          fontSize: 14, 
          color: color ?? Colors.black87
        ),
      ),
    );
  }
}

class _InfoRow {
  final String label;
  final String value;
  _InfoRow(this.label, this.value);
}
