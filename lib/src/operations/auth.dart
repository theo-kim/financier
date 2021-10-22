import 'package:financier/src/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthAction {
  bool loggedin = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool isLoggedIn() {
    return loggedin;
  }

  Future<User?> signIn(UserCredential credential) async {
    loggedin = true;
    return credential.user;
  }

  Future<User?> signInWithGoogle() async {
    GoogleSignInAccount googleSignInAccount;
    var account = await _googleSignIn.signIn();
    if (account != null) {
      googleSignInAccount = account;
    } else {
      throw "Login cancelled";
    }

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    return signIn(await _auth.signInWithCredential(credential));
  }
}
