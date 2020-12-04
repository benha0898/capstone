import 'dart:ui';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/conversations/question_container.dart';
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
  GeneratedQuestion updatedQuestion;
  bool questionAnswered;
  List<Map<String, String>> users;

  final ScrollController scrollController = ScrollController();

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
            stream: db.getQuestion(widget.conversation.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return CircularProgressIndicator();
              if (snapshot.data.docs.length == 0)
                return Center(child: Text("Start a conversation!"));
              return ListView.builder(
                controller: scrollController,
                itemCount: snapshot.data.docs.length + 1,
                reverse: true,
                addAutomaticKeepAlives: true,
                itemBuilder: (context, index) {
                  // First, get Next Question button
                  if (index == 0)
                    return StreamBuilder(
                      stream: db.getPlayingDeck(widget.conversation.id),
                      builder: (context, snapshot) {
                        // Still fetching decks
                        if (!snapshot.hasData)
                          return Center(child: Text("Fetching decks"));
                        // If there're no decks
                        if (snapshot.data.docs.length == 0)
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: RaisedButton(
                              onPressed: null,
                              child: Text("No deck playing"),
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.grey[50],
                            ),
                          );
                        // If there're decks
                        playingDeck =
                            GeneratedDeck.fromSnapshot(snapshot.data.docs[0]);
                        return StreamBuilder(
                          stream: db.questionAnswered(
                              widget.conversation.id, playingDeck.id),
                          builder: (context, snapshot) {
                            // Fetching latest question
                            if (!snapshot.hasData)
                              return Center(child: Text("Fetching questions"));
                            // See if latest question has been answered
                            questionAnswered =
                                snapshot.data.docs.last["answered"];
                            print(
                                "Latest question is answered: $questionAnswered.");
                            return RaisedButton(
                              onPressed: (questionAnswered)
                                  ? () {
                                      print(
                                          "Deck not completed & Latest question answered!");
                                      _addQuestion(playingDeck);
                                    }
                                  : null,
                              textColor: Colors.black,
                              color: Colors.red[200],
                              disabledColor: Colors.grey,
                              disabledTextColor: Colors.grey[50],
                              padding: const EdgeInsets.all(10.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Next Question",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    "${playingDeck.name}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  // Then, get all question containers
                  index -= 1;
                  return QuestionContainer(
                    me: widget.me,
                    snapshot: snapshot,
                    index: index,
                    conversation: widget.conversation,
                    scrollController: scrollController,
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _addQuestion(GeneratedDeck deck) {
    db.addQuestion(widget.conversation.id, deck);
  }
}
