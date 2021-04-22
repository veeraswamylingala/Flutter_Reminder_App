import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/utils.dart';

import 'Model/taskModel.dart';
import 'Provider/taskManager.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  bool checkedValue = false;
  bool tap  = false;
  var today= new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  TextEditingController taskTitle = TextEditingController();
  TextEditingController taskDescription = TextEditingController();
  TextEditingController beginTimeController = TextEditingController();
  TextEditingController  endTimeController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  DateTime  beginTime ;
  DateTime endTime;

  //beginTimePopup-----------------------------------------
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
                        child: Center(child: Text("Begin-Time",style: TextStyle(fontWeight: FontWeight.w400,),))),
                  ),
                  Card(
                    elevation: 10.0,
                    child: SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          minimumDate: today,
                          minuteInterval: 1,
                          use24hFormat: false,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          onDateTimeChanged: (DateTime dateTime) {
                            String formattedDate = DateFormat('yyyy-MM-dd-h:mma').format(dateTime);
                            beginTimeController.text = formattedDate ;
                          }
                      ),
                    ),
                  ),
                ],
              )
          );
        });
  }

  //End Time Popup------------------------------
  endTimePopup1() {
    return showDialog(
        context: context,
        builder: (context) {
          return   SizedBox(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: Card(elevation: 10.0,
                        child: Center(child: Text("End-Time",style: TextStyle(fontWeight: FontWeight.w400),))),
                  ),
                  Card(
                    elevation: 10.0,
                    child: SizedBox(
                      height: 200,
                      child: CupertinoDatePicker(
                          minimumDate: today,
                          minuteInterval: 1,
                          use24hFormat: false,
                          mode: CupertinoDatePickerMode.dateAndTime,
                          onDateTimeChanged: (DateTime dateTime) {
                            String formattedDate = DateFormat('yyyy-MM-dd-h:mma').format(dateTime);
                            endTimeController.text = formattedDate ;
                          }
                      ),
                    ),
                  ),
                ],
              )
          );
        });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
    body:  SafeArea(
      child: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: MediaQuery.of(context).size.height,
        child: Container(
          color: Colors.white,
           child :  Container(
              height: MediaQuery.of(context).size.height-50,
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
                           child: Text("Add Task",style: utils().getProgressFooterStyle(),),
                         ),
                            IconButton(icon: Icon(Icons.close_outlined),onPressed: (){
                              beginTimeController.clear();
                              endTimeController.clear();
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
                            //Task Title-------
                            TextFormField(
                              controller: taskTitle,
                              decoration: InputDecoration(
                                  labelText: "Task Title",
                                  // hintText: "Task Title",
                                  border: OutlineInputBorder()
                              ),
                              keyboardType: TextInputType.name,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter TaskTitle";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10,),
                            //Task Description--------
                            TextFormField(
                              maxLines: 3,
                              controller: taskDescription,
                              decoration: InputDecoration(
                                  labelText: "Task Description",
                                  border: OutlineInputBorder()
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter TaskDescription";
                                } else {
                                  return null;
                                }
                              },
                              keyboardType: TextInputType.name,
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10,),
                            //BeginTime Textfield---------------
                            TextFormField(
                              onTap: (){
                                FocusScope.of(context).requestFocus(new FocusNode());
                                beginTimePopup();
                              },
                              controller: beginTimeController,
                              decoration: InputDecoration(
                                labelText: "Task Begin Time",
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(icon: Icon(Icons.calendar_today_rounded),onPressed: (){
                                  // showExitPopup();
                                },),
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please Enter TaskBeginTime";
                                } else {
                                  return null;
                                }
                              },
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10,),
                            //End Time Popup----------------------------
                            StatefulBuilder(
                                builder: (BuildContext context, StateSetter stateSetter) {
                                  return  TextFormField(
                                    onTap: (){
                                      FocusScope.of(context).requestFocus(new FocusNode());
                                      endTimePopup1();
                                    },
                                    controller: endTimeController,
                                    decoration: InputDecoration(
                                      labelText: "Task End Time",
                                      border: OutlineInputBorder(),
                                      suffixIcon:  IconButton(icon: Icon(Icons.calendar_today_rounded),onPressed: (){
                                        // showExitPopup();
                                      },),
                                    ),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Please Enter TaskEndTime";
                                      } else {
                                        return null;
                                      }
                                    },
                                    // keyboardType: TextInputType.name,
                                    style: TextStyle(fontSize: 18),
                                  ); } ),
                            SizedBox(height: 10,),
                          ],
                        )
                    ),
                  )),

                  StatefulBuilder(
                      builder: (BuildContext context, StateSetter stateSetter) {
                        return CheckboxListTile(
                          title: Text("Confirm Task ,this will add task to your Dashboard"),
                          value: checkedValue,
                          onChanged: (val) {
                            stateSetter(() => checkedValue = val);
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        );
                      }
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 7),
                    child: FlatButton(
                      onPressed: (){
                        if(_formKey.currentState.validate())
                        {
                          if(checkedValue == true)
                          {
                            DateTime  beginTime =  DateFormat("yyyy-MM-dd-h:mma").parse(beginTimeController.text);
                            DateTime  endTime =  DateFormat("yyyy-MM-dd-h:mma").parse(endTimeController.text);

                            Task tempTask =  Task(taskTitle.text,taskDescription.text,beginTime,endTime);
                            Provider.of<TaskManager>(context,listen: false).addTask(tempTask);

                            taskTitle.clear();
                            taskDescription.clear();
                            beginTimeController.clear();
                            endTimeController.clear();
                            checkedValue = false;
                            Navigator.pop(context);
                            print(" SUCCESS");
                            //
                            // Provider.of<TaskManager>(context).taskList.add(tempTask);
                          }else
                          {
                            print("PLZ Enable CheckBox");
                          }

                        }
                      },
                      color: Colors.blue.shade300,
                      child: Text("Save Task",style: TextStyle(color: Colors.white,fontWeight:FontWeight.bold,fontSize: 16),),
                    ),
                  ),
                ],
              )
           ),
        ),
      ),
    ) );
  }
}
