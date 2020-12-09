import 'dart:ui';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/conversations/question_card_expanded.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  // final Conversation conversation;
  // final User me;

  // const ConversationScreen({Key key, this.conversation, this.me})
  //     : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseService db = DatabaseService();
  User me;
  Conversation conversation;
  Color accentColor;

  GeneratedDeck playingDeck;
  GeneratedQuestion latestQuestion;
  List<Map<String, String>> users;

  @override
  void initState() {
    super.initState();

    // users = widget.conversation.users
    //     .where((element) => element["id"] != widget.me.id)
    //     .toList();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getData();
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    conversation = arguments["conversation"];
    me = arguments["me"];
    users =
        conversation.users.where((element) => element["id"] != me.id).toList();
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
        body: StreamBuilder(
          // Fetch all questions
          stream: db.getQuestions(this.conversation.id),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            if (snapshot.data.documents.length == 0)
              return Center(
                child: RaisedButton(
                  onPressed: () {
                    print("Start new conversation!");
                    Navigator.pushNamed(context, 'select_deck', arguments: {
                      "me": this.me,
                      "conversation": this.conversation,
                    }).then((_) {
                      final result = ModalRoute.of(context).settings.arguments
                          as Map<String, dynamic>;
                      if (result != null && result['deck'] != null)
                        print("Returned deck: ${result['deck'].name}");
                      _startNewDeck(result['deck']);
                    });
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (_) => SelectDeckScreen(
                    //     me: this.me,
                    //     conversation: this.conversation,
                    //   ),
                    // ));
                  },
                  child: Text("Start new conversation"),
                ),
              );
            AsyncSnapshot<dynamic> questionSnapshot = snapshot;
            latestQuestion = GeneratedQuestion.fromSnapshot(
                questionSnapshot.data.documents.last);
            if (latestQuestion.color == MyTheme.yellowColor)
              accentColor = Color(0xFF094BF2).withOpacity(1);
            else if (latestQuestion.color == MyTheme.blueColor)
              accentColor = Color(0xFFAA6F49).withOpacity(1);
            else if (latestQuestion.color == MyTheme.redColor)
              accentColor = Color(0xFF72EBE4).withOpacity(1);
            else
              accentColor = MyTheme.darkColor;

            return StreamBuilder(
              // Fetch current deck playing
              stream: db.getPlayingDeck(this.conversation.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                if (snapshot.data.documents.length == 0)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: RaisedButton(
                      onPressed: () => print("Start new conversation!"),
                      child: Text("Start new conversation"),
                    ),
                  );

                // Set up variables
                playingDeck =
                    GeneratedDeck.fromSnapshot(snapshot.data.documents[0]);

                return ListView.builder(
                  //reverse: true,
                  shrinkWrap: true,
                  itemCount: questionSnapshot.data.documents.length + 1,
                  addAutomaticKeepAlives: true,
                  itemBuilder: (context, index) {
                    // First, get Next Question button
                    if (index == questionSnapshot.data.documents.length) {
                      if (!latestQuestion.answered) return SizedBox();
                      return Stack(
                        children: [
                          Container(
                            width: size.width,
                            padding: EdgeInsets.all(50),
                            decoration: BoxDecoration(
                              color: playingDeck.color,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(35.0)),
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
                                    BorderRadius.all(Radius.circular(35.0)),
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
                    GeneratedQuestion question = GeneratedQuestion.fromSnapshot(
                        questionSnapshot.data.documents[index]);
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
                                      topLeft: Radius.circular(35.0),
                                      topRight: Radius.circular(35.0)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: MyTheme.darkColor.withOpacity(0.5),
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
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(35.0),
                                        topRight: Radius.circular(35.0)),
                                    onTap: () {
                                      print("Question expand!");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return QuestionCardExpanded(
                                              me: this.me,
                                              question: question,
                                              conversation: this.conversation,
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
                    "${question.answers.length}/${this.conversation.users.length} answered. ",
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
                              color: accentColor, fontWeight: FontWeight.w700),
                        ),
                ],
              ),
      ],
    );
  }

  bool _answeredByMe(GeneratedQuestion question) {
    return question.answers
        .any((element) => element.sender["id"] == this.me.id);
  }

  void _addQuestion(GeneratedDeck deck) {
    db.addQuestion(this.conversation.id, deck).then((value) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return QuestionCardExpanded(
              me: this.me,
              question: latestQuestion,
              conversation: this.conversation,
            );
          },
        ),
      );
    });
  }

  void _startNewDeck(Deck deck) {
    db.addDeck(this.conversation.id, deck).then((value) {
      print("Returned value: $value");
      print("New playingDeck: ${this.playingDeck}");
      GeneratedDeck newDeck = GeneratedDeck.fromSnapshot(value);
      _addQuestion(newDeck);
    });
  }
}
