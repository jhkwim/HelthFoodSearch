import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/food_item.dart';
import '../bloc/ingredient_search_cubit.dart';

class IngredientSearchTab extends StatelessWidget {
  const IngredientSearchTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<IngredientSearchCubit>(),
      child: const _IngredientSearchContent(),
    );
  }
}

class _IngredientSearchContent extends StatefulWidget {
  const _IngredientSearchContent();

  @override
  State<_IngredientSearchContent> createState() => _IngredientSearchContentState();
}

class _IngredientSearchContentState extends State<_IngredientSearchContent> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Tag Input Area
              BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
                builder: (context, state) {
                  return Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: state.selectedIngredients.map((ing) {
                      return Chip(
                        label: Text(ing),
                        onDeleted: () {
                          context.read<IngredientSearchCubit>().removeIngredient(ing);
                        },
                      );
                    }).toList(),
                  );
                },
              ),
              const SizedBox(height: 16),
              // Autocomplete Input
              LayoutBuilder(
                builder: (context, constraints) {
                  return Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) async {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      context.read<IngredientSearchCubit>().updateSuggestions(textEditingValue.text);
                      // Introduce a small delay to allow Cubit to update state (Simplified)
                      // In 'real' app, use raw Autocomplete or custom Overlay for Stream/Bloc based suggestions.
                      // Here we just wait a bit or use hardcoded delay.
                      // Actually, Autocomplete expects synchronous return or Future.
                      // Let's rely on standard Autocomplete for local filtering, but we want DB suggestions.
                      // Better approach: Use RawAutocomplete with optionsBuilder calling UseCase directly?
                      // Or just TypeAheadField package (not added).
                      // Let's implement a custom overlay or just Simple TextField with Suggestions below.
                      return const Iterable<String>.empty(); 
                    },
                    // Replacing Autocomplete with Column + TextField + ListView for better Bloc control
                    optionsViewBuilder: (context, onSelected, options) => const SizedBox.shrink(),
                    fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) => const SizedBox.shrink(),
                  );
                },
              ),
              // Custom Autocomplete Implementation
               _buildSearchField(context),
            ],
          ),
        ),
        // Suggestions or Results
        Expanded(
          child: BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
            builder: (context, state) {
              // Priority: Suggestions (if typing) > Results (if searched)
              
              if (_focusNode.hasFocus && _controller.text.isNotEmpty && state.suggestions.isNotEmpty) {
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
                          // Keep focus?
                        },
                      );
                    },
                  );
              }

              if (state.status == IngredientSearchStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state.status == IngredientSearchStatus.error) {
                return Center(child: Text('오류: ${state.errorMessage}'));
              } else if (state.status == IngredientSearchStatus.loaded) {
                if (state.searchResults.isEmpty) {
                  return const Center(child: Text('조건에 맞는 제품이 없습니다.'));
                }
                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: state.searchResults.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = state.searchResults[index];
                    return _FoodItemCard(item: item);
                  },
                );
              }
              
              return const Center(child: Text('원료를 추가하고 검색하세요.'));
            },
          ),
        ),
        // Search Button and Options
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocBuilder<IngredientSearchCubit, IngredientSearchState>(
            builder: (context, state) {
              return Column(
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: state.matchAll,
                        onChanged: (value) {
                          context.read<IngredientSearchCubit>().toggleMatchAll(value ?? false);
                        },
                      ),
                      const Text('선택한 원료 모두 포함 (AND조건)'),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.selectedIngredients.isEmpty
                          ? null
                          : () {
                              context.read<IngredientSearchCubit>().search();
                              _focusNode.unfocus();
                            },
                      child: const Text('원료로 검색하기'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: const InputDecoration(
        labelText: '원료 추가',
        hintText: '원료명 입력 (예: 홍삼)',
        suffixIcon: Icon(Icons.add_circle_outline),
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

  const _FoodItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          context.push('/detail', extra: item);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.prdlstNm,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              if (item.mainIngredients.isNotEmpty)
                Text(
                  '주원료: ${item.mainIngredients.take(5).join(", ")}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
