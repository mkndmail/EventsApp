import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_events_app/routes_constant.dart';

import '../reusable_buttons.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    logCurrentUser();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.png'),
                    height: 60.0,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  onTap: () {},
                  textStyle: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w900,
                  ),
                  text: ['My Events'],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              buttonColor: Colors.lightBlueAccent,
              buttonText: 'Log In',
              onClick: () {
                redirect(kLoginScreen);
              },
            ),
            RoundedButton(
              buttonColor: Colors.blueAccent,
              buttonText: 'Sign Up',
              onClick: () {
                redirect(kSignUpScreen);
              },
            ),
          ],
        ),
      ),
    );
  }

  void redirect(String routeName) {
    Navigator.pushNamed(context, routeName);
  }

  Future<bool> isLoggedIn() async {
    var user = await _firebaseAuth.currentUser();
    if (user != null) {
      return true;
    } else {
      return false;
    }
  }

  void logCurrentUser() async {
    var user = await _firebaseAuth.currentUser();
    if (user != null) {
      await Navigator.pushNamedAndRemoveUntil(
          context, kAllEventsScreen, (Route<dynamic> route) => false,
          arguments: user.email);
    }
  }
}
