import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/dependencies.dart';

enum AuthAction { signedIn, signedOut }

final authActionProvider = AsyncNotifierProvider<AuthViewModel, AuthAction?>(
  AuthViewModel.new,
  retry: (retryCount, error) => null,
);

class AuthViewModel extends AsyncNotifier<AuthAction?> {
  @override
  AuthAction? build() => null;

  Future<void> signIn({required String email, required String password}) async {
    if (state.isLoading) return;

    final repository = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    final result = await AsyncValue.guard<AuthAction?>(() async {
      await repository.signIn(email: email, password: password);

      return AuthAction.signedIn;
    });

    if (ref.mounted) {
      state = result;
    }
  }

  Future<void> signOut() async {
    if (state.isLoading) return;

    final repository = ref.read(authRepositoryProvider);

    state = const AsyncLoading();

    final result = await AsyncValue.guard<AuthAction?>(() async {
      await repository.signOut();
      return AuthAction.signedOut;
    });

    if (ref.mounted) {
      state = result;
    }
  }
}
