import 'package:cloud_firestore/cloud_firestore.dart'; // Ensure this package is added to pubspec.yaml
import 'package:firebase_auth/firebase_auth.dart'; // Ensure this package is added to pubspec.yaml
import '../../domain/repositories/user_repository.dart'; // Ensure the relative path is correct

class UserRepositoryImpl implements UserRepository {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  UserRepositoryImpl(this.auth, this.firestore);

  @override
  Future<String> getUserName() async {
    User? user = auth.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc =
          await firestore.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        return userDoc['name'];
      }
    }
    return "";
  }

  @override
  Future<bool> signIn(String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> signUp(String email, String password) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      return true;
    } catch (e) {
      return false;
    }
  }
  @override
  Future<bool> signOut() async {
    try {
      await auth.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}


