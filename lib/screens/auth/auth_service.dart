import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //signin method
  Future<UserCredential> login(String email, String password) async {
    var details = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return details;
  }
  //signup method

  //signout method
}
