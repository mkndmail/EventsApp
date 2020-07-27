import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_events_app/project_styles.dart';
import 'package:my_events_app/reusable_buttons.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String emailAddress;
  String password;
  bool _showProgressBar = false;
  final _auth = FirebaseAuth.instance;
  String dateText = 'Choose You date of Birth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: _showProgressBar,
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
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    emailAddress = value;
                  }
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                keyboardType: TextInputType.text,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    password = value;
                  }
                },
                decoration: kInputDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              FlatButton(
                  onPressed: () {
                    DatePicker.showDatePicker(context,
                        showTitleActions: true,
                        minTime: DateTime(1970, 1, 1),
                        maxTime: DateTime(2002, 7, 22), onChanged: (date) {
                      setState(() {
                        var myValue = date.millisecondsSinceEpoch;
                        final df = DateFormat('dd-MM-yyyy');
                        dateText = df.format(
                            DateTime.fromMillisecondsSinceEpoch(
                                myValue * 1000));
                        print(DateFormat.yMMM().format(date));
                      });
                    }, onConfirm: (date) {
                      print('confirm $date');
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Text(
                    dateText,
                    style: TextStyle(color: Colors.blue),
                  )),
              SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                buttonColor: Colors.blueAccent,
                buttonText: 'Register',
                onClick: () async {
                  setProgressBarState(showProgress: true);
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: emailAddress, password: password);
                    if (newUser != null) {
                      Navigator.pop(context);
                    }
                    setProgressBarState(showProgress: false);
                  } catch (e) {
                    print(e);
                    setProgressBarState(showProgress: false);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setProgressBarState({@required bool showProgress}) {
    setState(() {
      _showProgressBar = showProgress;
    });
  }
}
