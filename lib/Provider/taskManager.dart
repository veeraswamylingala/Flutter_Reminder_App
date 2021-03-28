import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import '../Home.dart';

class TaskManager  with ChangeNotifier{


List<Task> taskList = [];

bool twentyFourHoursFormat = false;


addTask(Task task)
{
  print("Add Task Function Called");
  taskList.add(task);
  notifyListeners();
}





}