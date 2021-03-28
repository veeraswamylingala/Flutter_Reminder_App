import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:unicalemployee/Home.dart';
import 'package:unicalemployee/Login.dart';
import 'package:unicalemployee/Provider/EmailPasswordAuth.dart';
import 'package:unicalemployee/Provider/FirestoreOperations.dart';
import 'package:unicalemployee/Provider/reminderManager.dart';
import 'Provider/googleSignin.dart';
import 'Provider/taskManager.dart';
import 'Register.dart';
import 'package:firebase_core/firebase_core.dart';

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
        ),
        home: Login()
      ),
    );
  }
}
