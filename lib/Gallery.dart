import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';


class Gallery extends StatefulWidget {
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  List<QueryDocumentSnapshot>  dataFromServer ;
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gallery"),),
      body: Container(
        child:  StreamBuilder(
            stream: FirebaseFirestore.instance.collection("EmployeeDetails").snapshots(),
            builder: (context, snapshot) {

              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return Text('Error: ${snapshot.error}');
                  else
                    dataFromServer = snapshot.data.documents;
                  print("Successfully Getting Data from the Server");
                  print("Length of Collection ${dataFromServer.length}");
                  return  StaggeredGridView.countBuilder(
                    crossAxisCount: 4,
                    itemCount: dataFromServer.length,
                    itemBuilder: (BuildContext context, int index) =>
                        Container(
                          //  color: Colors.green,
                            child:  Image.network(dataFromServer[index]['ProfilePic'],fit: BoxFit.fitHeight)),
                    staggeredTileBuilder: (int index) =>
                        StaggeredTile.fit(2),
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  );
              }
            }
        )


      ),
    );
  }

  
}
