import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; // para debugPrint

abstract class AuthService {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
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

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),            // <-- trim
        password: password.trim(),      // <-- trim
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGNIN ERROR code=${e.code} message=${e.message}');
      throw AuthException(_mapError(e.code), code: e.code); // <-- conserva code
    }
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),            // <-- trim
        password: password.trim(),      // <-- trim
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGNUP ERROR code=${e.code} message=${e.message}');
      throw AuthException(_mapError(e.code), code: e.code); // <-- conserva code
    }
  }

  @override
  Future<void> signOut() => _firebaseAuth.signOut();

  String _mapError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'That email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password too weak (min. 6 characters)';
      case 'user-not-found':
      case 'wrong-password':
        return 'Invalid credentials';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled in Firebase';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'network-request-failed':
        return 'Network error. Check your connection';
      default:
        return 'An error occurred, please try again';
    }
  }
}
