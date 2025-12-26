import 'package:flutter/material.dart';
import 'package:health_food_search/l10n/app_localizations.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'product_list_skeleton.dart';
import '../../../../core/widgets/empty_state_widget.dart';

import '../../domain/entities/food_item.dart';
import '../bloc/ingredient_search_cubit.dart';
import '../../../../core/widgets/staggered_list_item.dart';
import '../../../favorite/presentation/bloc/favorite_cubit.dart';

class IngredientSearchTab extends StatelessWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;
  final bool useSlivers;
  final VoidCallback? onSuggestionSelected;

  const IngredientSearchTab({
    super.key,
    this.onItemSelected,
    this.selectedReportNo,
    this.useSlivers = false,
    this.onSuggestionSelected,
  });

  @override
  Widget build(BuildContext context) {
    // Expect IngredientSearchCubit to be provided by parent (MainScreen)
    return _IngredientSearchContent(
      onItemSelected: onItemSelected,
      selectedReportNo: selectedReportNo,
      useSlivers: useSlivers,
      onSuggestionSelected: onSuggestionSelected,
    );
  }
}

class _IngredientSearchContent extends StatefulWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;
  final bool useSlivers;
  final VoidCallback? onSuggestionSelected;

  const _IngredientSearchContent({
    this.onItemSelected,
    this.selectedReportNo,
    this.useSlivers = false,
    this.onSuggestionSelected,
  });

  @override
  State<_IngredientSearchContent> createState() =>
      _IngredientSearchContentState();
}

class _IngredientSearchContentState extends State<_IngredientSearchContent>
    with AutomaticKeepAliveClientMixin {
  final Set<String> _shownItems = {};
  List<FoodItem>? _lastFoods;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (widget.useSlivers) {
      return _buildSliverLayout(context);
    }
    return _buildStandardLayout(context);
  }

  // Mobile Layout (Slivers)
  Widget _buildSliverLayout(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('IngredientSearchTab'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        // Search Header (Field + Options) moved to MainScreen

        // Selected Chips - Scroll away
        const SliverToBoxAdapter(child: Divider(height: 1)),
        _buildResultsArea(context, isSliver: true),
      ],
    );
  }

  // Standard Layout
  Widget _buildStandardLayout(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16), // Slight spacing
        Expanded(child: _buildResultsArea(context, isSliver: false)),
      ],
    );
  }

  Widget _buildResultsArea(BuildContext context, {required bool isSliver}) {
    return BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
      builder: (context, state) {
        // Only check suggestions existence. Controller/Focus logic is now in MainScreen or handled there.
        // Assuming updateSuggestions clears suggestions when empty.
        if (state.suggestions.isNotEmpty) {
          if (isSliver) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final suggestion = state.suggestions[index];
                return ListTile(
                  title: Text(suggestion.name),
                  onTap: () {
                    context.read<IngredientSearchCubit>().addIngredient(
                      suggestion.name,
                    );
                    widget.onSuggestionSelected?.call();
                  },
                );
              }, childCount: state.suggestions.length),
            );
          }
          return ListView.builder(
            itemCount: state.suggestions.length,
            itemBuilder: (context, index) {
              final suggestion = state.suggestions[index];
              return ListTile(
                title: Text(suggestion.name),
                onTap: () {
                  context.read<IngredientSearchCubit>().addIngredient(
                    suggestion.name,
                  );
                  widget.onSuggestionSelected?.call();
                },
              );
            },
          );
        }

        if (state.status == IngredientSearchStatus.loading) {
          if (isSliver) {
            return SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ProductListItemSkeleton(),
                ),
                childCount: 6,
              ),
            );
          }
          return LayoutBuilder(
            builder: (context, constraints) {
              final isGrid = constraints.maxWidth > 480;
              if (isGrid) {
                final crossAxisCount = (constraints.maxWidth / 300)
                    .floor()
                    .clamp(2, 4);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 240,
                  ),
                  itemCount: 8,
                  itemBuilder: (context, index) =>
                      const ProductListItemSkeleton(),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: 6,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) =>
                    const ProductListItemSkeleton(),
              );
            },
          );
        } else if (state.status == IngredientSearchStatus.error) {
          final errWidget = Center(
            child: Text(
              AppLocalizations.of(
                context,
              )!.errorOccurred(state.errorMessage ?? ''),
            ),
          );
          return isSliver ? SliverFillRemaining(child: errWidget) : errWidget;
        } else if (state.status == IngredientSearchStatus.loaded) {
          if (state.searchResults.isEmpty) {
            final emptyWidget = EmptyStateWidget(
              message: AppLocalizations.of(
                context,
              )!.searchIngredientEmptyResult,
              icon: Icons.search_off,
            );
            return isSliver
                ? SliverFillRemaining(child: emptyWidget)
                : emptyWidget;
          }

          if (isSliver) {
            return SliverLayoutBuilder(
              builder: (context, constraints) {
                final isGrid = constraints.crossAxisExtent > 480;
                // Header for result count
                final countHeader = SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.searchResultCount(state.searchResults.length),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );

                if (isGrid) {
                  final crossAxisCount = (constraints.crossAxisExtent / 300)
                      .floor()
                      .clamp(2, 4);
                  final grid = SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 240,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = state.searchResults[index];
                      final isSelected =
                          item.reportNo == widget.selectedReportNo;
                      // ... (rest of logic same as before)
                      if (state.searchResults != _lastFoods) {
                        _shownItems.clear();
                        _lastFoods = state.searchResults;
                      }
                      final shouldAnimate =
                          !_shownItems.contains(item.reportNo) && index < 12;
                      if (shouldAnimate) _shownItems.add(item.reportNo);

                      return StaggeredListItem(
                        index: index,
                        shouldAnimate: shouldAnimate,
                        child: _FoodItemCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => _handleItemTap(context, item),
                        ),
                      );
                    }, childCount: state.searchResults.length),
                  );
                  return SliverMainAxisGroup(slivers: [countHeader, grid]);
                }

                // List Layout (Mobile)
                final list = SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final item = state.searchResults[index];
                    final isSelected = item.reportNo == widget.selectedReportNo;

                    if (state.searchResults != _lastFoods) {
                      _shownItems.clear();
                      _lastFoods = state.searchResults;
                    }

                    final shouldAnimate =
                        !_shownItems.contains(item.reportNo) && index < 12;
                    if (shouldAnimate) _shownItems.add(item.reportNo);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: StaggeredListItem(
                        index: index,
                        shouldAnimate: shouldAnimate,
                        child: _FoodItemCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () => _handleItemTap(context, item),
                        ),
                      ),
                    );
                  }, childCount: state.searchResults.length),
                );
                return SliverMainAxisGroup(slivers: [countHeader, list]);
              },
            );
          }

          // Standard Layout (Box)
          return LayoutBuilder(
            builder: (context, constraints) {
              final isGrid = constraints.maxWidth > 480;
              final header = Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
                child: Text(
                  AppLocalizations.of(
                    context,
                  )!.searchResultCount(state.searchResults.length),
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );

              if (isGrid) {
                final crossAxisCount = (constraints.maxWidth / 300)
                    .floor()
                    .clamp(2, 4);
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    header,
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 240,
                        ),
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, index) {
                          final item = state.searchResults[index];
                          final isSelected =
                              item.reportNo == widget.selectedReportNo;

                          if (state.searchResults != _lastFoods) {
                            _shownItems.clear();
                            _lastFoods = state.searchResults;
                          }

                          final shouldAnimate =
                              !_shownItems.contains(item.reportNo) &&
                              index < 12;
                          if (shouldAnimate) _shownItems.add(item.reportNo);

                          return StaggeredListItem(
                            index: index,
                            shouldAnimate: shouldAnimate,
                            child: _FoodItemCard(
                              item: item,
                              isSelected: isSelected,
                              onTap: () => _handleItemTap(context, item),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  header,
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.searchResults.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = state.searchResults[index];
                        final isSelected =
                            item.reportNo == widget.selectedReportNo;

                        if (state.searchResults != _lastFoods) {
                          _shownItems.clear();
                          _lastFoods = state.searchResults;
                        }

                        final shouldAnimate =
                            !_shownItems.contains(item.reportNo) && index < 12;
                        if (shouldAnimate) _shownItems.add(item.reportNo);

                        return StaggeredListItem(
                          index: index,
                          shouldAnimate: shouldAnimate,
                          child: _FoodItemCard(
                            item: item,
                            isSelected: isSelected,
                            onTap: () => _handleItemTap(context, item),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        }

        final initWidget = EmptyStateWidget(
          message: AppLocalizations.of(context)!.searchIngredientInitial,
          icon: Icons.search,
          iconSize: 48,
        );
        return isSliver ? SliverFillRemaining(child: initWidget) : initWidget;
      },
    );
  }

  void _handleItemTap(BuildContext context, FoodItem item) {
    if (widget.onItemSelected != null) {
      widget.onItemSelected!(item);
    } else {
      context.push('/detail', extra: item);
    }
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const _FoodItemCard({
    required this.item,
    required this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
            : BorderSide.none,
      ),
      color: null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white.withValues(alpha: 0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.metaReportNo(item.reportNo),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      final isFav = state.isFavorite(item.reportNo);
                      return GestureDetector(
                        onTap: () {
                          context.read<FavoriteCubit>().toggleFavorite(
                            reportNo: item.reportNo,
                            prdlstNm: item.prdlstNm,
                          );
                        },
                        child: Icon(
                          isFav ? Icons.bookmark : Icons.bookmark_border,
                          color: isFav
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ],
              ),
              Text(
                item.prdlstNm,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                  height: 1.2,
                  // fontFamily: 'Pretendard', // Example usage
                ),
              ),
              const SizedBox(height: 12),
              if (item.mainIngredients.isNotEmpty)
                RichText(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5),
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.metaMainIngredients,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      TextSpan(
                        text: item.mainIngredients.take(5).join(', '),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
