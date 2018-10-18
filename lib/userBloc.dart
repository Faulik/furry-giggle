import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:rxdart/rxdart.dart';

class UserData {
  String userId;
  String email;
  String name;
  String id;

  UserData({
    this.userId,
    this.email,
    this.name,
    this.id,
  });
}

class User {
  UserData profile;
  FirebaseUser auth;

  User({this.profile, this.auth});
}

class UserInheritedData extends InheritedWidget {
  final _UserWidgetState data;

  const UserInheritedData({
    Key key,
    @required this.data,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static UserInheritedData of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(UserInheritedData)
        as UserInheritedData;
  }

  @override
  bool updateShouldNotify(UserInheritedData old) {
    return true;
  }
}

class UserWidget extends StatefulWidget {
  UserWidget({
    Key key,
    this.child,
  }) : super(key: key);

  final Widget child;

  @override
  _UserWidgetState createState() => _UserWidgetState();

  static _UserWidgetState of(BuildContext context) {
    final widget = context.inheritFromWidgetOfExactType(UserInheritedData)
        as UserInheritedData;

    return widget.data;
  }
}

class _UserWidgetState extends State<UserWidget> {
  FirebaseAuth auth;

  PublishSubject<UserData> onUserUpdated;

  BehaviorSubject<UserData> userDataSubject;
  BehaviorSubject<FirebaseUser> authUserSubject;

  BehaviorSubject<User> userSubject;

  @override
  void initState() {
    onUserUpdated = PublishSubject<UserData>();

    userSubject = BehaviorSubject<User>();
    authUserSubject = BehaviorSubject<FirebaseUser>();
    userDataSubject = BehaviorSubject<UserData>(seedValue: null);

    Observable.combineLatest2(authUserSubject, userDataSubject,
        (a, b) => User(auth: a, profile: b)).listen(userSubject.add);

    onUserUpdated
        .withLatestFrom(userSubject, (a, b) => [a, b])
        .switchMap<UserData>(updateUser)
        .listen(userDataSubject.add);

    onUserUpdated.listen((v) => print('1$v'));
    authUserSubject.listen((v) => print('2$v'));
    userDataSubject.listen((v) => print('3$v'));
    userSubject.listen((v) => print('4$v'));

    _init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UserInheritedData(
      data: this,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    userDataSubject.close();
    authUserSubject.close();

    onUserUpdated.close();
    super.dispose();
  }

  Future<void> _init() async {
    final auth = FirebaseAuth.instance;
    final CollectionReference users = Firestore.instance.collection('users');

    final user = await auth.currentUser();

    authUserSubject.add(user);

    if (user == null) {
      return;
    }

    final handleGetDocument = (QuerySnapshot snapshot) {
      if (snapshot.documents.isEmpty) {
        return null;
      }
      return snapshot.documents.elementAt(0);
    };

    final DocumentSnapshot userDocument = await users
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .getDocuments()
        .then(handleGetDocument);

    if (userDocument != null) {
      userDataSubject.add(
        UserData(
          userId: user.uid,
          email: userDocument.data['email'],
          name: userDocument.data['name'],
          id: userDocument.documentID,
        ),
      );
    } else {
      userDataSubject.add(null);
    }
  }

  // TODO: Find how to handle List<dynamic> when you know structure
  static Stream<UserData> updateUser(args) async* {
    final UserData newUserData = args[0];
    final User user = args[1];
    final CollectionReference users = Firestore.instance.collection('users');

    if (user.profile?.id != null) {
      await users.document(user.profile.id).setData({
        'name': user.profile.name,
        'email': user.profile.email,
        'userId': user.auth.uid,
      });

      yield UserData(
        userId: user.auth.uid,
        email: user.profile.email,
        name: user.profile.name,
        id: user.profile.id,
      );
    } else {
      final DocumentReference userDocument = await users.add({
        'name': newUserData.name,
        'email': newUserData.email,
        'userId': user.auth.uid,
      });

      yield UserData(
        userId: user.auth.uid,
        email: newUserData.email,
        name: newUserData.name,
        id: userDocument.documentID,
      );
    }
  }
}
