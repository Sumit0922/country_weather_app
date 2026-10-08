import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/dependencies.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../../../widgets/app_splash.dart';
import '../../../widgets/app_state_view.dart';
import '../../countries/presentation/countries_screen.dart';
import '../domain/app_user.dart';
import 'login_screen.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);

    return session.when(
      loading: () => const AppSplash(),
      error: (error, stackTrace) => Scaffold(
        body: SafeArea(
          child: AppStateView(
            title: AppStrings.errorTitle,
            message: ErrorMessage.from(error),
            onRetry: () => ref.invalidate(authSessionProvider),
          ),
        ),
      ),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }

        return _AuthenticatedNavigator(key: ValueKey(user.id), user: user);
      },
    );
  }
}

class _AuthenticatedNavigator extends StatefulWidget {
  const _AuthenticatedNavigator({required this.user, super.key});

  final AppUser user;

  @override
  State<_AuthenticatedNavigator> createState() =>
      _AuthenticatedNavigatorState();
}

class _AuthenticatedNavigatorState extends State<_AuthenticatedNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return NavigatorPopHandler<void>(
      onPopWithResult: (_) {
        _navigatorKey.currentState?.maybePop();
      },
      child: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (_) => MaterialPageRoute<void>(
          builder: (_) => CountriesScreen(user: widget.user),
        ),
      ),
    );
  }
}
