import 'package:firebase_auth/firebase_auth.dart';

/// Authentication interface
abstract class AuthService {
  // Auth state
  Stream<User?> authStateChanges();
  User? get currentUser;

  // Email/Password
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);

  // Google
  Future<UserCredential> signInWithGoogle();

  // Password reset
  Future<void> sendPasswordResetEmail(String email);

  // Sign out
  Future<void> signOut();
}

/// Domain exception to surface friendly messages to the UI
class AuthException implements Exception {
  final String code;
  final String message;
  AuthException(this.message, {this.code = 'unknown'});
  @override
  String toString() => 'AuthException($code): $message';
}
