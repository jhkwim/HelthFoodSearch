import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/food_item.dart';
import '../bloc/search_cubit.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import 'product_list_skeleton.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/staggered_list_item.dart';
import '../../../favorite/presentation/bloc/favorite_cubit.dart';

class ProductSearchTab extends StatefulWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;
  final bool useSlivers;

  const ProductSearchTab({
    super.key,
    this.onItemSelected,
    this.selectedReportNo,
    this.useSlivers = false,
  });

  @override
  State<ProductSearchTab> createState() => _ProductSearchTabState();
}

class _ProductSearchTabState extends State<ProductSearchTab>
    with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final Set<String> _shownItems = {};
  List<FoodItem>? _lastFoods;

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for KeepAlive

    // Use ancestor provider
    return Builder(
      builder: (context) {
        return widget.useSlivers
            ? _buildSliverLayout(context)
            : _buildStandardLayout(context);
      },
    );
  }

  // Mobile Layout (Slivers)
  Widget _buildSliverLayout(BuildContext context) {
    return CustomScrollView(
      key: const PageStorageKey('ProductSearchTab'),
      slivers: [
        SliverOverlapInjector(
          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
        ),
        // Search Field removed (Moved to Main Screen Header)
        BlocBuilder<SearchCubit, SearchState>(
          builder: (context, state) {
            if (state is SearchLoading) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ProductListItemSkeleton(),
                  ),
                  childCount: 6,
                ),
              );
            } else if (state is SearchError) {
              return SliverFillRemaining(
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.errorOccurred(state.message),
                  ),
                ),
              );
            } else if (state is SearchLoaded) {
              if (state.foods.isEmpty) {
                return SliverFillRemaining(
                  child: EmptyStateWidget(
                    message: AppLocalizations.of(context)!.searchProductEmpty,
                    icon: Icons.search_off,
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  // 검색 결과 개수 헤더 (Index 0)
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                      child: Text(
                        AppLocalizations.of(
                          context,
                        )!.searchResultCount(state.foods.length),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  // 실제 데이터 아이템 (Index - 1)
                  final itemIndex = index - 1;

                  if (state.foods != _lastFoods) {
                    _shownItems.clear();
                    _lastFoods = state.foods;
                  }

                  final item = state.foods[itemIndex];
                  final shouldAnimate =
                      !_shownItems.contains(item.reportNo) && itemIndex < 12;
                  if (shouldAnimate) _shownItems.add(item.reportNo);

                  final isSelected = item.reportNo == widget.selectedReportNo;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: StaggeredListItem(
                      index: itemIndex,
                      shouldAnimate: shouldAnimate,
                      child: _FoodItemCard(
                        item: item,
                        isSelected: isSelected,
                        highlightQuery: state.query,
                        onTap: () {
                          if (widget.onItemSelected != null) {
                            widget.onItemSelected!(item);
                          } else {
                            context.push('/detail', extra: item);
                          }
                        },
                      ),
                    ),
                  );
                }, childCount: state.foods.length + 1),
              );
            }
            return SliverFillRemaining(
              child: EmptyStateWidget(
                message: AppLocalizations.of(context)!.searchProductInitial,
                icon: Icons.search,
                iconSize: 48,
              ),
            );
          },
        ),
      ],
    );
  }

  // Desktop/Tablet Layout (Standard Column)
  Widget _buildStandardLayout(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildSearchField(context),
        ),
        Expanded(
          child: BlocBuilder<SearchCubit, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isGrid = constraints.maxWidth > 480;
                    if (isGrid) {
                      final crossAxisCount = (constraints.maxWidth / 250)
                          .floor()
                          .clamp(2, 6);
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
              } else if (state is SearchError) {
                return Center(
                  child: Text(
                    AppLocalizations.of(context)!.errorOccurred(state.message),
                  ),
                );
              } else if (state is SearchLoaded) {
                // Reuse existing grid/list logic for desktop
                if (state.foods.isEmpty) {
                  return EmptyStateWidget(
                    message: AppLocalizations.of(context)!.searchProductEmpty,
                    icon: Icons.search_off,
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isGrid = constraints.maxWidth > 480;
                    if (isGrid) {
                      final crossAxisCount = (constraints.maxWidth / 250)
                          .floor()
                          .clamp(2, 6);
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 240,
                        ),
                        itemCount: state.foods.length,
                        itemBuilder: (context, index) {
                          final item = state.foods[index];
                          final isSelected =
                              item.reportNo == widget.selectedReportNo;
                          if (state.foods != _lastFoods) {
                            _shownItems.clear();
                            _lastFoods = state.foods;
                          }

                          final shouldAnimate =
                              !_shownItems.contains(item.reportNo) &&
                              index < 12;
                          if (shouldAnimate) {
                            _shownItems.add(item.reportNo);
                          }

                          return StaggeredListItem(
                            index: index,
                            shouldAnimate: shouldAnimate,
                            child: _FoodItemCard(
                              item: item,
                              isSelected: isSelected,
                              highlightQuery: state.query,
                              onTap: () {
                                if (widget.onItemSelected != null) {
                                  widget.onItemSelected!(item);
                                } else {
                                  context.push('/detail', extra: item);
                                }
                              },
                            ),
                          );
                        },
                      );
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.foods.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        if (state.foods != _lastFoods) {
                          _shownItems.clear();
                          _lastFoods = state.foods;
                        }

                        final item = state.foods[index];
                        final shouldAnimate =
                            !_shownItems.contains(item.reportNo) && index < 12;
                        if (shouldAnimate) {
                          _shownItems.add(item.reportNo);
                        }

                        return StaggeredListItem(
                          index: index,
                          shouldAnimate: shouldAnimate,
                          child: _FoodItemCard(
                            item: item,
                            isSelected:
                                state.foods[index].reportNo ==
                                widget.selectedReportNo,
                            highlightQuery: state.query,
                            onTap: () {
                              if (widget.onItemSelected != null) {
                                widget.onItemSelected!(state.foods[index]);
                              } else {
                                context.push(
                                  '/detail',
                                  extra: state.foods[index],
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
                );
              }
              return EmptyStateWidget(
                message: AppLocalizations.of(context)!.searchProductInitial,
                icon: Icons.search,
                iconSize: 48,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: l10n.navProductSearch,
        hintText: l10n.searchProductHintExample,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: IconButton(
          icon: const Icon(Icons.clear),
          onPressed: _controller.clear,
        ),
      ),
      style: Theme.of(context).textTheme.bodyLarge,
      textInputAction: TextInputAction.search,
      onSubmitted: (query) {
        context.read<SearchCubit>().search(query);
      },
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final bool isSelected;
  final String highlightQuery;

  const _FoodItemCard({
    required this.item,
    required this.onTap,
    this.isSelected = false,
    this.highlightQuery = '',
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
      color: null, // Clean look, no background color
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
              // Product Name with Highlighting
              if (highlightQuery.isNotEmpty)
                RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                      height: 1.2,
                    ),
                    children: _buildHighlightSpans(
                      item.prdlstNm,
                      highlightQuery,
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: Theme.of(context).primaryColor,
                            height: 1.2,
                          ) ??
                          const TextStyle(),
                      Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            backgroundColor: Theme.of(
                              context,
                            ).primaryColor.withValues(alpha: 0.2),
                            height: 1.2,
                          ) ??
                          const TextStyle(),
                    ),
                  ),
                )
              else
                Text(
                  item.prdlstNm,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 18,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                    height: 1.2,
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
                        text:
                            ' ${item.mainIngredients.take(5).join(", ")}${item.mainIngredients.length > 5 ? "..." : ""}',
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

  List<InlineSpan> _buildHighlightSpans(
    String text,
    String query,
    TextStyle normalStyle,
    TextStyle highlightStyle,
  ) {
    if (query.isEmpty) return [TextSpan(text: text, style: normalStyle)];

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final List<InlineSpan> spans = [];
    int start = 0;
    int indexOfMatch = lowerText.indexOf(lowerQuery, start);

    while (indexOfMatch != -1) {
      if (indexOfMatch > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, indexOfMatch),
            style: normalStyle,
          ),
        );
      }
      spans.add(
        TextSpan(
          text: text.substring(indexOfMatch, indexOfMatch + query.length),
          style: highlightStyle,
        ),
      );
      start = indexOfMatch + query.length;
      indexOfMatch = lowerText.indexOf(lowerQuery, start);
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return spans;
  }
}
