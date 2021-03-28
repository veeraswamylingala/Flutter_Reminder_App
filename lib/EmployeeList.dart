import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmployeeList extends StatefulWidget {
  @override
  _EmployeeListState createState() => _EmployeeListState();
}

class _EmployeeListState extends State<EmployeeList> {

  List<QueryDocumentSnapshot>  dataFromServer ;

  @override
  Future<void> initState()  {
    // TODO: implement initState
 //  getData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Employee List"),),
      body:   StreamBuilder(
    stream: Firestore.instance.collection("EmployeeDetails").snapshots(),
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
            return body();
      }
    }
      )
    );


  }
  Widget body(){
    return Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: dataFromServer.length,
        itemBuilder: (context,index){
          return  Column(children: [
        ListTile(
          title: Text(dataFromServer[index]['Name']),
          subtitle: Text(dataFromServer[index]['Email']),
          //  leading: Image.network("src"),
          trailing: Text(dataFromServer[index]['EmpID']),
          leading: CircleAvatar(child: Image.network(dataFromServer[index]['ProfilePic'])),

        ),
            Divider(
              height: 10,
              thickness: 1,
            ),
          ]);
        },
      ),
    );
  }

}
