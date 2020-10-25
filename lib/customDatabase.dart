import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class CustomData extends StatefulWidget {
  CustomData({this.app});
  final FirebaseApp app;

  @override
  _CustomDataState createState() => _CustomDataState();
}

class _CustomDataState extends State<CustomData> {
  final referenceDatabase = FirebaseDatabase.instance;
  final questionName = 'Question';
  final questionController = TextEditingController();

  DatabaseReference _questionsRef;

  @override
  void initState() {
    final FirebaseDatabase database = FirebaseDatabase(app: widget.app);
    _questionsRef = database.reference().child('Questions');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ref = referenceDatabase.reference();
    return SingleChildScrollView(
      child: Column(
        children: [
          Center(
            child: Container(
              color: Colors.green,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  Text(
                    'List of Questions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: questionController,
                    textAlign: TextAlign.center,
                  ),
                  FlatButton(
                    color: Colors.grey,
                    onPressed: () {
                      ref
                          .child('Questions')
                          .push()
                          .child(questionName)
                          .set(questionController.text)
                          .asStream();
                      questionController.clear();
                    },
                    child: Text('Add Question'),
                    textColor: Colors.white,
                  ),
                  Flexible(
                    child: new FirebaseAnimatedList(
                        shrinkWrap: true,
                        query: _questionsRef,
                        itemBuilder: (BuildContext context,
                            DataSnapshot snapshot,
                            Animation<double> animation,
                            int index) {
                          return new ListTile(
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () =>
                                  _questionsRef.child(snapshot.key).remove(),
                            ),
                            title: new Text(snapshot.value[questionName]),
                          );
                        }),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
