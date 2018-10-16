import 'package:flutter/material.dart';

import 'package:up4/userBloc.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  UserData _data = UserData();

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
      body: Column(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.0,
                ),
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
                      keyboardType: TextInputType.emailAddress,
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
                        color: Theme.of(context).primaryColor,
                        child: Text('Save', style: TextStyle(color: Theme.of(context).textTheme.button.color),),
                        onPressed: () => handleSaveProfile(context),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleSaveProfile(BuildContext context) async {
    if (this._formKey.currentState.validate()) {
      _formKey.currentState.save();

      User().onUserUpdated.add(
        UserData(
          email: this._data.email,
          name: this._data.name,
        ),
      );

      Navigator.of(context).pop();
    }
  }
}
