import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unicalemployee/Model/reminderModel.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import '../Home.dart';

class ReminderManager  with ChangeNotifier {
  List<Reminder> reminderList = [];

  addReminder(Reminder reminder)
  {
    reminderList.add(reminder);
    notifyListeners();
  }

}


