import 'package:flutter/material.dart';
import 'package:up4/login.dart';
import 'package:up4/services/userBloc.dart';

class OnBoarding extends StatefulWidget {
  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  int currentSlide = 0;
  PageController controller;

  @override
  initState() {
    super.initState();

    controller = PageController(
      initialPage: currentSlide,
      keepPage: false,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget buildBody(BuildContext context, AsyncSnapshot<User> user) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40.0),
      child: FractionallySizedBox(
        widthFactor: 0.8,
        child: RaisedButton(
          padding: EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            if (currentSlide == 2) {
              if (user.data.auth == null) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Login(
                          backRoute: 'activities',
                        ),
                  ),
                );
              } else {
                Navigator.of(context).pushReplacementNamed('activities');
              }
            } else {
              controller.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          },
          child: Text(
            'Next',
            style: TextStyle(
              color: Theme.of(context).textTheme.button.color,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          buildSlider(),
          StreamBuilder(
            stream: UserWidget.of(context).userSubject,
            builder: buildBody,
          ),
        ],
      ),
    );
  }

  Expanded buildSlider() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            child: SizedBox(
              height: 300.0,
              child: PageView(
                onPageChanged: (value) {
                  setState(() {
                    currentSlide = value;
                  });
                },
                controller: controller,
                children: <Widget>[
                  buildSlide(
                    title: 'Tell us what you love doing',
                    icon: Icons.directions_bike,
                    subtitle: 'Hobbies, Drinking & Easing',
                  ),
                  buildSlide(
                    title: 'Group up with frieds',
                    icon: Icons.people,
                    subtitle: 'Select from your contacts',
                  ),
                  buildSlide(
                    title: 'Find other who likes the same',
                    icon: Icons.beach_access,
                    subtitle: 'Find and discover new frieds and activities',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildSlide({String title, IconData icon, String subtitle}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 10.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 24.0,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 30.0),
              child: Icon(
                icon,
                size: 120.0,
              ),
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
