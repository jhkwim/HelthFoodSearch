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
                      final isGrid = constraints.maxWidth > 480;
                      
                      if (isGrid) {
                        final crossAxisCount = (constraints.maxWidth / 250).floor().clamp(2, 2);
                        return GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.3, // Slightly taller for better fit
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
              if (item.reportNo != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '신고번호: ${item.reportNo}',
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
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: RichText(
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.black87,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: '주원료: ',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                          ),
                          TextSpan(
                            text: '${item.mainIngredients.take(5).join(", ")}${item.mainIngredients.length > 5 ? "..." : ""}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
