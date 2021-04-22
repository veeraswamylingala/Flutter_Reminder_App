import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unicalemployee/Home.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/Provider/EmailPasswordAuth.dart';
import 'Provider/googleSignin.dart';
import 'Register.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();

  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _otp = TextEditingController();

  final _formPageKey = GlobalKey<FormState>();
  final _pageKey = GlobalKey<ScaffoldState>();

  final _mobileFormKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool googleSignIn = false;
  bool isMobile = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Color(0xFFFDFDFE) ,
      key: _pageKey,
    //  appBar: AppBar(title: Text("Login"),centerTitle:true,automaticallyImplyLeading: false,backgroundColor:Colors.blue[500],),
      body:  SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height ,
        //  color:  Colors.pinkAccent,
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
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
                keyboardType: TextInputType.emailAddress,
                validator: (value){
                  return value.contains("@") ? null :  "Enter Proper Email";
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
                validator: (value){
                  return value.length >= 6 ? null :  "Password must be 6 Characters";
                },
                obscureText: true,
                controller: _password,
              ),

              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){

                },
                child: Container(
                  //color: Colors.blue,
                    alignment: Alignment.centerRight,
                    child: Text("Forgot Password ?  ")),
              ),

              SizedBox(height: 15,),
              Container(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: (){
                   login();
                  },
                  child: Text("Login",style:TextStyle(color: Colors.white)),color: Color(0xFFFD0001)
                ),
              ),

              isLoading ? Opacity(
                opacity: isLoading ? 1.0 : 0.5,
                child:Container(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // height: MediaQuery.of(context).size.height/2,
                  // width: MediaQuery.of(context).size.width,
                  child:  CircularProgressIndicator() ,
                ),
              ): SizedBox() ,

              Divider(height: 50,thickness: 1,),

              Container(
                width: double.infinity,
                child: RaisedButton(onPressed: (){

            Provider.of<GoogleSigninAuth>(context, listen: false).signInWithGoogle().then((value) =>
         print(value.user.email));

                  // Provider.of<GoogleSigninAuth>(context, listen: false).googleSignIn.signIn().then((value){
                  //   print(value.email);
                  //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Home(googleSignin: true,)), (route) => false);
                  // }).catchError((e){
                  //   print("Errorr--- $e");
                  //   _pageKey.currentState.showSnackBar(
                  //     SnackBar(content: Text("Error in Accessing G-Mail, Try Agian !"),backgroundColor: Colors.red,)
                  //   );
                  // });
                },
                  child: Text("Login with Gmail",style:TextStyle(color: Colors.white)),color:Color(0xFF002060)),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: double.infinity,
                child: RaisedButton(onPressed: (){
                  _modalBottomSheetMenu();
                },
                    child: Text("Login with OTP",style:TextStyle(color: Colors.white)),color:Color(0xFF002060)),
              ),

              SizedBox(height: 30,),
              Divider(thickness: 1,),

              Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: Row(mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   Text("Dont have a Account ?",style: TextStyle(color: Color(0xFF002060)),),
                   SizedBox(width: 10,),
                   GestureDetector(onTap: (){
                     Navigator.push(context ,MaterialPageRoute(builder: (context) => Register()));
                   }, child: Text("Register",style:TextStyle(color:Color(0xFFFD0001)))),
                  ],
                     ),
              )
            ],
          ),
        ),
        ),
      ),
    );
  }


   _modalBottomSheetMenu(){

    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30),bottom :Radius.circular(0))
        ),
      isScrollControlled: true ,
        context: context,
        builder: (builder){
          return  Container(
           // height: 250,
           child: Padding(
           padding: const EdgeInsets.all(8.0),
           child: new Column(
             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
             crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisSize: MainAxisSize.min,
             children: [
                Container(
                  //color :Colors.blue,
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                     icon: Icon(Icons.close_sharp),
                     color: Colors.indigo,
                     onPressed: (){
                       Navigator.pop(context);
                     },
                   ),
                ),

              Text("Enter Mobile Number :",style:TextStyle(fontSize: 22)),
               SizedBox(
                 height: 10,
               ),
               Form(
                 key: _mobileFormKey,
                 child: TextFormField(
                   decoration: InputDecoration(
                     // suffix: Container(
                     //   height: 20,
                     //     width: 20,
                     //     child: CircularProgressIndicator(strokeWidth: 1.5,)),
                     labelText: "Mobile Number",
                       hintText: "Enter MobileNumber",
                       border: OutlineInputBorder()
                    // border: Border.all(color:Colors.red)
                   ),

                   keyboardType: TextInputType.phone,
                   validator: (value){
                     return value.length == 10  ? null :  "Invalid PhoneNumber";
                   },
                   controller: _mobileNumber,
                   style: TextStyle(fontSize: 18),
                 ),
               ),
               SizedBox(
                 height: 10,
               ),
                 Padding(
                 padding: EdgeInsets.only(
                     bottom: MediaQuery.of(context).viewInsets.bottom),
                 child: Container(
                   width: double.infinity,
                   child: FlatButton(
                     onPressed: (){
                       if(_mobileFormKey.currentState.validate())
                         {
                           Navigator.pop(context);

                           Navigator.push(context, MaterialPageRoute(builder: (context) => otpVerifyPage(phone: "${_mobileNumber.text}")));
                       }
                     },
                     color: Colors.indigo,
                     child: Text("Send OTP",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),),
                   ),
                 ),
               ),
               SizedBox(
                 height: 10,
               ),
             ],
           ),
         ) );
        }
    );
  }


  //Sign in with Email and Password-------------------
  //Login with Email-------------------
  login() async {
    if(_formPageKey.currentState.validate())
      {
        setState(() {
          isLoading = true;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        var status = prefs.getBool('isLoggedIn') ?? false;
        print(status);

        Provider.of<EmailPasswordAuth>(context, listen: false).authFirebase.signInWithEmailAndPassword(email: _email.text, password: _password.text).then((value){
           if (value.user != null) {
            Navigator.push(context,MaterialPageRoute(builder: (context) => Home(googleSignin: false,)));
          }
        }).catchError((error){
          setState(() {
            isLoading = false;
          });
          _pageKey.currentState.showSnackBar(
              SnackBar(content: Text("Could not Login."+error.toString())));
        });
      }
  }
}


class otpVerifyPage extends StatefulWidget {
  final String phone;
  const otpVerifyPage({Key key, this.phone}) : super(key: key);
  @override
  _otpVerifyPageState createState() => _otpVerifyPageState();
}

class _otpVerifyPageState extends State<otpVerifyPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _verifyPhone();
  }

  _verifyPhone() async {

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+91${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async {

          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async {
            if (value.user != null) {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Home(googleSignin: false,)),
                      (route) => false);
            }
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print("Error--------- ${e.message}");
        },
        codeSent: (String verficationID, int resendToken) {
          setState(() {
            _verificationCode = verficationID;
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          setState(() {
            _verificationCode = verificationID;
          });
        },
        timeout: Duration(seconds: 120));
  }

  TextEditingController textEditingController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();

  String _verificationCode;
  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();
  final BoxDecoration pinPutDecoration = BoxDecoration(
    color: const Color.fromRGBO(43, 46, 66, 1),
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(
      color: const Color.fromRGBO(126, 203, 224, 1),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      appBar: AppBar(title: Text("Verify OTP"),),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.height,
          //color: Colors.greenAccent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text("Verify Your OTP",style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500),),
              SizedBox(
                height: 5,
              ),
              Text("Enter the Code that we Send to +91 8888998845",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w300),),

              SizedBox(
                height: 40,
              ),

                      Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: PinPut(
                      fieldsCount: 6,
                      textStyle: const TextStyle(fontSize: 25.0, color: Colors.white),
                      eachFieldWidth: 40.0,
                      eachFieldHeight: 55.0,
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: pinPutDecoration,
                      selectedFieldDecoration: pinPutDecoration,
                      followingFieldDecoration: pinPutDecoration,
                      pinAnimationType: PinAnimationType.fade,
                      onSubmit: (pin) async {
                      try {
                      await FirebaseAuth.instance
                          .signInWithCredential(PhoneAuthProvider.credential(
                      verificationId: _verificationCode, smsCode: pin))
                          .then((value) async {
                      if (value.user != null) {
                      Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                      (route) => false);
                      }
                      });
                      } catch (e) {
                      FocusScope.of(context).unfocus();
                      _scaffoldkey.currentState
                          .showSnackBar(SnackBar(content: Text('invalid OTP')));
                      }
                      },
                      ),
                      ),


              SizedBox(
                height: 40,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Did not Received the Code ?",style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(
                    width: 5,
                  ),
                  GestureDetector(onTap: (){

                  },
                      child: Text("Resend Code",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.redAccent),)),

                ],
              ),

              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  print("Verify Clicked");
                },
                child: Ink(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  color: Colors.indigo,
                  child: Center(child: Text("VERIFY ",style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.w500,letterSpacing: 2),)),
                ),
              )



            ],
          ),
        ),
      ),
    );
  }
}
