import 'package:flutter/material.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import '../../../../core/enums/ingredient_search_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/food_item.dart';
import '../bloc/ingredient_search_cubit.dart';

class IngredientSearchTab extends StatelessWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;

  const IngredientSearchTab({super.key, this.onItemSelected, this.selectedReportNo});

  @override
  Widget build(BuildContext context) {
    // Expect IngredientSearchCubit to be provided by parent (MainScreen)
    return _IngredientSearchContent(
      onItemSelected: onItemSelected,
      selectedReportNo: selectedReportNo,
    );
  }
}

class _IngredientSearchContent extends StatefulWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;

  const _IngredientSearchContent({this.onItemSelected, this.selectedReportNo});

  @override
  State<_IngredientSearchContent> createState() => _IngredientSearchContentState();
}

class _IngredientSearchContentState extends State<_IngredientSearchContent> with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        // 1. Top Control Area (Search + Options + Chips)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Field
              _buildSearchField(context),
              const SizedBox(height: 12),
              
              // Search Mode Options (Row)
              BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
                builder: (context, state) {
                  return Row(
                    children: [
                      Text(AppLocalizations.of(context)!.searchModeLabel, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(width: 12),
                      _buildModeChip(
                        context, 
                        label: AppLocalizations.of(context)!.searchModeInclude, 
                        isSelected: state.searchType == IngredientSearchType.include,
                        onTap: () => context.read<IngredientSearchCubit>().setSearchType(IngredientSearchType.include),
                      ),
                      const SizedBox(width: 8),
                      _buildModeChip(
                        context, 
                        label: AppLocalizations.of(context)!.searchModeExclusive, 
                        isSelected: state.searchType == IngredientSearchType.exclusive,
                        onTap: () => context.read<IngredientSearchCubit>().setSearchType(IngredientSearchType.exclusive),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 12),

              // Selected Ingredients Chips
              BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
                builder: (context, state) {
                  if (state.selectedIngredients.isEmpty) return const SizedBox.shrink();
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: state.selectedIngredients.map((ing) {
                          return Chip(
                            label: Text(ing, style: const TextStyle(fontSize: 12)),
                            onDeleted: () {
                              context.read<IngredientSearchCubit>().removeIngredient(ing);
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        
        const Divider(height: 1),

        // 2. Results Area
        Expanded(
          child: BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
            builder: (context, state) {
              if (state.suggestions.isNotEmpty && _focusNode.hasFocus && _controller.text.isNotEmpty) {
                 return ListView.builder(
                    itemCount: state.suggestions.length,
                    itemBuilder: (context, index) {
                      final suggestion = state.suggestions[index];
                      return ListTile(
                        title: Text(suggestion.name),
                        onTap: () {
                          context.read<IngredientSearchCubit>().addIngredient(suggestion.name);
                          _controller.clear();
                          context.read<IngredientSearchCubit>().updateSuggestions('');
                        },
                      );
                    },
                  );
              }

              if (state.status == IngredientSearchStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == IngredientSearchStatus.error) {
                return Center(child: Text(AppLocalizations.of(context)!.errorOccurred(state.errorMessage ?? '')));
              } else if (state.status == IngredientSearchStatus.loaded) {
                if (state.searchResults.isEmpty) {
                  return Center(child: Text(AppLocalizations.of(context)!.searchIngredientEmptyResult));
                }
                
                return LayoutBuilder(
                  builder: (context, constraints) {
                    final isGrid = constraints.maxWidth > 480;
                    
                    if (isGrid) {
                      final crossAxisCount = (constraints.maxWidth / 300).floor().clamp(2, 4); // Adjusted width
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          mainAxisExtent: 240, // Fixed height for consistent look regardless of width
                        ),
                        itemCount: state.searchResults.length,
                        itemBuilder: (context, index) {
                          final item = state.searchResults[index];
                          final isSelected = item.reportNo == widget.selectedReportNo;
                          return _FoodItemCard(
                            item: item,
                            isSelected: isSelected,
                            onTap: () {
                              if (widget.onItemSelected != null) {
                                widget.onItemSelected!(item);
                              } else {
                                context.push('/detail', extra: item);
                              }
                            },
                          );
                        },
                      );
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.searchResults.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final item = state.searchResults[index];
                        final isSelected = item.reportNo == widget.selectedReportNo;
                        return _FoodItemCard(
                          item: item,
                          isSelected: isSelected,
                          onTap: () {
                            if (widget.onItemSelected != null) {
                              widget.onItemSelected!(item);
                            } else {
                              context.push('/detail', extra: item);
                            }
                          },
                        );
                      },
                    );
                  },
                );
              }
              
              
              return Center(child: Text(AppLocalizations.of(context)!.searchIngredientInitial));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModeChip(BuildContext context, {required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.searchIngredientLabel,
        hintText: AppLocalizations.of(context)!.searchIngredientHintExample,
        suffixIcon: const Icon(Icons.add_circle_outline),
      ),
      onChanged: (value) {
        context.read<IngredientSearchCubit>().updateSuggestions(value);
      },
      onSubmitted: (value) {
        context.read<IngredientSearchCubit>().addIngredient(value);
        _controller.clear();
      },
    );
  }
}

class _FoodItemCard extends StatelessWidget {
  final FoodItem item;
  final VoidCallback onTap;
  final bool isSelected;

  const _FoodItemCard({required this.item, required this.onTap, this.isSelected = false});

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
              Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.metaReportNo(item.reportNo),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
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
                    ),
              ),
              const SizedBox(height: 12),
              if (item.mainIngredients.isNotEmpty)
                RichText(
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                      height: 1.5,
                    ),
                    children: [
                       TextSpan(
                        text: AppLocalizations.of(context)!.metaMainIngredients,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                      TextSpan(
                        text: item.mainIngredients.take(5).join(", "),
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
