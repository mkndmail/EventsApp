import 'package:flutter/material.dart';

import 'package:my_events_app/routes_constant.dart';
import 'package:my_events_app/screens/add_event_screen.dart';
import 'package:my_events_app/screens/all_events_screen.dart';
import 'package:my_events_app/screens/event_detail.dart';
import 'package:my_events_app/screens/sign_up.dart';

import 'screens/login_screen.dart';
import 'screens/welcome_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Events App',
      initialRoute: kHomepageScreen,
      debugShowCheckedModeBanner: false,
      routes: {
        kHomepageScreen: (context) => WelcomeScreen(),
        kLoginScreen: (context) => LoginScreen(),
        kSignUpScreen: (context) => SignUpPage(),
        kAllEventsScreen: (context) => AllEventsScreen(),
        kAddEventScreen: (context) => AddEventScreen(),
        EventDetail.routeName: (context) => EventDetail()
      },
    );
  }
}
