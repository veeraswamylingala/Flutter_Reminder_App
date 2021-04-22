import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:unicalemployee/Database_Helper/database_class.dart';
import 'package:unicalemployee/Model/reminderModel.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import 'package:unicalemployee/Model/taskModel.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import 'package:intl/intl.dart';


class ReminderManager  with ChangeNotifier {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  List<Reminder> reminderList =  [];

  static const MethodChannel platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

  //Insert  Reminde to ReminderList and Storing into Mysqflite Database------------------------------
  addReminder(Reminder reminder,BuildContext context)async
  {
    tz.initializeTimeZones();
    final String timeZoneName = await platform.invokeMethod<String>('getTimeZoneName');
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    reminderList.add(reminder);
    // row to insert--------------------------------
    Map<String, dynamic> row = {
      DatabaseHelper.reminderLabel : reminder.reminderLabel,
      DatabaseHelper.reminderTime  : reminder.reminderTime.toString()
    };

    print(row);
    //Inserting into Sqflite Reminder Table---------------------
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');

 await   _showNotification(context,reminder) ;
    notifyListeners();
  }


  //Fetching Reminder's List From Databse----------------
  void query() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    print(allRows);
    Reminder tempRow;
    DateTime tempDate ;
    //Fetching Data-------------------------------
    allRows.forEach((row) => {
      print(row),
   //  tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(row['Reminder_Time'],),
       tempRow = Reminder(row['Reminder_name'],row['Reminder_Time'],row['Reminder_id']),
      reminderList.add(tempRow)
    }
      );
    print(reminderList);
    notifyListeners();
  }


  //Deleting  Reinder ---------------------
  void deleterSingleReminder(int id) async
  {
    print("used Selected Reminder Id to Delete-$id");
    reminderList.removeAt(id);
    final allRows = await dbHelper.delete(id);
    notifyListeners();
    print("Removed Reminder from Databse and Local List ---- ");
  }


  //Scheduling Reminders Function---------------------
  Future<void> _showNotification(BuildContext context,Reminder reminder) async {

    print("Calling Reminder Scheduling");
    print("-------------------------------------------");
    print(reminder.reminderTime);

    var  tempDate = DateFormat('yyyy-MM-dd – hh:mm:ss').parse(reminder.reminderTime).toLocal();
    print(tempDate);

    //Converting UserSelected DateTime to tzDateTime.....
    var time1 = tz.TZDateTime.from(
      tempDate,
      tz.local,
    );

    //OnScreen Notification With Sound-------
   var androidPlatformChannelSpecifics = AndroidNotificationDetails(
       'full screen channel id',
       'full screen channel name',
       'full screen channel description',
        sound: RawResourceAndroidNotificationSound('aaabb'),
       playSound: true,
       priority: Priority.high,
       importance: Importance.max,
       //  icon: 'secondary_icon',
       enableLights: true,
       color: const Color.fromARGB(255, 255, 0, 0),
       ledColor: const Color.fromARGB(255, 255, 0, 0),
       ledOnMs: 1000,
       ledOffMs: 50,
       fullScreenIntent: true);
     var  iosPlatformChannelSpecifics = IOSNotificationDetails();


     await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Reminder',
        '${reminder.reminderLabel}-${reminder.reminderTime}',
      time1,
         NotificationDetails(android: androidPlatformChannelSpecifics,iOS: iosPlatformChannelSpecifics),
       androidAllowWhileIdle: true,
        payload: 'Custom_Sound',
         uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime
        );

    notifyListeners();
  }


}


