////change this commited in Login Page
//
//import "package:flutter/material.dart";
//import 'package:hp_cdrs/app_screens/loginPage.dart';
//import 'package:hp_cdrs/app_screens/splashScreen.dart';
//import 'package:hp_cdrs/app_screens/homeScreen.dart';
//
//void main() =>  runApp(MyApp());
//
//class MyApp extends StatelessWidget {
//  var _splashShown = false;
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      title: "CDRS",
//      routes: <String,WidgetBuilder>{
//        "/HomeScreen":(BuildContext context)  =>  HomeScreen(),
//        "/LoginPage" :(BuildContext context)  =>  LoginPage(),
//      },
//      home: SplashScreen(),
//    );
//  }
//
//
//}

import 'package:flutter/material.dart';
import 'package:hp_cdrs/app_screens/social_autopsy/login.dart';
import 'package:hp_cdrs/app_screens/social_autopsy/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = User();
    return MaterialApp(
      home: SocialAutopsyLogin(user:user),
    );
  }
}
