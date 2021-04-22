

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/Home.dart';
import 'package:unicalemployee/Login.dart';
import 'package:unicalemployee/Provider/EmailPasswordAuth.dart';
import 'package:unicalemployee/Provider/FirestoreOperations.dart';
import 'package:unicalemployee/Provider/reminderManager.dart';
import 'package:unicalemployee/utils.dart';
import 'Provider/googleSignin.dart';
import 'Provider/taskManager.dart';
import 'Register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:splashscreen/splashscreen.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<GoogleSigninAuth>(create: (_) => GoogleSigninAuth()),
        ChangeNotifierProvider<EmailPasswordAuth>(create: (_) => EmailPasswordAuth()),
        ChangeNotifierProvider<FireStoreOperations>(create: (_) => FireStoreOperations()),
        ChangeNotifierProvider<TaskManager>(create: (_) => TaskManager()),
        ChangeNotifierProvider<ReminderManager>(create: (_) => ReminderManager()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.grey,
          fontFamily: 'RobotoCondensed'
        ),
        home: splash()
      ),
    );
  }
}



class splash extends StatefulWidget {
  @override
  _splashState createState() => _splashState();
}

class _splashState extends State<splash> {

  @override
  void initState()  {
    ///Android Initializer---
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    /// IOS Initializer-------
    final IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
        onDidReceiveLocalNotification:
            (int id, String title, String body, String payload) async {});
    ///InitializationSettings
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS);

     flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification:
            (String payload) async {
              onSelectNotification(payload,context);
        //   if (payload != null) {
        //     //Here we can redirect to next page to show Aalrm or We can show Alaert View
        //     debugPrint("Notification Clicked ");
        //     debugPrint('notification payload: $payload');
        //   }
         }
        );
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 10,
      navigateAfterSeconds:  Home(),
      title:  Text(
        'Welcome In Twister',
        style:  TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      image:  Image.asset("images/Reminder.png",),
      photoSize: 100.0,
      backgroundColor: utils.splashBackgroundColor,
      loaderColor: Colors.red,
    );

  }
}


Future onSelectNotification(String payload,BuildContext context) async {
  showDialog(
    context: context,
    builder: (_) {
      return new AlertDialog(
        title: Text("PayLoad"),
        content: Text("Payload : $payload"),
      );
    },
  );
}


