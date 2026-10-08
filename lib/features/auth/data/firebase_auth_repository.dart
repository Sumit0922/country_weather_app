import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/constants/api_fields.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/errors/app_exception.dart';
import '../domain/app_user.dart';
import '../domain/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._auth);

  final FirebaseAuth _auth;

  @override
  Stream<AppUser?> watchUser() {
    return _auth.authStateChanges().map(
      (user) => user == null ? null : AppUser(id: user.uid, email: user.email),
    );
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw _mapError(error);
    } catch (_) {
      throw const AppException(AppStrings.unexpectedError);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (error) {
      throw _mapError(error);
    } catch (_) {
      throw const AppException(AppStrings.unexpectedError);
    }
  }

  AppException _mapError(FirebaseAuthException error) {
    final message = switch (error.code) {
      FirebaseErrorCodes.invalidCredential ||
      FirebaseErrorCodes.invalidLoginCredentials ||
      FirebaseErrorCodes.userNotFound ||
      FirebaseErrorCodes.wrongPassword => AppStrings.invalidCredentials,
      FirebaseErrorCodes.invalidEmail => AppStrings.invalidEmail,
      FirebaseErrorCodes.userDisabled => AppStrings.disabledAccount,
      FirebaseErrorCodes.tooManyRequests => AppStrings.tooManyRequests,
      FirebaseErrorCodes.networkRequestFailed => AppStrings.networkError,
      FirebaseErrorCodes.operationNotAllowed => AppStrings.authUnavailable,
      FirebaseErrorCodes.userTokenExpired ||
      FirebaseErrorCodes.invalidUserToken => AppStrings.authExpired,
      _ => AppStrings.unexpectedError,
    };

    return AppException(message);
  }
}
