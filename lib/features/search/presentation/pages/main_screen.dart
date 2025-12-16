import 'package:flutter/material.dart';
import '../../../../core/di/injection.dart';
import '../../setting/presentation/bloc/settings_cubit.dart';
import 'widgets/ingredient_search_tab.dart';
import 'widgets/product_search_tab.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('건강기능식품 검색'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '제품명 검색'),
              Tab(text: '원료별 검색'),
            ],
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Large Text
            indicatorColor: Colors.white,
            indicatorWeight: 4,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                context.push('/settings');
              },
            )
          ],
        ),
        body: const TabBarView(
          children: [
            ProductSearchTab(),
            IngredientSearchTab(),
          ],
        ),
      ),
    );
  }
}
