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
import '../../../../core/utils/sliver_tab_bar_delegate.dart';

import '../bloc/search_cubit.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import '../../../favorite/presentation/bloc/favorite_cubit.dart';

class MainScreen extends StatefulWidget {
  final List<String>? initialIngredients;

  const MainScreen({super.key, this.initialIngredients});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _productSearchController =
      TextEditingController();
  final TextEditingController _ingredientSearchController =
      TextEditingController();
  final FocusNode _productFocusNode = FocusNode();
  final FocusNode _ingredientFocusNode = FocusNode();

  late TabController _tabController;
  FoodItem? _selectedItem;
  bool _initialIngredientsHandled = false;

  int _previousTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 새로운 원재료가 전달되면 플래그 리셋
    if (widget.initialIngredients != oldWidget.initialIngredients &&
        widget.initialIngredients != null &&
        widget.initialIngredients!.isNotEmpty) {
      _initialIngredientsHandled = false;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();
    _productSearchController.dispose();
    _ingredientSearchController.dispose();
    _productFocusNode.dispose();
    _ingredientFocusNode.dispose();
    super.dispose();
  }

  void _handleTabSelection() {
    // 스와이프 중 index가 변경되면 즉시 헤더 업데이트
    if (_tabController.index != _previousTabIndex) {
      _previousTabIndex = _tabController.index;
      setState(() {
        _selectedItem = null;
      });
    }
  }

  PreferredSizeWidget _buildHeaderBottom(
    BuildContext context,
    IngredientSearchState state,
  ) {
    if (_tabController.index == 0) {
      // Product Search Header
      return PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: TextField(
            controller: _productSearchController,
            focusNode: _productFocusNode,
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.navProductSearch,
              hintText: AppLocalizations.of(context)!.searchProductHintExample,
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _productSearchController.clear();
                  context.read<SearchCubit>().search('');
                },
              ),
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
            ),
            textInputAction: TextInputAction.search,
            onSubmitted: (query) {
              context.read<SearchCubit>().search(query);
            },
          ),
        ),
      );
    } else {
      // Ingredient Search Header
      // Check if any ingredients are selected to adjust height
      // Actually we need to watch state to know if we need extra space?
      // PreferredSize widget requires fixed size.
      // If we want dynamic size in SliverAppBar, it's tricky.
      // Let's set a height that accommodates chips if we use a scrolling row.
      // Base height 120 (Text + Options). Chips row ~40-50. Total ~170?
      // But if no chips, we want less space?
      // Standard SliverAppBar bottom doesn't animate height easily.
      // Let's stick to a reasonable fixed height that includes chips,
      // OR use a layout that allows empty space (Container will just be empty).
      // Let's try 160.
      final ingredients = state.selectedIngredients;
      final bool hasChips = ingredients.isNotEmpty;

      // Dynamic Height Calculation
      // TextField + Label (~60-70)
      // Options Row (~40)
      // Chips Row (~40) + Padding
      // Base: 120. With Chips: 170.
      final double headerHeight = hasChips ? 180.0 : 130.0;

      return PreferredSize(
        preferredSize: Size.fromHeight(headerHeight),
        child: Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _ingredientSearchController,
                focusNode: _ingredientFocusNode,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(
                    context,
                  )!.searchIngredientLabel,
                  hintText: AppLocalizations.of(
                    context,
                  )!.searchIngredientHintExample,
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {
                      final val = _ingredientSearchController.text;
                      if (val.isNotEmpty) {
                        context.read<IngredientSearchCubit>().addIngredient(
                          val,
                        );
                        _ingredientSearchController.clear();
                      }
                    },
                  ),
                  filled: true,
                  fillColor: Theme.of(context).cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                onChanged: (value) {
                  context.read<IngredientSearchCubit>().updateSuggestions(
                    value,
                  );
                },
                onSubmitted: (value) {
                  context.read<IngredientSearchCubit>().addIngredient(value);
                  _ingredientSearchController.clear();
                },
              ),
              const SizedBox(height: 8),
              // Search Options Row
              // Note: We already have state passed in, but the content below might use Builder?
              // The logic below is static enough, we can use state directly.
              Builder(
                builder: (context) {
                  // Reusing state passed from _buildHeaderBottom argument
                  // But wait, the children need context too.
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.searchModeLabel,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 12),
                            _buildModeChip(
                              context,
                              label: AppLocalizations.of(
                                context,
                              )!.searchModeInclude,
                              isSelected:
                                  state.searchType ==
                                  IngredientSearchType.include,
                              onTap: () => context
                                  .read<IngredientSearchCubit>()
                                  .setSearchType(IngredientSearchType.include),
                            ),
                            const SizedBox(width: 8),
                            _buildModeChip(
                              context,
                              label: AppLocalizations.of(
                                context,
                              )!.searchModeExclusive,
                              isSelected:
                                  state.searchType ==
                                  IngredientSearchType.exclusive,
                              onTap: () => context
                                  .read<IngredientSearchCubit>()
                                  .setSearchType(
                                    IngredientSearchType.exclusive,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      if (state.selectedIngredients.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        // Selected Chips Row
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: state.selectedIngredients.map((ing) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Chip(
                                  label: Text(
                                    ing,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  onDeleted: () {
                                    context
                                        .read<IngredientSearchCubit>()
                                        .removeIngredient(ing);
                                  },
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  backgroundColor: Theme.of(
                                    context,
                                  ).primaryColor.withValues(alpha: 0.1),
                                  deleteIconColor: Theme.of(
                                    context,
                                  ).primaryColor,
                                  side: BorderSide.none,
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildModeChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Theme.of(context).hintColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<IngredientSearchCubit>()),
        BlocProvider(create: (context) => getIt<SearchCubit>()),
        BlocProvider(
          create: (context) => getIt<FavoriteCubit>()..loadFavorites(),
        ),
      ],
      child: Builder(
        builder: (context) {
          // 초기 원재료가 전달된 경우 원재료 탭으로 이동 후 검색
          if (!_initialIngredientsHandled &&
              widget.initialIngredients != null &&
              widget.initialIngredients!.isNotEmpty) {
            _initialIngredientsHandled = true;
            // Cubit 참조를 콜백 전에 캡처
            final cubit = context.read<IngredientSearchCubit>();
            final ingredients = widget.initialIngredients!;
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              _tabController.animateTo(1); // 원재료 탭으로 이동
              cubit.replaceIngredients(ingredients);
              await cubit.search();
              // 검색 완료 후 첫 항목 선택
              if (cubit.state.searchResults.isNotEmpty && mounted) {
                setState(() {
                  _selectedItem = cubit.state.searchResults.first;
                });
              }
            });
          }

          return LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;

              // Function to handle ingredient selection
              void handleIngredientSelection(List<String> ingredients) {
                _tabController.animateTo(1); // Switch to Ingredient Tab

                final cubit = context.read<IngredientSearchCubit>();
                cubit.replaceIngredients(ingredients);
                cubit.search();
              }

              // Mobile / Narrow Layout
              if (!isWide) {
                return Scaffold(
                  body: SafeArea(
                    top: true,
                    bottom: false,
                    child: NestedScrollView(
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                            return <Widget>[
                              BlocBuilder<
                                IngredientSearchCubit,
                                IngredientSearchState
                              >(
                                builder: (context, state) {
                                  return SliverAppBar(
                                    title: Text(
                                      AppLocalizations.of(context)!.appTitle,
                                    ),
                                    centerTitle: false,
                                    automaticallyImplyLeading: false,
                                    floating: true,
                                    snap: true,
                                    pinned: false,
                                    bottom: _buildHeaderBottom(
                                      context,
                                      state,
                                    ), // Dynamic Search Area
                                    actions: [
                                      IconButton(
                                        icon: const Icon(Icons.bookmark),
                                        onPressed: () {
                                          context.push('/favorites');
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.settings),
                                        onPressed: () {
                                          context.push('/settings');
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),

                              // Progress bar needs to be visible
                              SliverToBoxAdapter(child: _buildSyncProgress()),

                              SliverOverlapAbsorber(
                                handle:
                                    NestedScrollView.sliverOverlapAbsorberHandleFor(
                                      context,
                                    ),
                                sliver: SliverPersistentHeader(
                                  delegate: SliverTabBarDelegate(
                                    TabBar(
                                      controller: _tabController,
                                      tabs: [
                                        Tab(
                                          text: AppLocalizations.of(
                                            context,
                                          )!.navProductSearch,
                                        ),
                                        Tab(
                                          text: AppLocalizations.of(
                                            context,
                                          )!.navIngredientSearch,
                                        ),
                                      ],
                                      labelStyle: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      indicatorWeight: 4,
                                    ),
                                  ),
                                  pinned: true,
                                ),
                              ),
                            ];
                          },
                      body: TabBarView(
                        controller: _tabController,
                        children: [
                          ProductSearchTab(
                            useSlivers: true,
                            onItemSelected: (item) => _navigateToDetailMobile(
                              context,
                              item,
                              handleIngredientSelection,
                            ),
                          ),
                          IngredientSearchTab(
                            useSlivers: true,
                            onItemSelected: (item) => _navigateToDetailMobile(
                              context,
                              item,
                              handleIngredientSelection,
                            ),
                            onSuggestionSelected: () {
                              _ingredientSearchController.clear();
                              _ingredientFocusNode.unfocus();
                              context
                                  .read<IngredientSearchCubit>()
                                  .updateSuggestions('');
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              // Desktop / Wide Layout (Split View)
              return MultiBlocListener(
                listeners: [
                  // 제품명 검색 결과 첫 항목 자동 선택
                  BlocListener<SearchCubit, SearchState>(
                    listener: (context, state) {
                      if (state is SearchLoaded && state.foods.isNotEmpty) {
                        setState(() {
                          _selectedItem = state.foods.first;
                        });
                      }
                    },
                  ),
                  // 원료별 검색 결과 첫 항목 자동 선택
                  BlocListener<IngredientSearchCubit, IngredientSearchState>(
                    listener: (context, state) {
                      if (state.status == IngredientSearchStatus.loaded &&
                          state.searchResults.isNotEmpty) {
                        setState(() {
                          _selectedItem = state.searchResults.first;
                        });
                      }
                    },
                  ),
                ],
                child: Scaffold(
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
                                          Tab(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.navProductSearch,
                                          ),
                                          Tab(
                                            text: AppLocalizations.of(
                                              context,
                                            )!.navIngredientSearch,
                                          ),
                                        ],
                                        labelStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        indicatorWeight: 3,
                                      ),
                                    ),
                                    Expanded(
                                      child: TabBarView(
                                        controller: _tabController,
                                        children: [
                                          ProductSearchTab(
                                            selectedReportNo:
                                                _selectedItem?.reportNo,
                                            onItemSelected: (item) {
                                              setState(() {
                                                _selectedItem = item;
                                              });
                                            },
                                          ),
                                          IngredientSearchTab(
                                            selectedReportNo:
                                                _selectedItem?.reportNo,
                                            onItemSelected: (item) {
                                              setState(() {
                                                _selectedItem = item;
                                              });
                                            },
                                            onSuggestionSelected: () {
                                              _ingredientSearchController
                                                  .clear();
                                              // Desktop might not need unfocus, but good for consistency or if using touch
                                              _ingredientSearchController
                                                  .clear();
                                              context
                                                  .read<IngredientSearchCubit>()
                                                  .updateSuggestions('');
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.touch_app_outlined,
                                              size: 64,
                                              color: Colors.grey[400],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              AppLocalizations.of(
                                                context,
                                              )!.searchEmptyGuide,
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : DetailScreen(
                                        key: ValueKey(_selectedItem!.reportNo),
                                        item: _selectedItem!,
                                        onIngredientSelected:
                                            handleIngredientSelection, // Use callback
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _navigateToDetailMobile(
    BuildContext context,
    FoodItem item,
    Function(List<String>) onIngredientSelected,
  ) {
    context.push(
      '/detail',
      extra: {
        'item': item,
        'onIngredientSelected': (List<String> ingredients) {
          // We need to pop first to go back to MainScreen
          context.pop();
          // Then Trigger callback
          onIngredientSelected(ingredients);
        },
      },
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context, {
    required bool isWide,
  }) {
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
              labelStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              // indicatorColor: Colors.white, // Removed to fix invisible indicator on white background
              indicatorWeight: 4,
            ),
      actions: [
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: () {
            context.push('/favorites');
          },
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            context.push('/settings');
          },
        ),
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
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.syncProgress(percent.toString()),
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
