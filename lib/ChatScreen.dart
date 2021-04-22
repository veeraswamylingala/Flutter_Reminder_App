import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'Provider/FirestoreOperations.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<QueryDocumentSnapshot> dataFromServer;

  TextEditingController msgTextField = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Unical Team"),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.more_vert),
              //FaIcon(FontAwesomeIcons.externalLinkAlt),
              onPressed: () {},
            )
          ],
        ),
        // bottomNavigationBar: bottomNavigationBar(context),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
            new Expanded(
              child: new Material(
                  color: Colors.grey.shade200,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("ChatRoom").orderBy('timeStamp',descending: false).snapshots(),
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

                            var list = dataFromServer.reversed.toList();
                            return dataFromServer.length != 0
                                ? ListView.builder(
                                    itemCount: dataFromServer.length,
                                    reverse: true,
                                    padding: new EdgeInsets.all(8.0),
                                    itemBuilder: (context, i) {
                                      return charBox(
                                          list[i]['msg'], list[i]['timeStamp']);
                                    },
                                  )
                                : SizedBox();
                        }
                      })),
            ),
            Divider(
              height: 1.0,
            ),
            Container(
              color: Colors.white,
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      // color: Colors.transparent,
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: TextField(
                        controller: msgTextField, //this is the TextField
                        decoration: InputDecoration(
                            hintText: "Type Your Message",
                            border: OutlineInputBorder()),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    decoration: BoxDecoration(
                      //color: Colors.indigo,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        print("Send Clicked");
                        final formatter = new DateTime.now().millisecondsSinceEpoch;
                        Provider.of<FireStoreOperations>(context, listen: false)
                            .chatRoomData(formatter.toString(), msgTextField.text, null)
                            .then((value) => {
                                  if (value = true)
                                    {
                                      setState(() {}),
                                      print("Stored Successfull"),
                                      msgTextField.clear(),
                                    }
                                  else
                                    {
                                      setState(() {}),
                                    }
                                });
                      },
                    ),
                  )
                ],
              ),
            )
          ]),
        ));
  }
}

Widget charBox(String msg, String datetime) {
  return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  //for left corner
                  Image.asset(
                    'assets/images/in.png',
                    fit: BoxFit.scaleDown,
                    width: 30.0,
                    height: 30.0,
                  ),

                  Container(
                    margin: EdgeInsets.only(left: 6.0),
                    decoration: BoxDecoration(
                      color: Color(0xffd6d6d6),
                      border: Border.all(
                          color: Color(0xffd6d6d6),
                          width: .25,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5.0),
                        topLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(0.0),
                        bottomLeft: Radius.circular(0.0),
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      msg,
                      style: new TextStyle(
                        fontFamily: 'Gamja Flower',
                        fontSize: 20.0,
                        color: Color(0xff000000),
                      ),
                    ),
                    width: 180.0,
                  ),
                ],
              ),
              //date time
              // Container(
              //   margin: EdgeInsets.only(left: 6.0),
              //   decoration: BoxDecoration(
              //     color: Color(0xffd6d6d6),
              //     border: Border.all(
              //         color: Color(0xffd6d6d6),
              //         width: .25,
              //         style: BorderStyle.solid),
              //     borderRadius: BorderRadius.only(
              //       topRight: Radius.circular(0.0),
              //       topLeft: Radius.circular(0.0),
              //       bottomRight: Radius.circular(5.0),
              //       bottomLeft: Radius.circular(5.0),
              //     ),
              //   ),
              //   alignment: Alignment.bottomLeft,
              //   padding: const EdgeInsets.only(
              //       top: 0.0, bottom: 8.0, left: 8.0, right: 8.0),
              //   child: Text(
              //     startTime.toString(),
              //     style: new TextStyle(
              //       fontSize: 8.0,
              //       color: Color(0xff000000),
              //     ),
              //   ),
              //   width: 180.0,
              // ),
            ],
          ),
        ],
      ));
}
