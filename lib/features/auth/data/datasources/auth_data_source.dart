import 'package:firebase_auth/firebase_auth.dart';
import 'package:mpesa_finance_tracker/features/auth/domain/entities/auth_entity.dart';

abstract class AuthDataSource {
  Future<AuthEntity> signUp(String email, String password);
  Future<AuthEntity> signIn(String email, String password);
  Future<void> signOut();
  Stream<AuthEntity?> get authStateChanges;
}

class AuthDataSourceImpl implements AuthDataSource {
  final FirebaseAuth _firebaseAuth;

  AuthDataSourceImpl(this._firebaseAuth);

  @override
  Future<AuthEntity> signIn(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return AuthEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName);
  }

  @override
  Future<AuthEntity> signUp(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return AuthEntity(
        uid: userCredential.user!.uid,
        email: userCredential.user!.email,
        displayName: userCredential.user!.displayName);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Stream<AuthEntity?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) => user != null
        ? AuthEntity(
            uid: user.uid, email: user.email, displayName: user.displayName)
        : null);
  }
} 