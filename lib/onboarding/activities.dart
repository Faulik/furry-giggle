import 'package:flutter/material.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  int currentSlide = 0;
  PageController _pageController;


  @override
  initState() {
    super.initState();

    _pageController = PageController(
      initialPage: currentSlide,
      keepPage: false,
    );
  }

  @override
  dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget leadingButton() {
    if (currentSlide > 0) {
      return IconButton(
        icon: Icon(Icons.keyboard_arrow_left),
        onPressed: () {
          _pageController.previousPage(
              duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
        },
      );
    }
    return Container();
  }

  Widget nextButton() {
    if (currentSlide < 1) {
      return FlatButton(
        child: Text(
          'Next',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          _pageController.nextPage(
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      );
    }
    return Container(
      child: FlatButton(
        onPressed: () => Navigator.of(context).pushNamed('chats'),
        child: Text(
          'Done',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: leadingButton(),
        title: Text('Activities'),
        actions: <Widget>[nextButton()],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              onPageChanged: (value) {
                setState(() {
                  currentSlide = value;
                });
              },
              controller: _pageController,
              children: <Widget>[
                UserActivitiesPage(),
                UserActivitiesPage(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserActivitiesPage extends StatefulWidget {
  @override
  _UserActivitiesPageState createState() => _UserActivitiesPageState();
}

class _UserActivitiesPageState extends State<UserActivitiesPage> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
  }

  buildTitle({Widget child}) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 20.0,
      ),
      child: Column(
        children: <Widget>[
          Text(
            'What do you like doing with',
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          child,
        ],
      ),
    );
  }

  Widget buildIcon({IconData icon}) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Icon(
        icon,
        size: 50.0,
      ),
    );
  }

  Widget activitiesSlider() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: SizedBox(
        height: 60.0,
        child: ListView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            buildIcon(icon: Icons.beach_access),
            buildIcon(icon: Icons.directions_bike),
            buildIcon(icon: Icons.local_dining),
            buildIcon(icon: Icons.landscape),
            buildIcon(icon: Icons.free_breakfast),
          ],
        ),
      ),
    );
  }

  Widget buildSelectTitle({String text}) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(
          top: 40.0,
          bottom: 20.0,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }

  Widget buildSelectItem({String text, bool isSelected = false}) {
    final decoration = BoxDecoration(
      border: Border(
        top: BorderSide(
            color: Colors.grey, width: 1.0, style: BorderStyle.solid),
        bottom: BorderSide(
            color: Colors.grey, width: 1.0, style: BorderStyle.solid),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 3.0,
      ),
      decoration: isSelected ? decoration : null,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isSelected ? Colors.black : Colors.grey,
          fontSize: 20.0,
        ),
      ),
    );
  }

  Widget timeSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildSelectTitle(text: 'When is a good time to do it?'),
        buildSelectItem(text: 'Anytime', isSelected: true),
        buildSelectItem(text: 'Weekdays', isSelected: false),
        buildSelectItem(text: 'Custom', isSelected: false),
        buildSelectItem(text: 'Weekdays - Evening only', isSelected: false),
      ],
    );
  }

  Widget placeSelect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        buildSelectTitle(text: 'And where?'),
        buildSelectItem(text: 'Anywhere', isSelected: true),
        buildSelectItem(text: 'Near home & work'),
        buildSelectItem(text: 'Custom'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        buildTitle(
          child: Text(
            'FRIENDS?',
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.blue,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        activitiesSlider(),
        timeSelect(),
        placeSelect(),
      ],
    );
  }
}
