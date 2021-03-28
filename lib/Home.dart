import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/ChatScreen.dart';
import 'package:unicalemployee/EmployeeList.dart';
import 'package:unicalemployee/Gallery.dart';
import 'package:unicalemployee/Model/reminderModel.dart';
import 'package:unicalemployee/Provider/EmailPasswordAuth.dart';
import 'package:unicalemployee/Provider/reminderManager.dart';
import 'package:unicalemployee/RegisterNewEmploye.dart';
import 'AddTask.dart';
import 'Login.dart';
import 'Model/taskModel.dart';
import 'Provider/googleSignin.dart';
import 'Provider/taskManager.dart';
import 'utils.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  final bool googleSignin ;
  const Home({Key key, this.googleSignin = false}) : super(key: key);
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _pageIndex = 0;
  PageController _pageController;

  List<Widget> tabPages = [
    Screen1(),
    Screen2(),
    Screen3(),
    Screen4(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        exit(1);
      },
      child: Scaffold(
        // appBar: AppBar(title: Text("Home"),centerTitle: true, backgroundColor:Colors.white,actions: [
        //   IconButton(icon :Icon(Icons.logout),color: Colors.black,onPressed: (){
        //     widget.googleSignin ?
        //     Provider.of<GoogleSigninAuth>(context, listen: false).googleSignIn.signOut() :
        //     Provider.of<EmailPasswordAuth>(context, listen: false).authFirebase.signOut();
        //     Provider.of<EmailPasswordAuth>(context, listen: false).authFirebase.signOut();
        //     Navigator.push(context,MaterialPageRoute(builder: (context) => Login()));
        //   },)
        // ],),
        // drawer: drawer(),
        // floatingActionButton: CircleAvatar(
        //   radius: 30,
        //   child: IconButton(icon: Icon(Icons.chat,size: 30,),onPressed: (){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
        //   },),
        // ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _pageIndex,
          onTap: onTabTapped,
          backgroundColor: Colors.white,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem( icon: Icon(Icons.dashboard,color: Colors.grey,), title: Text("Dashboard",style: TextStyle(color: Colors.grey),)),
            BottomNavigationBarItem(icon: Icon(Icons.alarm,color: Colors.grey,), title: Text("Reminder",style: TextStyle(color: Colors.grey),)),
            BottomNavigationBarItem(icon: Icon(Icons.notifications_active,color: Colors.grey,), title: Text("Notifications",style: TextStyle(color: Colors.grey),)),
            BottomNavigationBarItem(icon: Icon(Icons.account_box,color: Colors.grey,), title: Text("My Profile",style: TextStyle(color: Colors.grey),)),
          ],
        ),
        body: PageView(
          children: tabPages,
          onPageChanged: onPageChanged,
          controller: _pageController,
        ),
      ),
      );
  }

  // Widget drawer(){
  //   return  Drawer(
  //     child: ListView(
  //       padding: EdgeInsets.zero,
  //       children: <Widget>[
  //         widget.googleSignin ?
  //         Consumer<GoogleSigninAuth>(
  //           builder:(context,myUser,child) =>DrawerHeader(
  //             child: UserAccountsDrawerHeader(accountName: Text(myUser.googleSignIn.currentUser.displayName),
  //               accountEmail: Text(myUser.googleSignIn.currentUser.email),
  //               currentAccountPicture: Image.network(myUser.googleSignIn.currentUser.photoUrl),
  //             ),
  //         ) )
  //       :
  //         Consumer<EmailPasswordAuth>(
  //           builder:(context,myuser,child) =>DrawerHeader(
  //             child: UserAccountsDrawerHeader(accountName: Text(myuser.authFirebase.currentUser.displayName.toString()),
  //                 accountEmail: Text(myuser.authFirebase.currentUser.email.toString()),
  //                 currentAccountPicture: Image.network(myuser.authFirebase.currentUser.photoURL.toString()),
  //           ),
  //         ) ),
  //
  //
  //         ListTile(
  //           title: Text('Employes List'),
  //           leading: Icon( Icons.group),
  //           onTap: (){
  //             Navigator.pop(context);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => EmployeeList()));
  //           },
  //         ),
  //         Divider(),
  //         ListTile(
  //           title: Text('Register new Employee'),
  //           leading: Icon( Icons.category),
  //           onTap: (){
  //             Navigator.pop(context);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => RegisterEmploye()));
  //           },
  //         ),
  //         Divider(),
  //         ListTile(
  //           title: Text('About Unical'),
  //           leading: Icon( Icons.money),
  //           onTap: (){
  //             Navigator.pop(context);
  //             // Navigator.push(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => SubCategoryScreen(index: 1,slug: "",)));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Contact Details'),
  //           leading: Icon( Icons.money),
  //           onTap: (){
  //             Navigator.pop(context);
  //             // Navigator.push(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => SubCategoryScreen(index: 1,slug: "",)));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Gallary'),
  //           leading: Icon( Icons.money),
  //           onTap: (){
  //             Navigator.pop(context);
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(builder: (context) => Gallery()));
  //           },
  //         ),
  //         ListTile(
  //           title: Text('Careers'),
  //           leading: Icon( Icons.money),
  //           onTap: (){
  //             Navigator.pop(context);
  //             // Navigator.push(
  //             //     context,
  //             //     MaterialPageRoute(builder: (context) => SubCategoryScreen(index: 1,slug: "",)));
  //           },
  //         ),
  //         Divider(),
  //       ],
  //     ),
  //   );
  // }

  void onPageChanged(int page) {
    setState(() {
      this._pageIndex = page;
    });
  }

  void onTabTapped(int index) {
    this._pageController.animateToPage(index,duration: const Duration(milliseconds: 500),curve: Curves.easeInOut);
  }
}


//Screen1---------------------------------------------------------------------------------------------------
class Screen1 extends StatelessWidget {

 bool checkedValue = false;
 bool tap = false;
 var today= new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

 TextEditingController taskTitle = TextEditingController();
 TextEditingController taskDescription = TextEditingController();
 TextEditingController beginTimeController = TextEditingController();
 TextEditingController  endTimeController = TextEditingController();
 GlobalKey<FormState> _formKey = GlobalKey<FormState>();

 DateTime  beginTime ;
 DateTime endTime;

  @override
  Widget build(BuildContext context) {

    return SingleChildScrollView(
      child: Container(
        //height: MediaQuery.of(context).size.height -50,
        padding:EdgeInsets.fromLTRB(10, 50, 10, 0),

        child: Column(
          children: [
            //First Row---------------------------
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               CircleAvatar(
                 radius: 30.0,
                 backgroundImage:
                 NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
                 backgroundColor: Colors.transparent,
               ),
               Row(
                 children: [
                   IconButton(icon: Icon(Icons.search,color: Colors.grey,size: 30,), onPressed: (){}),
                   IconButton(icon: Icon(Icons.notifications,color: Colors.grey,size: 30,), onPressed: (){}),
                 ],
               )
             ],
           ),
            SizedBox(height: 20,),
            //Second Row---------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("HI Marcus,",style:utils().getProgressHeaderStyle()),
                    SizedBox(height: 12,),
                    Text("What do you want to do today?",style: utils().getProgressBodyStyle(),),
                  ],
                ),
                Container(
                  color: Colors.grey,
                    child: IconButton(icon: Icon(Icons.trending_down_sharp,size: 30,), onPressed: (){}))
              ],
            ),
            SizedBox(height: 35,),
            //Third Row---------------------------------------------------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\u0024 12,939.25",style: utils().getProgressHeaderStyle(),),
                    SizedBox(height: 12,),
                    Text("Checking Account Balance",style: utils().getProgressBodyStyle(),),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("\u0024 120,939.25",style: utils().getProgressHeaderStyle(),),
                    SizedBox(height: 12,),
                    Text("Saving Account Balance",style: utils().getProgressBodyStyle(),),
                  ],
                ),
              ],
            ),
            //SizedBox(height: 35,),
            Consumer<TaskManager>(
              builder: (context,myTasks,child) =>
        Container(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  children: List.generate(myTasks.taskList.length+1, (index) {
                    return index !=myTasks.taskList.length ?  GridTile(
                      child:  Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: utils.day ,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          )  ,
                          boxShadow: [
                            // BoxShadow(
                            //   color: utils.sea.last.withOpacity(0.4),
                            //   blurRadius: 8,
                            //   spreadRadius: 2,
                            //   offset: Offset(4, 4),
                            // ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(myTasks.taskList[index].taskTitle),
                            Divider(height: 12,),
                            Text(myTasks.taskList[index].taskDescription),
                            Divider(height: 12,),
                            Text(myTasks.taskList[index].beginTime.toString()),
                            Divider(height: 12,),
                            Text(myTasks.taskList[index].endTime.toString()),
                          ],
                      ),
                      )):  GridTile(
                      child: GestureDetector(
                        onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
                        },
                        child: Card(
                        color: Colors.orange.shade200,
                        child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                        IconButton(icon: Icon(Icons.add), onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
                        }),
                          Text("Create new Task")
                        ],
                        ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 20,),
          ],
        )
      ),
    );
  }
}



//Screen2--------------------------------------------------------------------------------------
class Screen2 extends StatelessWidget {

  var today= new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  String newReminderTime ;
  TextEditingController reminderLabel =  TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    //Bottom Sheet----------------------------------------------------------------------------
    modalBottomSheetMenu(){
      showModalBottomSheet(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(30),bottom :Radius.circular(0))
          ),
          isScrollControlled: true ,
          context: context,
          builder: (builder){
            return SafeArea(
              child: SingleChildScrollView(
                child: Container(
                   // height: MediaQuery.of(context).size.height-200,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 15),
                            color: Colors.blue.shade300,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [Text("Add Reminder",style: utils().getProgressFooterStyle()),
                                  IconButton(icon: Icon(Icons.close_outlined,size: 30,), onPressed: (){
                            Navigator.pop(context);
                          })
                                ],)),
                             StatefulBuilder(
                              builder: (BuildContext context, StateSetter stateSetter) {
                              return  SizedBox(
                            height: 200,
                            child: CupertinoDatePicker(
                                minimumDate: today,
                                minuteInterval: 1,
                                use24hFormat: false,
                                mode: CupertinoDatePickerMode.dateAndTime,
                                onDateTimeChanged: (DateTime dateTime) {
                                  String formattedDate = DateFormat('yyyy-MM-dd-h:mma').format(dateTime);
                                  stateSetter(() => newReminderTime = formattedDate);
                                  newReminderTime = formattedDate;
                                  //beginTimeController.text = formattedDate ;
                                }
                            ),
                          ); } ),
                          Container(
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 7),
                            child: TextFormField(
                               controller: reminderLabel,
                              decoration: InputDecoration(
                                  labelText: "Label",
                                  border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter Label";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontSize: 18),
                            ),
                          ), Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(10, 0, 10, 7),
                            child: FlatButton(
                              onPressed: (){
                                if(_formKey.currentState.validate())
                                {
                                  if(newReminderTime!=null)
                                  {
                                    DateTime  reminderTime =  DateFormat("yyyy-MM-dd-h:mma").parse(newReminderTime);

                                    Reminder newReminder =  Reminder(reminderLabel.text,reminderTime);
                                    Provider.of<ReminderManager>(context,listen: false).addReminder(newReminder);

                                    reminderLabel.clear();
                                    newReminder = null ;
                                    Navigator.pop(context);
                                    print(" SUCCESS");
                                  }else
                                  {
                                    print("Time Not Selected");
                                  }

                                }
                              },
                              color: Colors.blue.shade300,
                              child: Text("Save Reminder",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),),
                            ),
                          ),
                        ],
                      ),
                    )
                ),
              ),
            );
          } ); }

    return Scaffold(
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor:Colors.orange.shade400,
        child: IconButton(icon: Icon(Icons.add,size: 30,color: Colors.white,),onPressed: (){
         // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
          modalBottomSheetMenu();
        },),
      ),
      body: SafeArea(
        child: Container(
          child:Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                  height: 60,
                 // color: Colors.blue.shade300,
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  alignment: Alignment.centerLeft,
                  child: Text("Reminder",style: utils().getProgressFooterStyle())),
              Divider(height: 0,color: Colors.black,),
              SizedBox(height: 20,),
              Container(
                height: 400,
                child: Consumer<ReminderManager>(
                  builder: (context,myReminderList,child) {
                    return ListView.builder(
                        itemCount: myReminderList.reminderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            elevation: 5.0,
                            child: Container(
                              decoration: BoxDecoration(
                              gradient: LinearGradient(
                              colors: utils.day,
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                          )  ,
                          boxShadow: [
                          // BoxShadow(
                          // color: utils.fire.last.withOpacity(0.4),
                          // blurRadius: 8,
                          // spreadRadius: 2,
                          // offset: Offset(4, 4),
                          // ),
                          ],
                          borderRadius: BorderRadius.all(Radius.circular(5)),

                          ),
                              child: ListTile(
                                  leading: Icon(Icons.alarm),
                                 // CustomSwitch(
                                 //   activeColor: Colors.pinkAccent,
                                 //   value: status,
                                 //   onChanged: (value) {
                                 //     print("VALUE : $value");
                                 //     setState(() {
                                 //       status = value;
                                 //     });
                                 //   },
                                 // ),

                                  title: Text(myReminderList.reminderList[index].reminderTime.toString()),
                                subtitle: Text(myReminderList.reminderList[index].reminderLabel),
                            ),
                          ),);
                        }
                    );
                  }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//Screen3--------------------------------------------------------------------------------------
class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Container(
      color: Colors.white,
      child: Center(child: Text("Screen 3")),
    );
  }
}

//Screen4--------------------------------------------------------------------------------------
class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child:  Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: Padding(
            padding:  EdgeInsets.only(top: 30),
            child:  AppBar(
              backgroundColor:  Colors.blue.shade300,
              automaticallyImplyLeading: false,
              elevation: 0,
              flexibleSpace:  Column(
                children: [
                  Card(
                    child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        child:   Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage:
                              NetworkImage('https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixid=MXwxMjA3fDB8MHxzZWFyY2h8MXx8dXNlcnxlbnwwfHwwfA%3D%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=500&q=60'),
                              backgroundColor: Colors.transparent,
                            ),
                            SizedBox(height: 15,),
                            Text("HI Marcus,",style:utils().getProgressHeaderStyle()),
                          ],
                        )
                    ),
                  ),
                   SizedBox(height: 10,),
                  TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.white,
                      indicatorSize: TabBarIndicatorSize.label,
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10)),
                          color: Colors.white),
                      tabs: [
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("ALL"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("OPEN"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("CLOSED"),
                          ),
                        ),
                        Tab(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text("SETTINGS"),
                          ),
                        ),
                      ]
                  ),
                ],
              ),
            ),
          ),
        ),
     body: TabBarView(children: [
       Container(
         child: Column(
           children: [
             SizedBox(
               height: 20,
             ),
             Card(
               elevation: 3.0,
               borderOnForeground: true,
            //   color: Colors.blue.shade100,
               child: Container(
                 height: 80,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                         width:50,
                         child: Icon(Icons.done_outline,size: 40,color: Colors.green,)),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(utils().details[0]['TaskTitle']),
                         Text(utils().details[0]['TaskDescription']),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Text(utils().details[0]['BeginTime']),
                             Text("-"),
                             Text(utils().details[0]['BeginTime']),
                           ],)

                       ],
                     ),
                     Container(
                         width:50,
                         child: Icon(Icons.chevron_right_sharp)),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),


       Container(
         child: Column(
           children: [
             SizedBox(
               height: 20,
             ),
             Card(
               elevation: 3.0,
               borderOnForeground: true,
            //   color: Colors.blue.shade100,
               child: Container(
                 height: 80,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                       width:50,
                         child: Icon(Icons.done_outline,size: 40,color: Colors.green,)),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(utils().details[0]['TaskTitle']),
                         Text(utils().details[0]['TaskDescription']),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                           Text(utils().details[0]['BeginTime']),
                           Text("-"),
                           Text(utils().details[0]['BeginTime']),
                         ],)
                       ],
                     ),
                     Container(
                         width:50,
                         child: Icon(Icons.chevron_right_sharp)),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),
       Container(
         child: Column(
           children: [
             SizedBox(
               height: 20,
             ),
             Card(
               elevation: 3.0,
               borderOnForeground: true,
            //   color: Colors.blue.shade100,
               child: Container(
                 height: 80,
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceAround,
                   children: [
                     Container(
                         width:50,
                         child: Icon(Icons.close_outlined,size: 40,color: Colors.red,)),
                     Column(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         Text(utils().details[0]['TaskTitle']),
                         Text(utils().details[0]['TaskDescription']),
                         Row(
                           mainAxisAlignment: MainAxisAlignment.spaceAround,
                           children: [
                             Text(utils().details[0]['BeginTime']),
                             Text("-"),
                             Text(utils().details[0]['BeginTime']),
                           ],)
                       ],
                     ),
                     Container(
                         width:50,
                         child: Icon(Icons.chevron_right_sharp)),
                   ],
                 ),
               ),
             ),
           ],
         ),
       ),


       SingleChildScrollView(
         child: Container(
           child: Column(
             children: [
               SizedBox(
                 height:10,
               ),
               ListTile(
                 title: Text("Status Bar"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,),
               ListTile(
                 title: Text("Remove Ads"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,),
               ListTile(
                 title: Text("Time Format"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,),
               ListTile(
                 title: Text("Sort Order"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,),
               ListTile(
                 title: Text("Confirm Finishing Tasks"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,),
               ListTile(
                 title: Text("List to show at Startup"),
                 leading: Icon(Icons.edit_attributes_outlined),
               ),
               Divider(height: 10,color: Colors.grey,)
             ],
           ),
         ),
       )
        ]),
      ),
    );
  }
}


