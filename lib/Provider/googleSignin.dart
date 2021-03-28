import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Home.dart';

class GoogleSigninAuth with  ChangeNotifier{

  GoogleSignIn googleSignIn = GoogleSignIn(scopes: ['email']);

  //SignIN Using Google GMail--------------------
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  googleLogin() async {
      await  googleSignIn.signIn().then((value){
        return value;
      }).catchError((error){
        return error;
      });

  }

  //Signout Using Google------------------------------
  googleSingout(){
    googleSignIn.signOut();
  }





}