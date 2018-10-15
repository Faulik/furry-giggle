import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:up4/userBloc.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final FirebaseUser user = User().user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData _data;

  @override
  void initState() {
    super.initState();

    _init();
  }

  Future<void> _init() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Form(
        key: _formKey,
        child: Expanded(
          child: Center(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                    helperText: 'Your name',
                    labelText: 'Name',
                  ),
                  validator: (String value) {
                    if (value.length == 0) {
                      return 'Required';
                    }
                  },
                  onSaved: (String value) => this._data.name = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    helperText: 'Your email',
                    labelText: 'Email',
                  ),
                  validator: (String value) {
                    if (value.length == 0) {
                      return 'Required';
                    }
                  },
                  onSaved: (String value) => this._data.email = value,
                ),
                Container(
                  child: RaisedButton(
                    child: Text('Save'),
                    onPressed: handleSaveProfile,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void handleSaveProfile() {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      User().updateUser(
        email: this._data.email,
        name: this._data.name,
      );
    }
  }
}
