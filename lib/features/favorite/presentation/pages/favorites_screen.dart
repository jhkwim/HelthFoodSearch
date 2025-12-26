import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../bloc/favorite_cubit.dart';
import '../../../search/data/datasources/local_data_source.dart';
import '../../../search/domain/entities/food_item.dart';
import '../../../search/presentation/pages/detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  FoodItem? _selectedItem;
  bool _initialLoadDone = false;

  @override
  void initState() {
    super.initState();
    getIt<FavoriteCubit>().loadFavorites();
  }

  /// 첫 번째 즐겨찾기 아이템을 선택
  Future<void> _selectFirstItem(List favorites) async {
    if (_initialLoadDone || favorites.isEmpty) return;
    _initialLoadDone = true;

    final localDataSource = getIt<LocalDataSource>();
    final foodItem = await localDataSource.getFoodItemByReportNo(
      favorites.first.reportNo,
    );
    if (foodItem != null && mounted) {
      setState(() {
        _selectedItem = foodItem.toEntity();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider.value(
      value: getIt<FavoriteCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.favoritesTitle), elevation: 0),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;

            return BlocBuilder<FavoriteCubit, FavoriteState>(
              builder: (context, state) {
                if (state.status == FavoriteStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == FavoriteStatus.error) {
                  return EmptyStateWidget(
                    icon: Icons.error_outline,
                    message: l10n.favoritesErrorTitle,
                    subMessage: state.errorMessage,
                  );
                }

                if (state.favorites.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.bookmark_border,
                    message: l10n.favoritesEmpty,
                    subMessage: l10n.favoritesEmptyGuide,
                  );
                }

                // 큰 화면에서 첫 항목 자동 선택
                if (isWide && !_initialLoadDone) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _selectFirstItem(state.favorites);
                  });
                }

                if (isWide) {
                  // 데스크탑/태블릿: 좌측 목록 + 우측 상세
                  return Row(
                    children: [
                      // 좌측: 즐겨찾기 목록
                      Expanded(
                        flex: 5,
                        child: _buildFavoritesList(
                          context,
                          state,
                          isWide: true,
                        ),
                      ),
                      const VerticalDivider(width: 1),
                      // 우측: 상세 화면
                      Expanded(
                        flex: 7,
                        child: _selectedItem == null
                            ? _buildEmptyDetailView(l10n)
                            : DetailScreen(
                                item: _selectedItem!,
                                showAppBar: false,
                              ),
                      ),
                    ],
                  );
                } else {
                  // 모바일: 목록만 표시
                  return _buildFavoritesList(context, state, isWide: false);
                }
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyDetailView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app_outlined, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            l10n.searchEmptyGuide,
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(
    BuildContext context,
    FavoriteState state, {
    required bool isWide,
  }) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.favorites.length,
      itemBuilder: (context, index) {
        final item = state.favorites[index];
        final isSelected = _selectedItem?.reportNo == item.reportNo;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isWide && isSelected ? 3 : 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isWide && isSelected
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
          ),
          child: ListTile(
            leading: Icon(
              Icons.bookmark,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              item.prdlstNm,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Text(
              item.reportNo,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                context.read<FavoriteCubit>().toggleFavorite(
                  reportNo: item.reportNo,
                  prdlstNm: item.prdlstNm,
                );
                // 삭제한 아이템이 선택된 아이템이면 선택 해제
                if (_selectedItem?.reportNo == item.reportNo) {
                  setState(() {
                    _selectedItem = null;
                  });
                }
              },
            ),
            onTap: () async {
              final localDataSource = getIt<LocalDataSource>();
              final foodItem = await localDataSource.getFoodItemByReportNo(
                item.reportNo,
              );
              if (foodItem != null && mounted) {
                if (isWide) {
                  // 큰 화면: 우측 패널에 표시
                  setState(() {
                    _selectedItem = foodItem.toEntity();
                  });
                } else {
                  // 모바일: 상세 화면으로 이동
                  if (!mounted) return;
                  context.push('/detail', extra: foodItem.toEntity());
                }
              } else {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('제품 정보를 찾을 수 없습니다')),
                );
              }
            },
          ),
        );
      },
    );
  }
}
