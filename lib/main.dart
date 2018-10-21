import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:up4/home.dart';

import 'package:up4/onboarding/activities.dart';
import 'package:up4/onboarding/intro.dart';
import 'package:up4/services/userBloc.dart';
import 'package:up4/chat/chatsList.dart';
import 'package:up4/login.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintLayerBordersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserWidget(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: Colors.blue,
          textTheme: TextTheme(
            button: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        home: HomeScreen(),
        routes: <String, WidgetBuilder>{
          'login': (_) =>  Login(),
          'onBoarding': (_) => OnBoarding(),
          'activities': (_) => Activities(),
          'chats': (_) => ChatsList(),
        },
      ),
    );
  }
}
