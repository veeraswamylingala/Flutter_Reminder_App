import 'dart:io';
import 'package:custom_switch/custom_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/AddReminder.dart';
import 'package:unicalemployee/ChatScreen.dart';
import 'package:unicalemployee/EmployeeList.dart';
import 'package:unicalemployee/Gallery.dart';
import 'package:unicalemployee/Model/reminderModel.dart';
import 'package:unicalemployee/Provider/EmailPasswordAuth.dart';
import 'package:unicalemployee/Provider/reminderManager.dart';
import 'package:unicalemployee/RegisterNewEmploye.dart';
import 'AddTask.dart';
import 'Database_Helper/database_class.dart';
import 'Login.dart';
import 'Model/taskModel.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'Provider/googleSignin.dart';
import 'Provider/taskManager.dart';
import 'main.dart';
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

  final dbHelper = DatabaseHelper.instance;
  @override
  Future<void> initState()  {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
    // reference to our single class that manages the database
    Provider.of<ReminderManager>(context, listen: false).query();
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
                   // IconButton(icon: Icon(Icons.notifications,color: Colors.grey,size: 30,), onPressed: (){}),
                 ],
               )
             ],
           ),
            SizedBox(height: 20,),
            Divider(),
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
            Divider(),
            SizedBox(height: 0,),
            //Third Row---------------------------------------------------------
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("\u0024 12,939.25",style: utils().getProgressHeaderStyle(),),
            //         SizedBox(height: 12,),
            //         Text("Checking Account Balance",style: utils().getProgressBodyStyle(),),
            //       ],
            //     ),
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: [
            //         Text("\u0024 120,939.25",style: utils().getProgressHeaderStyle(),),
            //         SizedBox(height: 12,),
            //         Text("Saving Account Balance",style: utils().getProgressBodyStyle(),),
            //       ],
            //     ),
            //   ],
            // ),
            //SizedBox(height: 35,),
            Consumer<TaskManager>(
              builder: (context,myTasks,child) =>
        Container(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
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
          Container(
            height: 200,
            decoration: BoxDecoration(
                color: Colors.orangeAccent,
              image: DecorationImage(
                image: AssetImage("images/HappyBunchDesk.png"),
                fit: BoxFit.fitHeight,
                alignment: Alignment.bottomCenter,
              ),),)
         
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Reminder",style: utils().getProgressFooterStyle()),
        centerTitle: false,
        actions: [
        ],
      ),
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor:Colors.orange.shade400,
        child: IconButton(icon: Icon(Icons.add,size: 30,color: Colors.white,),onPressed: (){
         // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen()));
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddReminder()));
        },),
      ),
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Consumer<ReminderManager>(
            builder: (context,myReminderList,child) {
              return myReminderList.reminderList.length > 0  ? ListView.builder(
                  itemCount: myReminderList.reminderList.length,
                  itemBuilder: (BuildContext context, int index) {

                    var tempDateTime   =  DateFormat('yyyy-MM-dd – hh:mm:ss').parse(myReminderList.reminderList[index].reminderTime);

                    var tempStringDateTime = DateFormat('hh:mm: a').format(tempDateTime);

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
                          trailing:IconButton(icon: Icon(Icons.delete),onPressed: (){
                            Provider.of<ReminderManager>(context,listen: false).deleterSingleReminder(index);
                          },),

                          // CustomSwitch(
                          //    activeColor: Colors.green,
                          //    value: status,
                          //    onChanged: (value) {
                          //      print("VALUE : $value");
                          //    //  setState(() {
                          //        status = value;
                          //      //});
                          //    },
                          //  ),

                            title: Text(tempStringDateTime),
                          subtitle: Text(myReminderList.reminderList[index].reminderLabel),
                      ),
                    ),);
                  }
              ) : Container(
                height: 400,
                width: 350,
                child:Image.asset("images/13269.jpg"),
              ) ;
            }
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


