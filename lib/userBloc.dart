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
  BehaviorSubject<FirebaseUser> userSubject;

  @override
  void initState() {
    onUserUpdated = PublishSubject<UserData>();

    userSubject = BehaviorSubject<FirebaseUser>();
    userDataSubject = BehaviorSubject<UserData>();

    onUserUpdated
        .withLatestFrom(userSubject, (a, b) {
          return [a, b];
        })
        .withLatestFrom(userDataSubject, (a, c) {
          return [a[0], a[1], c];
        })
        .switchMap<UserData>(updateUser)
        .listen((UserData data) {
          print('kek');
          userDataSubject.add(data);
        });

    onUserUpdated.listen((v) => print('1$v'));
    userSubject.listen((v) => print('2$v'));
    userDataSubject.listen((v) => print('3$v'));
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
    userSubject.close();

    onUserUpdated.close();
    super.dispose();
  }

  Future<void> _init() async {
    final auth = FirebaseAuth.instance;
    final CollectionReference users = Firestore.instance.collection('users');

    final user = await auth.currentUser();

    userSubject.add(user);

    if (user == null) {
      return;
    }

    final handleGetDocument = (QuerySnapshot snapshot) {
      if (snapshot.documents.isEmpty) {
        return null;
      }
      snapshot.documents.elementAt(0);
    };

    final DocumentSnapshot userDocument = await users
        .where('userId', isEqualTo: user.uid)
        .limit(1)
        .getDocuments()
        .then(handleGetDocument);

    if (userDocument != null) {
      onUserUpdated.add(
        UserData(
          email: userDocument['email'],
          name: userDocument['name'],
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
    final FirebaseUser user = args[1];
    final UserData userData = args[2];
    final CollectionReference users = Firestore.instance.collection('users');

    if (userData.id.isNotEmpty) {
      await users.document(userData.id).setData({
        'name': userData.name,
        'email': userData.email,
        'userId': user.uid,
      });

      yield UserData(
        userId: user.uid,
        email: userData.email,
        name: userData.name,
        id: user.uid,
      );
    } else {
      final DocumentReference userDocument = await users.add({
        'name': newUserData.name,
        'email': newUserData.email,
        'userId': user.uid,
      });

      yield UserData(
        userId: user.uid,
        email: userData.email,
        name: userData.name,
        id: userDocument.documentID,
      );
    }
  }
}
