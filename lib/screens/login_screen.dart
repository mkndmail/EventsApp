import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_events_app/project_styles.dart';
import 'package:my_events_app/reusable_buttons.dart';
import 'package:my_events_app/routes_constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String emailAddress;
  String password;
  FirebaseAuth _auth;
  bool _showProgress = false;
  final loginTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showProgress,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                controller: passwordTextController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  emailAddress = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter your username'),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                controller: loginTextController,
                onChanged: (value) {
                  password = value;
                },
                decoration:
                    kInputDecoration.copyWith(hintText: 'Enter password'),
              ),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.lightBlueAccent,
                buttonText: 'Log In',
                onClick: () async {
                  loginTextController.clear();
                  passwordTextController.clear();
                  try {
                    changeShowDialogState(showDialog: true);
                    var result = await _auth.signInWithEmailAndPassword(
                        email: emailAddress, password: password);
                    var tokenResult = await result.user.getIdToken();
                    print('Token : ${tokenResult.token}');
                    if (result != null) {
                      await Navigator.pushNamedAndRemoveUntil(context,
                          kAllEventsScreen, (Route<dynamic> route) => false,
                          arguments: emailAddress);
                    }
                    changeShowDialogState(showDialog: false);
                  } catch (exception) {
                    print(exception);
                    changeShowDialogState(showDialog: false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeShowDialogState({@required bool showDialog}) {
    setState(() {
      _showProgress = showDialog;
    });
  }
}
