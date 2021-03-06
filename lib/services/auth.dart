import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final String uid;

  User({@required this.uid});
}

abstract class AuthBase {


  Stream<User> get onAuthStateChanged;

  Future<User> currentAuth();



  Future<void> signOut();
  Future<User> signInWithAnonymously();

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createWithEmailAndPassword(String email, String password);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(uid: user.uid);
  }

  @override
  Stream<User> get onAuthStateChanged {
    return _firebaseAuth.onAuthStateChanged
        .map((event) => _userFromFirebase(event));
    //Ham Map dung de convert gia tri fireBaseUse thanh User
  }

  @override
  Future<User> currentAuth() async {
    final user = await _firebaseAuth.currentUser();
    return _userFromFirebase(user);
  }

  @override
  Future<User> signInWithAnonymously() async {
    final authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(); //doi tuong kieu GoogleSignIn
    final googleAccount =
        await googleSignIn.signIn(); //ma cho phep dang ki tai khoan gg
    if (googleAccount != null) {
      print('try login');
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        final authResult = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.getCredential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        print(googleAuth.idToken);
        return _userFromFirebase(authResult.user);
      } else {
        print('Missing Google Auth Token');
        throw PlatformException(
          code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          message: 'Missing Google Auth Token',
        );
      }
    } else {
      print('ERROR_ABORTED_BY_USER');
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'ERROR_ABORTED_BY_USER',
      );
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookloginIn = FacebookLogin();
    final result =
        await facebookloginIn.logInWithReadPermissions(['public_profile']);
    if (result != null) {
      final authResult = await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.getCredential(
          accessToken: result.accessToken.token,
        ),
      );
      return _userFromFirebase(authResult.user);
    } else {
      throw PlatformException(
        code: 'ERROR_ABORTED_BY_USER',
        message: 'ERROR_ABORTED_BY_USER',
      );
    }
  }
  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async{
    final authResult = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    _userFromFirebase(authResult.user);
  }
  @override
  Future<User> createWithEmailAndPassword(String email, String password) async{
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    _userFromFirebase(authResult.user);
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await FacebookLogin().logOut();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
