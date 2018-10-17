import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:up4/home.dart';

import 'package:up4/onboarding.dart';
import 'package:up4/login.dart';
import 'package:up4/chat/chatsList.dart';
import 'package:up4/userBloc.dart';

void main() {
//  debugPaintSizeEnabled = true;
//  debugPaintLayerBordersEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: find what was that thing about access to Navigator
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
          'login': (_) {
            return Login();
          },
          'onBoarding': (_) {
            return OnBoarding();
          },
          'chats': (_) {
            return ChatsList();
          },
        },
      ),
    );
  }
}
