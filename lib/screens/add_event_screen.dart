import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:my_events_app/firestore_keys_constant.dart';
import 'package:my_events_app/project_styles.dart';
import 'package:my_events_app/reusable_buttons.dart';

final _fireStore = Firestore.instance;

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

const _imageUrl = 'https://bit.ly/2WQzIo1';

class _AddEventScreenState extends State<AddEventScreen> {
  String eventName;
  String eventDescription;
  String dateText = 'Choose Event Date';
  String timeText = 'Choose Event Time';
  String numberOfUsers;
  bool _showProgressBar = false;
  String errorText = '';

  void _addEvent(
      BuildContext context,
      String eventName,
      String eventDescription,
      String numberOfUsers,
      String dateText,
      String timeText) async {
    var documentReference =
        await _fireStore.collection(kCollectionName).document();
    await documentReference.setData({
      kDateOfEvent: dateText,
      kTimeOfEvent: timeText,
      kDescription: eventDescription,
      kEventName: eventName,
      kImageURL: _imageUrl,
      kJoinEvent: false,
      kNumberOfUsers: numberOfUsers,
      kAddingTime: FieldValue.serverTimestamp(),
      kDocumentID: documentReference.documentID
    });
    setProgressBarState(showProgress: false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Add an Event'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: ModalProgressHUD(
        inAsyncCall: _showProgressBar,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          eventName = value;
                        }
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Event Name',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      minLines: 1,
                      maxLines: 4,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          eventDescription = value;
                        }
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Event Description',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: FlatButton(
                      onPressed: () async {
                        var chooseDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)));
                        setState(() {
                          dateText =
                              '${chooseDate.day}-${chooseDate.month}-${chooseDate.year}';
                        });
                      },
                      child: Text(
                        dateText,
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  Expanded(
                    child: FlatButton(
                        onPressed: () async {
                          var selectedTime = await showTimePicker(
                              context: context, initialTime: TimeOfDay.now());
                          setState(() {
                            timeText = selectedTime.format(context);
                          });
                        },
                        child: Text(
                          timeText,
                          style: TextStyle(color: Colors.blue),
                        )),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          numberOfUsers = value;
                        }
                      },
                      decoration: kInputDecoration.copyWith(
                        hintText: 'Number of users',
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: Text(
                      errorText,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Expanded(
                    child: RoundedButton(
                      buttonColor: Colors.lightBlueAccent,
                      buttonText: 'Add Event',
                      onClick: () {
                        if (eventName.isNotEmpty &&
                            eventDescription.isNotEmpty &&
                            numberOfUsers.isNotEmpty &&
                            dateText.isNotEmpty &&
                            timeText.isNotEmpty) {
                          setState(() {
                            errorText = '';
                          });
                          setProgressBarState(showProgress: true);
                          _addEvent(context, eventName, eventDescription,
                              numberOfUsers, dateText, timeText);
                        } else {
                          setState(() {
                            errorText = 'All fields are mandatory';
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
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
