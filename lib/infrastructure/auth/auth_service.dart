import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthException implements Exception {
  final String message;
  final String? code;
  AuthException(this.message, {this.code});

  @override
  String toString() => 'AuthException(code: ' + (code ?? 'unknown') + ', message: ' + message + ')';
}

abstract class AuthService {
  Future<UserCredential> signInWithEmail(String email, String password);
  Future<UserCredential> signUpWithEmail(String email, String password);
  Future<UserCredential> signInWithGoogle();
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> sendEmailVerification();
  Future<User?> reloadUser();
}

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _auth;
  final GoogleSignIn _google;

  FirebaseAuthService(this._auth, this._google);

  Future<T> _wrap<T>(Future<T> Function() fn) async {
    try {
      return await fn();
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Auth error', code: e.code);
    }
  }

  @override
  Future<UserCredential> signInWithEmail(String email, String password) {
    return _wrap(() => _auth.signInWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<UserCredential> signUpWithEmail(String email, String password) {
    return _wrap(() => _auth.createUserWithEmailAndPassword(email: email, password: password));
  }

  @override
  Future<UserCredential> signInWithGoogle() async {
    return _wrap(() async {
      final googleUser = await _google.signIn();
      if (googleUser == null) {
        throw AuthException('Sign in aborted', code: 'aborted');
      }
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    });
  }

  @override
  Future<void> signOut() {
    return _wrap(() async {
      await _google.signOut();
      await _auth.signOut();
    });
  }

  @override
  Future<void> sendPasswordResetEmail(String email) {
    return _wrap(() => _auth.sendPasswordResetEmail(email: email));
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user == null) {
      throw AuthException('No user', code: 'no-user');
    }
    await _wrap(() => user.sendEmailVerification());
  }

  @override
  Future<User?> reloadUser() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser;
  }
}
