import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

class utils{

  // DateTime now = DateTime.now();
  // String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

  //SplashScreen Background Color
  static  Color splashBackgroundColor  = Colors.orange.shade300 ;

  //Gradient Colors-----
  static List<Color> sky = [Color(0xFF6448FE), Color(0xFF5FC6FF)];
  static List<Color> sunset = [Color(0xFFFE6197), Color(0xFFFFB463)];
  static List<Color> sea = [Color(0xFF61A3FE), Color(0xFF63FFD5)];


  static List<Color> mango = [Color(0xFFFFA738), Color(0xFFFFE130)];
  static List<Color> fire = [Color(0xFFFF5DCD), Color(0xFFFF8484)];


  static List<Color> day = [Colors.blue.shade300,Colors.blue.shade100];


  bool taskCheckBox = false;

  var details = [{'TaskTitle':'tom','TaskDescription':'Description of Tom',"BeginTime":'2020-12-05 14:57','EndTime':'2020-12-05 14:57'},
    {'TaskTitle':'cat','TaskDescription':'Description of cat',"BeginTime":'2020-12-05 14:57','EndTime':'2020-12-05 14:57' }];


  TextStyle getProgressHeaderStyle() {
    return const TextStyle(
        color: Colors.black,
        fontFamily: 'Montserrat',
        fontWeight: FontWeight.w600,
        fontSize: 22.0,
        height: 0.5);
  }

  TextStyle getProgressBodyStyle() {
    return const TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        fontSize: 14,
        height: 0.5,
        fontWeight: FontWeight.w400);
  }

  TextStyle getProgressFooterStyle() {
    return const TextStyle(
        fontFamily: 'Montserrat',
        color: Colors.black,
        fontSize: 20,
        height: 0.5,
        fontWeight: FontWeight.w600);
  }

}