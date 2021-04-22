import 'dart:async';
import 'package:custom_switch/custom_switch.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/Model/reminderModel.dart';
import 'package:unicalemployee/Provider/reminderManager.dart';
import 'package:unicalemployee/utils.dart';
import 'Model/taskModel.dart';
import 'Provider/taskManager.dart';

class AddReminder extends StatefulWidget {
  @override
  _AddReminderState createState() => _AddReminderState();
}

class _AddReminderState extends State<AddReminder>with TickerProviderStateMixin {

  bool status = false;

  TextEditingController reminderLabel = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  var formattedTime = DateFormat('hh:mm: a').format(DateTime.now());
  Timer timer;
  String label = "";

  String userSelectedTime ;

  @override
 void initState()  {
    this.timer = Timer.periodic(Duration(seconds: 1), (timer) {
      var perviousMinute = DateTime.now().add(Duration(seconds: -1)).minute;
      var currentMinute = DateTime.now().minute;
      if (perviousMinute != currentMinute)
        setState(() {
          formattedTime = DateFormat('hh:mm: a').format(DateTime.now());
        });
    });
    super.initState();
    print("Add Reminder Page---");

  }

  @override
  void dispose() {
    this.timer.cancel();
    super.dispose();
  }

  //Reminder Timer POPUP-----------------------------------------
  beginTimePopup() {
    return showDialog(
        context: context,
        builder: (context) {
          return   SizedBox(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                        elevation: 10.0,
                        child: Center(child: Text("Select-Time",style: TextStyle(fontWeight: FontWeight.w400,),))),
                  ),
                  Card(
                    elevation: 10.0,
                    child: SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          // minimumDate: today,
                          // minuteInterval: 1,
                          use24hFormat: false,
                          mode: CupertinoDatePickerMode.time,
                          onDateTimeChanged: (DateTime dateTime) {
                            print(dateTime);
                            timer.cancel();
                            formattedTime  =  DateFormat('hh:mm: a').format(dateTime);
                            userSelectedTime =  DateFormat('yyyy-MM-dd – kk:mm:ss').format(dateTime);

                            print(formattedTime);
                          }
                      ),
                    ),
                  ),
                ],
              )
          );
        });
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                  //    key: _mobileFormKey,
                      child: TextFormField(
                        decoration: InputDecoration(
                          // suffix: Container(
                          //   height: 20,
                          //     width: 20,
                          //     child: CircularProgressIndicator(strokeWidth: 1.5,)),
                            labelText: "Label",
                            hintText: "Enter Label",
                            border: OutlineInputBorder()
                          // border: Border.all(color:Colors.red)
                        ),

                        keyboardType: TextInputType.text,
                        // validator: (value){
                        //   return value.length == 10  ? null :  "Invalid PhoneNumber";
                        // },
                      controller: reminderLabel,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(onPressed: (){

                          Navigator.pop(context);
                        }, icon: Icon(Icons.close)),
                        IconButton(onPressed: (){
                               // reminderLabel.text
                          print(reminderLabel.text);

                          setState(() {
                            label = reminderLabel.text;
                          });

                          Navigator.pop(context);
                        }, icon: Icon(Icons.done))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Container(
                        width: double.infinity,
                        child: FlatButton(
                          onPressed: (){

                            Navigator.pop(context);
                          },
                          color: Colors.indigo,
                          child: Text("Cancel",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),),
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:  SafeArea(
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height -30,
              child: Container(
                color: Colors.white,
                child :  Container(
                    child:Column(
                      children: [
                        Container(
                            color: Colors.orange.shade200,
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 0,horizontal: 10),
                            child:Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                                    child: Text("Add Reminder",style: utils().getProgressFooterStyle(),),
                                  ),
                                  IconButton(icon: Icon(Icons.close_outlined),onPressed: (){
                                    // beginTimeController.clear();
                                    // endTimeController.clear();
                                    Navigator.pop(context);
                                  },),
                                ],
                              ),
                            )
                        ),
                        Divider(height: 1,thickness: 1,),
                        SizedBox(height: 10,),
                        Expanded(child: Form(
                          key: _formKey,
                          child: Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              // color: Colors.green,
                              child: Column(
                                children: [

                                  Container(
                                    height: 200,
                                    child: GestureDetector(onTap: (){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      beginTimePopup();
                                    },
                                      child: Center(
                                        child: Container(
                                         child: Text(
                                           "$formattedTime",
                                           style: TextStyle(
                                             fontSize: 60,
                                             fontFamily: 'avenir',
                                             color: Theme.of(context).primaryColor,
                                           ),
                                         ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 10,),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),
                                  ListTile(
                                      leading: Text("Ringtone"),
                                      trailing: Icon(Icons.arrow_forward_ios_sharp)
                                  ),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),
                                  //Repeat ListTile-------------------------------
                                  ListTile(
                                      leading: Text("Repeat"),
                                      trailing:
                                      Icon(Icons.arrow_forward_ios_sharp)

                                  ),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),
                                  //End Time Popup----------------------------
                                  // //Vibration when Alarm Sounds----------------------------
                                  ListTile(
                                    leading: Text("Vibrate when alarm sounds"),
                                    trailing:CustomSwitch(
                                      activeColor: Colors.green,
                                      value: status,
                                      onChanged: (value) {
                                        print("VALUE : $value");
                                        //  setState(() {
                                        status = value;
                                        //});
                                      },
                                    ),
                                  ),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),
                                  //Delete after goes off-----------
                                  ListTile(
                                    leading: Text("Delete after goes off"),
                                    trailing: CustomSwitch(
                                      activeColor: Colors.green,
                                      value: status,
                                      onChanged: (value) {
                                        print("VALUE : $value");
                                        //  setState(() {
                                        status = value;
                                        //});
                                      },
                                    ),
                                  ),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),


                                 ListTile(
                                      onTap: (){
                                        _modalBottomSheetMenu();
                                      },
                                        leading: Text("Label"),
                                        trailing:Text(label,style: TextStyle(color: Theme.of(context).primaryColor)),

                                    ),
                                  Divider(height: 1,thickness: 1,),
                                  SizedBox(height: 10,),
                                ],
                              )
                          ),
                        )),

                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 7),
                          child: FlatButton(
                            onPressed: (){
                              if(_formKey.currentState.validate())
                              {
                                print(formattedTime);
                                print(userSelectedTime);
                                // DateTime dateTime = DateFormat('hh:mm: a').parse(formattedTime);
                                // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm:ss').format(dateTime);

                               // print("${dateTime.hour}, ${dateTime.minute} ,${dateTime.second}");
                                  Reminder tempReminder = Reminder(reminderLabel.text, userSelectedTime, 0);
                                  Provider.of<ReminderManager>(context,listen: false).addReminder(tempReminder, context);
                                  reminderLabel.clear();
                                  Navigator.pop(context);
                                  print(" SUCCESS");
                              }
                            },
                            color: Colors.blue.shade300,
                            child: Text("Add Reminder",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),),
                          ),
                        ),
                      ],
                    )
                ),
              ),
            ),
          ),
        ) );
  }
}





