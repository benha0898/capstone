import 'dart:ui';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/conversations/question_card_expanded.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final Conversation conversation;
  final User me;

  const ConversationScreen({Key key, this.conversation, this.me})
      : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseService db = DatabaseService();

  GeneratedDeck playingDeck;
  GeneratedQuestion latestQuestion;
  List<Map<String, String>> users;

  @override
  void initState() {
    super.initState();

    users = widget.conversation.users
        .where((element) => element["id"] != widget.me.id)
        .toList();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getData();
    // });
  }

  // getData() async {
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    print("Conversation Screen is built");
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: MyTheme.mainColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: MyTheme.whiteColor,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.more_horiz,
                color: MyTheme.whiteColor,
              ),
              onPressed: () {},
            ),
          ],
          title: Text(
            users.length > 1
                ? "${users.map((element) => element["firstName"]).join(', ')}"
                : "${users.map((element) => element["firstName"] + " " + element["lastName"]).join(', ')}",
          ),
          centerTitle: true,
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: StreamBuilder(
            // Fetch all questions
            stream: db.getQuestions(widget.conversation.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data.docs.length == 0)
                return Center(
                  child: RaisedButton(
                    onPressed: () => print("Start new conversation!"),
                    child: Text("Start new conversation"),
                  ),
                );
              AsyncSnapshot<dynamic> questionSnapshot = snapshot;
              latestQuestion = GeneratedQuestion.fromSnapshot(
                  questionSnapshot.data.docs.last);

              return StreamBuilder(
                // Fetch current deck playing
                stream: db.getPlayingDeck(widget.conversation.id),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  if (snapshot.data.docs.length == 0)
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: RaisedButton(
                        onPressed: () => print("Start new conversation!"),
                        child: Text("Start new conversation"),
                      ),
                    );

                  // Set up variables
                  playingDeck =
                      GeneratedDeck.fromSnapshot(snapshot.data.docs[0]);

                  return ListView.builder(
                    //reverse: true,
                    shrinkWrap: true,
                    itemCount: questionSnapshot.data.docs.length + 1,
                    addAutomaticKeepAlives: true,
                    itemBuilder: (context, index) {
                      // First, get Next Question button
                      if (index == questionSnapshot.data.docs.length) {
                        if (!latestQuestion.answered) return SizedBox();
                        return Stack(
                          children: [
                            Container(
                              width: size.width,
                              padding: EdgeInsets.all(50),
                              decoration: BoxDecoration(
                                color: playingDeck.color,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyTheme.darkColor.withOpacity(0.5),
                                    spreadRadius: 5.0,
                                    blurRadius: 7.0,
                                    offset: Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 10.0),
                                    child: Text(
                                      "Next Question",
                                      style: TextStyle(
                                        fontFamily: "DottiesChocolate",
                                        fontSize: 22.0,
                                        color: MyTheme.whiteColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${playingDeck.name}",
                                    style: TextStyle(
                                      color: MyTheme.whiteColor,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25.0)),
                                  onTap: () {
                                    print("Hello");
                                    _addQuestion(playingDeck);
                                  },
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      // Then, get all question containers
                      GeneratedQuestion question =
                          GeneratedQuestion.fromSnapshot(
                              questionSnapshot.data.docs[index]);
                      return Align(
                        alignment: Alignment.topCenter,
                        heightFactor: 0.8,
                        child: Hero(
                          tag: question.id,
                          child: Material(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: question.color,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(25.0),
                                        topRight: Radius.circular(25.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            MyTheme.darkColor.withOpacity(0.5),
                                        spreadRadius: 5.0,
                                        blurRadius: 7.0,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    title: Container(
                                      margin: EdgeInsets.only(bottom: 10.0),
                                      child: Text(
                                        question.text,
                                        style: TextStyle(
                                          fontFamily: "DottiesChocolate",
                                          fontSize: 22.0,
                                          color: MyTheme.whiteColor,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      // color: Colors.white,
                                    ),
                                    subtitle: _setSubtitle(question),
                                    trailing: Icon(
                                      Icons.keyboard_arrow_down_rounded,
                                      color: MyTheme.whiteColor,
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                      onTap: () {
                                        print("Question expand!");
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return QuestionCardExpanded(
                                                me: widget.me,
                                                question: question,
                                                conversation:
                                                    widget.conversation,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _setSubtitle(GeneratedQuestion question) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${question.number}/${question.totalQuestions} - ${question.deckName}",
          style: TextStyle(
            color: MyTheme.whiteColor,
            fontStyle: FontStyle.italic,
          ),
        ),
        SizedBox(height: 10.0),
        (question.answered)
            ? SizedBox(
                height: 20,
              )
            : Row(
                children: [
                  Text(
                    "${question.answers.length}/${widget.conversation.users.length} answered. ",
                    style: TextStyle(
                      color: MyTheme.whiteColor,
                    ),
                  ),
                  _answeredByMe(question)
                      ? Text(
                          "Waiting for others",
                          style: TextStyle(
                            color: MyTheme.whiteColor,
                          ),
                        )
                      : Text(
                          "Click here to answer",
                          style: TextStyle(
                              color: MyTheme.blueColor,
                              fontWeight: FontWeight.w700),
                        ),
                ],
              ),
      ],
    );
  }

  bool _answeredByMe(GeneratedQuestion question) {
    return question.answers
        .any((element) => element.sender["id"] == widget.me.id);
  }

  void _addQuestion(GeneratedDeck deck) {
    db.addQuestion(widget.conversation.id, deck).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return QuestionCardExpanded(
              me: widget.me,
              question: latestQuestion,
              conversation: widget.conversation,
            );
          },
        ),
      );
    });
  }
}
