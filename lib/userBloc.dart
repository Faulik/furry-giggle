import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  FirebaseAuth auth;

  final Sink<UserData> onUserUpdated;

  final BehaviorSubject<UserData> userDataSubject;
  final BehaviorSubject<FirebaseUser> userSubject;

  factory User() {
    final onUserUpdated = PublishSubject<UserData>();

    final userSubject = BehaviorSubject<FirebaseUser>();
    final userDataSubject = BehaviorSubject<UserData>();

    onUserUpdated
        .withLatestFrom(userSubject, (a, b) => [a, b])
        .withLatestFrom(userDataSubject, (a, b) => [a[0], a[1], b])
        .switchMap<UserData>(updateUser)
        .listen(userDataSubject.add);

    return User._internal(onUserUpdated, userSubject, userDataSubject);
  }

  void dispose() {
    onUserUpdated.close();
  }

  User._internal(this.onUserUpdated,
      this.userSubject,
      this.userDataSubject,) {
    _init();
  }

  Future<void> _init() async {
    auth = FirebaseAuth.instance;

    final user = await auth.currentUser();

    userSubject.add(user);


//    if (user == null) {
//      return;
//    }

//    final handleGetDocument = (QuerySnapshot snapshot) {
//      if (snapshot.documents.isEmpty) {
//        return null;
//      }
//      snapshot.documents.elementAt(0);
//    };
//
//    final DocumentSnapshot userDocument = await users
//        .where('userId', isEqualTo: user.uid)
//        .limit(1)
//        .getDocuments()
//        .then(handleGetDocument);
//
//    if (userDocument != null) {
//      onUserUpdated.add(
//        UserData(
//          email: userDocument['email'],
//          name: userDocument['name'],
//          id: userDocument.documentID,
//        ),
//      );
//    }
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
