import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'file:///E:/my_event_app/my_events_app/lib/screens/event_detail.dart';
import 'package:my_events_app/firestore_keys_constant.dart';
import 'package:my_events_app/routes_constant.dart';

FirebaseUser firebaseUser;
final _fireStore = Firestore.instance;

class AllEventsScreen extends StatefulWidget {
  @override
  _AllEventsScreenState createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _createAnEvent();
        },
        child: Icon(
          Icons.add,
          size: 30.0,
          color: Colors.white,
        ),
        tooltip: 'Create an event',
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: null,
        title: Text('All Events'),
        backgroundColor: Colors.lightBlueAccent,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Sign Out',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              _auth.signOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, kHomepageScreen, (Route<dynamic> route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              EventsStreamBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  void getCurrentUser() async {
    try {
      var user = await _auth.currentUser();
      if (user != null) {
        firebaseUser = user;
      } else {
        Navigator.pop(context);
      }
    } catch (exception) {
      print(exception);
    }
  }

  void _createAnEvent() {
    Navigator.pushNamed(context, kAddEventScreen);
  }
}

class EventsStreamBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.blueAccent,
            ),
          );
        }
        final eventsData = snapshot.data.documents.reversed;
        var events = <EventData>[];
        for (var message in eventsData) {
          final eventName = message.data[kEventName];
          final imageURL = message.data[kImageURL];
          final textWidget = EventData(
            eventName: eventName,
            imagePath: imageURL,
//            timestamp: DateTime.fromMicrosecondsSinceEpoch(messageTime.microsecondsSinceEpoch),
            data: message.data,
          );
          events.add(textWidget);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            children: events,
          ),
        );
      },
      stream: _fireStore
          .collection(kCollectionName)
          .orderBy(kAddingTime)
          .snapshots(),
    );
  }
}

class EventData extends StatelessWidget {
  final String eventName;
  final String imagePath;

//  final DateTime timestamp;

  final Map<String, dynamic> data;

  EventData({
    this.eventName,
    this.imagePath,
//    this.timestamp,
    this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),

      /*child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),*/
      child: Column(
        children: <Widget>[
          ListTile(
            trailing: Image.network(
              imagePath,
              width: 80.0,
              height: 80.0,
            ),
            title: Text(
              eventName,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.pushNamed(context, EventDetail.routeName,
                  arguments: data);
            },
          ),
          Divider(
            height: 1.0,
          )
        ],
      )
      /*GestureDetector(
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Text(
                    eventName,
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.normal),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: CircleAvatar(
                    child: Image.network(imagePath),
                    radius: 30,
                  ),
                )
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, kEventScreen, arguments: data);
            },
          )*/
      ,
      /*),*/
    );
  }
}
