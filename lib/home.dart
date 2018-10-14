import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 20.0,
                    ),
                    child: Text(
                      'Up4',
                      style: TextStyle(
                        fontSize: 42.0,
                      ),
                    ),
                  ),
                  Text(
                    "The Social Network That's Actually Social",
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 40.0),
              child: FractionallySizedBox(
                widthFactor: 0.8,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    handlePressStart(context);
                  },
                  child: Text(
                    'Start',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.button.color,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> handlePressStart(BuildContext context) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user == null) {
      return Navigator.of(context).pushNamed('onBoarding');
    }
    Navigator.of(context).pushNamed('chats');
  }
}
