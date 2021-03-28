import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'Login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  bool isLoading = false;

  final _authFirebase = FirebaseAuth.instance;
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _pageKey,
      // appBar: AppBar(title: Text("Register"),
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.blue[500],),
      body: isLoading ? Center(child: CircularProgressIndicator(),) : Container(
        width: double.infinity,
        margin: EdgeInsets.all(10),
        child: Form(
          key: _formPageKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                //  color: Colors.grey,
                height: 100,
                width: 220,
                child: Image.asset("images/unicalLOGO1.png"),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Enter Email",
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  return value.contains("@") ? null : "Enter Proper Email";
                },
                controller: _email,
              ),
              SizedBox(height: 15,),
              TextFormField(
                decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter Password",
                    border: OutlineInputBorder()
                ),
                validator: (value) {
                  return value.length >= 6
                      ? null
                      : "Password must be 6 Characters";
                },
                obscureText: true,
                controller: _password,
              ),

              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                child: RaisedButton(
                    onPressed: () {
                      register();
                    },
                    child: Text(
                        "Register", style: TextStyle(color: Colors.white)),
                    color: Color(0xFFFD0001)
                ),
              ),

              Divider(height: 50, thickness: 1,),
              Container(
                width: double.infinity,
                child: RaisedButton(onPressed: () {
                },
                  child: Text("Register with Gmail", style: TextStyle(color: Colors.white)),
                  color:  Color(0xFF002060),),
              ),
              SizedBox(height: 30,),
              Divider(thickness: 1,),

              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have a Account?",style: TextStyle(color: Color(0xFF002060)),),
                    SizedBox(width: 10,),
                    GestureDetector(onTap: (){
                      Navigator.push(context ,MaterialPageRoute(builder: (context) => Login()));
                    }, child: Text("Login",style:TextStyle(color:Color(0xFFFD0001)))),
                  ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }

  //Singup with Username and Password----------------------
  register() async {
    if (_formPageKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });
      await _authFirebase.createUserWithEmailAndPassword(
          email: _email.text, password: _password.text).then((value) {

            //Snackbar Code--------------------
        // _pageKey.currentState.showSnackBar(
        //     SnackBar(content: Text("Registered Successfully")));

        if (value.user != null) {

        Fluttertoast.showToast(
            msg: "Registration  Successfull",
            // toastLength: Toast.LENGTH_LONG,
            // gravity: ToastGravity.BOTTOM,
            // timeInSecForIosWeb: 1,
            // backgroundColor: Colors.green,
            // textColor: Colors.white,
            // fontSize: 16.0
        ).then((value) =>
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        ) );
      }}
      ).catchError((error) {
        setState(() => isLoading = false);
        print("Error" + error.toString());
        _pageKey.currentState.showSnackBar(
            SnackBar(content: Text("Could not register.")));
      });
    }
  }

}

