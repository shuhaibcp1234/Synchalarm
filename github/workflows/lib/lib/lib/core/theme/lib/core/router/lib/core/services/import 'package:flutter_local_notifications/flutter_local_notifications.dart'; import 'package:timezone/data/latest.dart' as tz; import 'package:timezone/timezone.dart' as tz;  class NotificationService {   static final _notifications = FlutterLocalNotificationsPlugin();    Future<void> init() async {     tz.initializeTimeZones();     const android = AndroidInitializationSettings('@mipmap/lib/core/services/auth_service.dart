import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authServiceProvider = Provider((ref) => AuthService());
final userProvider = StreamProvider((ref) => FirebaseAuth.instance.authStateChanges());

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<void> signIn(String email, String pass) => 
    _auth.signInWithEmailAndPassword(email: email, password: pass);

  Future<void> register(String email, String pass) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
    await _db.collection('users').doc(cred.user!.uid).set({
      'email': email,
      'displayName': email.split('@')[0],
      'createdAt': FieldValue.serverTimestamp(),
      'isOnline': true,
    });
  }

  Future<void> signOut() => _auth.signOut();
}
