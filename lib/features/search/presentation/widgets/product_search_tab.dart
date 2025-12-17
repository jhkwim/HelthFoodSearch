import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/food_item.dart';
import '../bloc/search_cubit.dart';

class ProductSearchTab extends StatefulWidget {
  final Function(FoodItem)? onItemSelected;
  final String? selectedReportNo;

  const ProductSearchTab({super.key, this.onItemSelected, this.selectedReportNo});

  @override
  State<ProductSearchTab> createState() => _ProductSearchTabState();
}

class _ProductSearchTabState extends State<ProductSearchTab> with AutomaticKeepAliveClientMixin {
  final TextEditingController _controller = TextEditingController();

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
    
    return BlocProvider(
      create: (context) => getIt<SearchCubit>(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Builder(builder: (context) {
              return TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: '제품명 검색',
                  hintText: '예: 비타민',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => _controller.clear(),
                  ),
                ),
                style: Theme.of(context).textTheme.bodyLarge,
                textInputAction: TextInputAction.search, // Better mobile/keyboard UX
                onSubmitted: (query) {
                  context.read<SearchCubit>().search(query);
                },
              );
            }),
          ),
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchError) {
                  return Center(child: Text('오류 발생: ${state.message}'));
                } else if (state is SearchLoaded) {
                  if (state.foods.isEmpty) {
                    return const Center(child: Text('검색 결과가 없습니다.'));
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final isGrid = constraints.maxWidth > 500;
                      
                      if (isGrid) {
                        final crossAxisCount = (constraints.maxWidth / 300).floor().clamp(2, 4);
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.5, // Adjust based on content
                          ),
                          itemCount: state.foods.length,
                          itemBuilder: (context, index) {
                            final item = state.foods[index];
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
                        itemCount: state.foods.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = state.foods[index];
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
                return const Center(child: Text('제품명을 입력하여 검색하세요.'));
              },
            ),
          ),
        ],
      ),
    );
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
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected 
          ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
          : BorderSide.none,
      ),
      color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.05) : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
             mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.prdlstNm,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 18,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: Theme.of(context).primaryColor,
                    ),
              ),
              const SizedBox(height: 8),
              if (item.reportNo != null)
              Text(
                '신고번호: ${item.reportNo}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),
              if (item.mainIngredients.isNotEmpty)
                Text(
                  '주원료: ${item.mainIngredients.take(3).join(", ")}${item.mainIngredients.length > 3 ? "..." : ""}',
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
