import 'package:firebase_auth/firebase_auth.dart';
abstract class AuthService {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> authStateChanges();
  User? get currentUser;
}

class AuthException implements Exception {
  final String code;     // <-- nuevo
  final String message;
  AuthException(this.message, {this.code = 'unknown'});

  @override
  String toString() => '$code: $message';
}

