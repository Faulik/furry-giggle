import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _phoneFormKey = GlobalKey<FormState>();
  final _phoneCodeFormKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  String currentVerificationId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Phone Number'),
      ),
      body: Builder(builder: (BuildContext context) {
        return Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(30.0),
              child: currentVerificationId.isEmpty
                  ? buildPhoneInput(context)
                  : buildPhoneCodeInput(context),
            )
          ],
        );
      }),
    );
  }

  Widget buildPhoneInput(BuildContext context) {
    return Form(
      key: _phoneFormKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          Text(
            'Please confirm your country code and enter your phone number',
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Phone number',
            ),
            autovalidate: true,
            validator: (String value) {
              if (value.length < 13) {
                return 'Required';
              }

              return null;
            },
            onFieldSubmitted: (value) => handlePhoneSubmit(value, context),
            keyboardType: TextInputType.phone,
          )
        ],
      ),
    );
  }

  Widget buildPhoneCodeInput(BuildContext context) {
    return Form(
      key: _phoneCodeFormKey,
      autovalidate: true,
      child: Column(
        children: <Widget>[
          Text(
            'Please write code from sms',
          ),
          TextFormField(
            validator: (String value) {
              if (value.isEmpty) {
                return 'Required';
              }
            },
            onFieldSubmitted: (value) {
              handlePhoneCodeSubmit(value, context);
            },
            keyboardType: TextInputType.number,
          )
        ],
      ),
    );
  }

  Future<void> handlePhoneCodeSubmit(String value, BuildContext context) async {
    bool isValid = _phoneCodeFormKey.currentState.validate();

    if (isValid) {
      final FirebaseUser user = await auth.signInWithPhoneNumber(
        verificationId: currentVerificationId,
        smsCode: value,
      );

      if (user != null) {
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> handlePhoneSubmit(String value, BuildContext context) async {
    bool isValid = _phoneFormKey.currentState.validate();

    if (isValid) {
      final PhoneVerificationCompleted verificationCompleted =
          (FirebaseUser user) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Signed in with phone')));
        Navigator.of(context).pop();
      };

      final PhoneVerificationFailed verificationFailed =
          (AuthException authException) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text('Verification failed'),
            action: SnackBarAction(
              label: 'Try again',
              onPressed: () {
                setState(() {
                  currentVerificationId = '';
                });
              },
            ),
          ),
        );
      };

      final PhoneCodeSent codeSent =
          (String verificationId, [int forceResendingToken]) async {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Verification code sent')));

        setState(() {
          currentVerificationId = verificationId;
        });
      };

      final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
          (String verificationId) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Verification code timeout')));

        setState(() {
          currentVerificationId = verificationId;
        });
      };

      await auth.verifyPhoneNumber(
        phoneNumber: value,
        timeout: Duration(minutes: 1),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    }
  }
}
