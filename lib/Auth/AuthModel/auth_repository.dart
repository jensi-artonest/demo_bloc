import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> SignUp({required String name, required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password is weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account is already exists for Email.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> SignIn({required String name ,required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'User-not-found') {
        throw Exception('No user not fount that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('password is wrong.');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
  bool cheakUser(){
    var firebaseAuth = FirebaseAuth.instance;
    var user = firebaseAuth.currentUser;
    if(user!.uid !=null){
      return true;
    }else{
      return false;
    }
  }
}