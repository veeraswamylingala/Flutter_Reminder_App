import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as Path;
import 'package:provider/provider.dart';
import 'package:unicalemployee/EmployeeList.dart';
import 'package:unicalemployee/Provider/FirestoreOperations.dart';


class RegisterEmploye extends StatefulWidget {
  @override
  _RegisterEmployeState createState() => _RegisterEmployeState();
}

class _RegisterEmployeState extends State<RegisterEmploye> {


  bool isLoading = false;

  final _pageKey = GlobalKey<ScaffoldState>();

  final databaseReference = Firestore.instance;

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _empID = TextEditingController();

  final _formPageKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();


  Future getImagefromgallery() async {

    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 30);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future getImagefromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,imageQuality: 30);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        getImagefromgallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      getImagefromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _pageKey,
      appBar: AppBar(title: Text("Register Employee"),),
      body: SingleChildScrollView(
        child:  Container(
          height: MediaQuery.of(context).size.height -100,
          margin: EdgeInsets.all(10),
          child: isLoading ? Center(child: CircularProgressIndicator()) : Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Form(
                key: _formPageKey,
                child: Column(children: [
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: (){
                      print("Tapped on select Image");
                          _showPicker(context);


                    },
                    child: Card(
                      elevation: 10.0,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                        ),
                        child:  _image == null  ?  Image.network("https://icons.iconarchive.com/icons/papirus-team/papirus-apps/256/upload-pictures-icon.png",
                        )
                            : Image.file(_image,),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                        hintText: "Enter Employee Name",
                        labelText: "Name",
                      border: OutlineInputBorder()
                    ),
                    validator: (name){
              return name.length >= 3 ? null :  "Name must be 3 Characters";
              },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(
                      hintText: "Enter Employee Email ID",
                        labelText: "Email ID",
                        border: OutlineInputBorder()
                    ),
                    validator: (email){
                      return email.contains("@")  ? null :  "Enter Proper Email ID";
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _empID,
                    decoration: InputDecoration(
                        hintText: "Enter Employee ID",
                        labelText: "Employee ID",
                        border: OutlineInputBorder()
                    ),
                    validator: (empID){
                      return empID.length >= 3 ? null :  "EmpID must be 3 Characters";
                    },
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                      width:MediaQuery.of(context).size.width,
                      child: RaisedButton(
                    onPressed: (){
                      print("Clicked on Register Employee");
                      if(_formPageKey.currentState.validate())
                        {

                          setState(() {
                            isLoading = true;
                          });

                          print(_name.text);
                          print(_email.text);
                          print(_empID.text);
                          print(_image.path);

                          Provider.of<FireStoreOperations>(context, listen: false).uploadFile(_name.text, _email.text, _empID.text, _image).then((value) => {
                            if(value = true)
                              {
                              setState(() {
                            isLoading = false;
                            _image = null;
                          }),
                               print("Stored Successfull"),
                          _pageKey.currentState.showSnackBar(
                              SnackBar(content: Text("Registered Successfull"),backgroundColor: Colors.green,)),
                               _name.clear(),
                      _empID.clear(),
                      _email.clear(),
                                Navigator.push(context, MaterialPageRoute(builder: (context) => EmployeeList() ))

                        }else
                          {
                            setState(() {
                              isLoading = false;
                            }),
                                  _pageKey.currentState.showSnackBar(
                                      SnackBar(content: Text("Try Again"),backgroundColor: Colors.red,))

                                }
                          });

                        }
                    },
                    color: Color(0xFFFD0001),
                    child: Text("Register EMployee",style:TextStyle(color: Colors.white),),
                  )),
                ],
                ),
              )

            ],
          ),
        ),
      ),
    );
  }
}
