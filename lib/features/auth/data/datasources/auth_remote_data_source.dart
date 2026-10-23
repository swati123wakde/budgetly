import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/error/exceptions.dart';
import '../models/user_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> loginWithEmail({required String email, required String password});
  Future<UserModel> loginWithGoogle();
  Future<UserModel> registerWithEmail({required String email, required String password});
}

/// Google sign-in goes through Firebase Auth. The same call is used by both
/// the Login and Register screens: Firebase creates the account on first
/// sign-in and simply signs the user in after that.
///
/// Email login/register are still the demo fakes. Demo rules: any valid email
/// works, except the password "wrongpass" (login) or the email
/// "taken@example.com" (register), which return an auth error.
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _auth = firebaseAuth,
        _googleSignIn = googleSignIn;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  @override
  Future<UserModel> loginWithGoogle() async {
    try {
      // Sign out of the plugin first so the account picker shows every time
      // instead of silently reusing the last account.
      await _googleSignIn.signOut();

      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw const CancelledException();

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final result = await _auth.signInWithCredential(credential);
      final user = result.user;
      if (user == null) throw const AuthException('Google sign-in failed. Please try again.');

      return UserModel(
        id: user.uid,
        email: user.email ?? googleUser.email,
        name: user.displayName ?? googleUser.displayName,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException(_firebaseMessage(e));
    } on PlatformException catch (e) {
      throw _googlePlatformError(e);
    }
  }

  /// Turns google_sign_in plugin errors into exceptions the repository understands.
  Exception _googlePlatformError(PlatformException e) {
    switch (e.code) {
      case GoogleSignIn.kSignInCanceledError:
        return const CancelledException();
      case GoogleSignIn.kNetworkError:
        return const ServerException('No internet connection. Please try again.');
      default:
      // "sign_in_failed" with ApiException 10 = SHA-1 fingerprint missing in
      // Firebase, or google-services.json is outdated.
        return const AuthException('Google sign-in failed. Please try again.');
    }
  }

  String _firebaseMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'This email is already registered with a different sign-in method.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'No internet connection. Please try again.';
      default:
        return e.message ?? 'Google sign-in failed. Please try again.';
    }
  }

  @override
  Future<UserModel> loginWithEmail({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (password == 'wrongpass') {
      throw const AuthException('Incorrect email or password.');
    }
    return UserModel(id: 'u_${email.hashCode}', email: email, name: email.split('@').first);
  }

  @override
  Future<UserModel> registerWithEmail({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 1500));
    if (email.toLowerCase() == 'taken@example.com') {
      throw const AuthException('An account with this email already exists.');
    }
    return UserModel(id: 'u_${email.hashCode}', email: email, name: email.split('@').first);
  }
}