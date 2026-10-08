import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../features/auth/presentation/auth_view_model.dart';
import '../widgets/app_feedback.dart';
import 'bootstrap.dart';

class CountryWeatherApp extends ConsumerWidget {
  const CountryWeatherApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authActionProvider, (previous, next) {
      if (previous?.isLoading != true || next.isLoading) {
        return;
      }

      final action = next.asData?.value;

      if (action == AuthAction.signedIn) {
        AppFeedback.success(AppStrings.loginSuccess);
      } else if (action == AuthAction.signedOut) {
        AppFeedback.success(AppStrings.logoutSuccess);
      }
    });

    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: AppFeedback.messengerKey,
      theme: AppTheme.light,
      home: const Bootstrap(),
    );
  }
}
