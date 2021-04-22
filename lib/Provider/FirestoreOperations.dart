
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;


class FireStoreOperations with  ChangeNotifier{
  List<QueryDocumentSnapshot>  dataFromServer ;
  bool returnValue = false;
  bool loading = false;
  String profilePic;
  String  pics;




  //Uploading  EmployeeDetails to the Firebase Storage------------------------------------
  Future<bool> uploadFile(String name,String email,String empId,File userProfilePic) async {

    //Firstly Uploading Profile pic to Firebase Storage --------------------------------------------
    firebase_storage.Reference  storageReference = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('ProfilePhotos/${Path.basename(userProfilePic.path)}');

    firebase_storage.UploadTask uploadTask = storageReference.putFile(userProfilePic);

    await uploadTask.asStream();
    CircularProgressIndicator();
    await uploadTask.whenComplete(() => null);
    print('Profile Pic Uploaded Successfully');
    //Once Uploading Profile Pic Finished we are using path of Profile Pic and Adding other Details to the FireStore------------
    storageReference.getDownloadURL().then((fileURL) {

        print(fileURL.toString());
        profilePic = fileURL;
        loading = false ;
        CollectionReference colRef = FirebaseFirestore.instance.collection("EmployeeDetails");
        colRef.add(({
          'Name' : name,
          'Email' : email,
          'EmpID' : empId,
          'ProfilePic' : profilePic
        })).then((value) => {
          print("Employee Details Inserted Successfully"),
          returnValue = true
        }
        ).catchError((e)=>{
          print(e.runtimeType),
          returnValue = false

        });
    });
      return returnValue;
    }


  //Uploading  EmployeeDetails to the Firebase Storage------------------------------------
  Future<bool> chatRoomData(String timeStamp,String msg,File pic) async {

    //Firstly Uploading Profile pic to Firebase Storage --------------------------------------------
    if(pic !=null)
      {
        firebase_storage.Reference  storageReference = firebase_storage.FirebaseStorage.instance
            .ref()
            .child('chatMedia/${Path.basename(pic.path)}');
        firebase_storage.UploadTask  uploadTask = storageReference.putFile(pic);

        await uploadTask.asStream();
        CircularProgressIndicator();
        await uploadTask.whenComplete(() => null);
        print('Profile Pic Uploaded Successfully');

        storageReference.getDownloadURL().then((fileURL) {
          print(fileURL.toString());
          pics = fileURL;
          loading = false;
        });
      }


    //Once Uploading Profile Pic Finished we are using path of Profile Pic and Adding other Details to the FireStore------------
      CollectionReference colRef = FirebaseFirestore.instance.collection("ChatRoom");
      colRef.add(({
        'imageUrl' : pic !=null ? pics : "",
        'msg' : msg,
        'timeStamp' : timeStamp,

      })).then((value) => {
        print("Chat Details Inserted Successfully"),
        returnValue = true
      }
      ).catchError((e)=>{
        print(e.runtimeType),
        returnValue = false
      });

    return returnValue;
  }
  }

