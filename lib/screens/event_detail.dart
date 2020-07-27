import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_events_app/firestore_keys_constant.dart';
import 'package:my_events_app/reusable_buttons.dart';

Firestore _firestore = Firestore.instance;

class EventDetail extends StatefulWidget {
  static const routeName = '/extractArguments';

  @override
  _EventDetailState createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    bool eventJoined = args[kJoinEvent];
    return Scaffold(
      appBar: AppBar(
        title: Text(args[kEventName]),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(
                top: 60.0, bottom: 10.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10.0,
                ),
                Image.network(args[kImageURL]),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: <Widget>[
                  Text(
                    args[kEventName],
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Expanded(
                    child: Text(
                      args[kDescription],
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 16.0,
                          color: Colors.black54),
                    ),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    'Number of Users : ${args[kNumberOfUsers]}',
                    style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.black54,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  RoundedButton(
                    buttonText:
                        eventJoined == false ? 'Join Event' : 'Event Joined',
                    buttonColor: args[kJoinEvent] == false
                        ? Colors.lightBlueAccent
                        : Colors.grey,
                    onClick: args[kJoinEvent] == false
                        ? () {
                            print(args[kDocumentID]);
                            setState(() {
                              eventJoined = true;
                            });
                            _firestore
                                .collection(kCollectionName)
                                .document(args[kDocumentID])
                                .updateData({kJoinEvent: true});
                          }
                        : () {},
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
