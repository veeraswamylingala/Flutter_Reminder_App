import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class EmailPasswordAuth with ChangeNotifier{

  final authFirebase = FirebaseAuth.instance;


  login(String email,String Password){
      authFirebase.signInWithEmailAndPassword(email: email, password: Password).then((value){
        return value;
      }).catchError((error){
        return error;
      });
    }

  }