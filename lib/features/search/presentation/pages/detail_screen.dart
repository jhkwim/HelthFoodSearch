import 'package:flutter/material.dart';
import '../../domain/entities/food_item.dart';

class DetailScreen extends StatelessWidget {
  final FoodItem item;

  const DetailScreen({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('제품 상세 정보')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             SelectableText(
               item.prdlstNm,
               style: Theme.of(context).textTheme.displaySmall, // Large Title
             ),
             const SizedBox(height: 16),
             _buildSection(context, '신고번호', item.reportNo),
             _buildSection(context, '제조사', item.bsshNm),
             _buildSection(context, '허가일자', item.prmsDt),
             const Divider(height: 32),
             Text('주원료 (기능성 원료)', style: Theme.of(context).textTheme.headlineMedium),
             const SizedBox(height: 16),
             Wrap(
               spacing: 8,
               runSpacing: 8,
               children: item.mainIngredients.map((ing) {
                 return ActionChip(
                   label: Text(ing),
                   onPressed: () {
                     // TODO: Navigate to Ingredient Search with this ingredient pre-selected
                     // Or add to a "Search Basket"
                     // Requirement 3.3.2: Checkbox multiselect and search button.
                     // Making this screen stateful or just simple chips for now as MVP.
                   },
                 );
               }).toList(),
             ),
             const SizedBox(height: 24),
             const Text('원료 전체 목록 (정보)', style: TextStyle(color: Colors.grey)),
             Text(item.rawmtrlNm, style: const TextStyle(color: Colors.grey)),
           ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
