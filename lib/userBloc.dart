import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  static final User _singleton = new User._internal();
  final CollectionReference users = Firestore.instance.collection('users');

  UserData userData;
  FirebaseUser user;
  FirebaseAuth auth;

  factory User() {
    return _singleton;
  }

  Future<void> _init() async {
    auth = FirebaseAuth.instance;

    user = await auth.currentUser();
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
      setUser(
        email: userDocument['email'],
        name: userDocument['name'],
        id: userDocument.documentID,
      );
    }
  }

  setUser({String email, String name, String id}) {
    userData = UserData(
      userId: user.uid,
      email: email,
      name: name,
      id: id,
    );
  }

  Future<void> updateUser({String name, String email}) async {
    if (userData != null) {
      final DocumentReference userDocument = await users.add({
        'name': name,
        'email': email,
        'userId': user.uid,
      });

      setUser(
        email: email,
        name: name,
        id: userDocument.documentID,
      );
      return;
    }

    await users.document(userData.id).setData({
      'name': name,
      'email': email,
      'userId': user.uid,
    });

    setUser(
      email: email,
      name: name,
      id: userData.id,
    );
  }

  User._internal() {
    _init();
  }
}
