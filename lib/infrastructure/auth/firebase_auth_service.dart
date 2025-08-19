import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthService(this._firebaseAuth, this._googleSignIn);

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGNIN ERROR code=${e.code} message=${e.message}');
      throw AuthException(_mapError(e.code), code: e.code);
    }
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } on FirebaseAuthException catch (e) {
      debugPrint('SIGNUP ERROR code=${e.code} message=${e.message}');
      throw AuthException(_mapError(e.code), code: e.code);
    }
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException('Sign in aborted by user', code: 'canceled');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      debugPrint('GOOGLE SIGNIN ERROR code=${e.code} message=${e.message}');
      throw AuthException(_mapError(e.code), code: e.code);
    }
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _firebaseAuth.signOut(),
      _googleSignIn.signOut(),
      _googleSignIn.disconnect(),
    ]);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      // Usa tu mapeo si lo tienes; aquí lanzamos un AuthException simple
      throw AuthException(
        e.message ?? 'Error al enviar el correo de recuperación',
        code: e.code,
      );
    } catch (_) {
      throw AuthException('Ha ocurrido un error inesperado', code: 'unknown');
    }
  }

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

