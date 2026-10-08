import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/app_config.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../widgets/app_feedback.dart';
import 'favorites_view_model.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({
    required this.userId,
    required this.countryCode,
    super.key,
  });

  final String userId;
  final String countryCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorite = ref.watch(favoritesProvider(userId)).contains(countryCode);

    return IconButton(
      tooltip: favorite ? AppStrings.removeFavorite : AppStrings.addFavorite,
      icon: AnimatedSwitcher(
        duration: MediaQuery.disableAnimationsOf(context)
            ? Duration.zero
            : AppConfig.animationDuration,
        child: Icon(
          favorite ? Icons.favorite : Icons.favorite_border,
          key: ValueKey(favorite),
          color: favorite ? AppColors.primary : AppColors.muted,
        ),
      ),
      onPressed: () async {
        try {
          await ref
              .read(favoritesProvider(userId).notifier)
              .toggle(countryCode);
        } catch (error) {
          AppFeedback.error(ErrorMessage.from(error));
        }
      },
    );
  }
}
