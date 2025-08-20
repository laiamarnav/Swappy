import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_service.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  FirebaseAuthService({
    FirebaseAuth? auth,
    GoogleSignIn? googleSignIn,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _google = googleSignIn ?? GoogleSignIn();

  // ---- Auth state ----
  @override
  Stream<User?> authStateChanges() => _auth.authStateChanges();

  @override
  User? get currentUser => _auth.currentUser;

  // ---- Email/Password ----
  @override
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _wrapFirebase(() => _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _wrapFirebase(() => _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        ));
  }

  // ---- Google ----
  @override
  Future<UserCredential> signInWithGoogle() async {
    if (kIsWeb) {
      final provider = GoogleAuthProvider();
      provider.setCustomParameters({'prompt': 'select_account'});
      return _wrapFirebase(() => _auth.signInWithPopup(provider));
    } else {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        throw AuthException('Inicio de sesión cancelado por el usuario', code: 'aborted');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _wrapFirebase(() => _auth.signInWithCredential(credential));
    }
  }

  // ---- Password reset ----
  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _wrapFirebase(() => _auth.sendPasswordResetEmail(email: email.trim()));
  }

  // ---- Sign out (complete) ----
  @override
  Future<void> signOut() async {
    await _auth.signOut();
    if (!kIsWeb) {
      try { await _google.signOut(); } catch (_) {}
      try { await _google.disconnect(); } catch (_) {}
    }
  }

  // ---- Helpers ----
  Future<T> _wrapFirebase<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on FirebaseAuthException catch (e) {
      throw AuthException(_messageForCode(e.code), code: e.code);
    } catch (_) {
      throw AuthException('Ha ocurrido un error inesperado', code: 'unknown');
    }
  }

  String _messageForCode(String code) {
    switch (code) {
      case 'aborted':
        return 'Inicio de sesión cancelado';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Credenciales inválidas';
      case 'email-already-in-use':
        return 'Este email ya está registrado';
      case 'weak-password':
        return 'La contraseña es demasiado débil';
      case 'operation-not-allowed':
        return 'Método de inicio de sesión no habilitado';
      case 'too-many-requests':
        return 'Demasiados intentos. Inténtalo más tarde';
      case 'network-request-failed':
        return 'Error de red. Revisa tu conexión';
      case 'popup-closed-by-user':
        return 'Se cerró la ventana de Google';
      case 'unauthorized-domain':
        return 'Dominio no autorizado en Firebase (Web)';
      default:
        return 'Ha ocurrido un error inesperado';
    }
  }
}
