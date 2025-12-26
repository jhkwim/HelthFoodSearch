import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_food_search/l10n/app_localizations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../bloc/favorite_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    // 진입 시 최신 데이터 로드
    getIt<FavoriteCubit>().loadFavorites();

    return BlocProvider.value(
      value: getIt<FavoriteCubit>(),
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.favoritesTitle), elevation: 0),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
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
                icon: Icons.favorite_border,
                message: l10n.favoritesEmpty,
                subMessage: l10n.favoritesEmptyGuide,
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final item = state.favorites[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.favorite, color: Colors.red),
                    title: Text(
                      item.prdlstNm,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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
                      },
                    ),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            l10n.favoritesViewDetail(item.prdlstNm),
                          ),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
