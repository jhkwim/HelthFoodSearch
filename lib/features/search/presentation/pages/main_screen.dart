import 'package:flutter/material.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Needed if accessing bloc? Actually SettingsCubit is just for navigation? No, just button.
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../bloc/data_sync_cubit.dart';
import '../widgets/ingredient_search_tab.dart';
import '../widgets/product_search_tab.dart';

import '../../domain/entities/food_item.dart';
import '../pages/detail_screen.dart';

import '../bloc/ingredient_search_cubit.dart';
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  FoodItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onIngredientSelected(String ingredient) {
    // 1. Switch to Ingredient Tab
    _tabController.animateTo(1);
    
    // 2. Add ingredient to search and trigger search?
    // Access IngredientSearchCubit from context? No, tabs have their own providers.
    // Solution: We need a way to communicate this.
    // Since we are inside MainScreen, we can access the Cubit if check where it is provided.
    // The tabs provide their own Cubits internally. This is slightly problematic for external control.
    // Ideally, the Cubit should be lifted up to MainScreen or accessed via a shared mechanism.
    // For now, let's refactor the tabs to accept an initial search term or expose a controller?
    // Or simpler: Lift the IngredientSearchCubit to MainScreen level so we can access it here.
    
    // Changing strategy: Lift IngredientSearchCubit to MainScreen level.
    // We will do this via context.read if providers are moved up.
    // But currently they are inside the tabs.
    // Let's assume we will move the providers up in the build method below.
    
    // Wait, context.read won't work if the provider is created effectively 'below' this context in the widget tree if we blindly move it.
    // But if we wrap MainScreen's body or Scaffold in the provider, we can access it.
  }
  
  // Re-implementation with Cubit lifted up
  @override
  Widget build(BuildContext context) {
     return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<IngredientSearchCubit>()),
        // SearchCubit is also used in ProductSearchTab, let's lift it too for consistency or leave it.
        // ProductSearchTab creates it. Let's leave it for now unless needed.
      ],
      child: Builder(
        builder: (context) {
          // Now we can access IngredientSearchCubit
          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;

              // Function to handle ingredient selection
              void handleIngredientSelection(List<String> ingredients) {
                _tabController.animateTo(1); // Switch to Ingredient Tab
                
                final cubit = context.read<IngredientSearchCubit>();
                cubit.replaceIngredients(ingredients);
                cubit.search();
                
                if (!isWide) {
                   // Logic for mobile is handled in _navigateToDetailMobile callback wrapper commonly.
                }
              }

              // Mobile / Narrow Layout
              if (!isWide) {
                return Scaffold(
                  appBar: _buildAppBar(context, isWide: false),
                  body: Column(
                    children: [
                      _buildSyncProgress(),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            ProductSearchTab(
                              onItemSelected: (item) => _navigateToDetailMobile(context, item, handleIngredientSelection),
                            ),
                            IngredientSearchTab(
                              onItemSelected: (item) => _navigateToDetailMobile(context, item, handleIngredientSelection),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              // Desktop / Wide Layout (Split View)
              return Scaffold(
                appBar: _buildAppBar(context, isWide: true),
                body: Center(
                  child: Column(
                    children: [
                      _buildSyncProgress(),
                      Expanded(
                        child: Row(
                          children: [
                            // Left Panel: Search Tabs
                            Expanded(
                              flex: 5,
                              child: Column(
                                children: [
                                  Container(
                                    color: Theme.of(context).cardColor,
                                    child: TabBar(
                                      controller: _tabController,
                                      tabs: [
                                        Tab(text: AppLocalizations.of(context)!.navProductSearch),
                                        Tab(text: AppLocalizations.of(context)!.navIngredientSearch),
                                      ],
                                      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      indicatorWeight: 3,
                                    ),
                                  ),
                                  Expanded(
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        ProductSearchTab(
                                          selectedReportNo: _selectedItem?.reportNo,
                                          onItemSelected: (item) {
                                            setState(() {
                                              _selectedItem = item;
                                            });
                                          },
                                        ),
                                        IngredientSearchTab(
                                          selectedReportNo: _selectedItem?.reportNo,
                                          onItemSelected: (item) {
                                            setState(() {
                                              _selectedItem = item;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const VerticalDivider(width: 1),
                            // Right Panel: Detail View
                            Expanded(
                              flex: 7,
                                child: _selectedItem == null
                                    ? Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.touch_app_outlined, size: 64, color: Colors.grey[400]),
                                            const SizedBox(height: 16),
                                            Text(
                                              AppLocalizations.of(context)!.searchEmptyGuide,
                                              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                                            ),
                                          ],
                                        ),
                                      )
                                    : DetailScreen(
                                        key: ValueKey(_selectedItem!.reportNo),
                                        item: _selectedItem!,
                                        onIngredientSelected: handleIngredientSelection, // Use callback
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),
              );
            },
          );
        }
      ),
    );
  }

  void _navigateToDetailMobile(BuildContext context, FoodItem item, Function(List<String>) onIngredientSelected) {
    context.push(
      '/detail', 
      extra: {
        'item': item,
        'onIngredientSelected': (List<String> ingredients) {
           // We need to pop first to go back to MainScreen
           context.pop();
           // Then Trigger callback
           onIngredientSelected(ingredients);
        }
      }
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, {required bool isWide}) {
    return AppBar(
      title: Text(AppLocalizations.of(context)!.appTitle),
      centerTitle: false,
      bottom: isWide
          ? null
          : TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: AppLocalizations.of(context)!.navProductSearch),
                Tab(text: AppLocalizations.of(context)!.navIngredientSearch),
              ],
              labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
    );
  }

  // Helper widget to show progress
  Widget _buildSyncProgress() {
    return BlocBuilder<DataSyncCubit, DataSyncState>(
      builder: (context, state) {
        if (state is DataSyncInProgress) {
          final percent = (state.progress * 100).toInt();
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.syncProgress(percent.toString()),
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
