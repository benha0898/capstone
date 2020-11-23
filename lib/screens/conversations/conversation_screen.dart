import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/models/chat_item.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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

  List<ChatItem> chatItems = List<ChatItem>();
  List<GeneratedDeck> decks = List<GeneratedDeck>();
  GeneratedQuestion updatedQuestion;

  final textController = TextEditingController();
  GlobalKey<ChatTextFieldState> _keyChatTextField = new GlobalKey();

  @override
  void initState() {
    super.initState();

    textController.addListener(() {
      setState(() {});
    });

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   getData();
    // });
  }

  // getData() async {
  //   await FirebaseFirestore.instance
  //       .collection("conversations")
  //       .doc(widget.conversation.id)
  //       .collection("chatItems")
  //       .get()
  //       .then((value) => setState(() {
  //             if (value != null && value.docs.length != 0) {
  //               chatItems.addAll(List.generate(value.docs.length,
  //                   (index) => ChatItem.fromSnapshot(value.docs[index])));
  //               print("I have ${chatItems.length} chat items!");
  //             }
  //           }));
  //   await FirebaseFirestore.instance
  //       .collection("conversations")
  //       .doc(widget.conversation.id)
  //       .collection("decks")
  //       .get()
  //       .then((value) => setState(() {
  //             if (value != null && value.docs.length != 0) {
  //               decks.addAll(List.generate(value.docs.length,
  //                   (index) => GeneratedDeck.fromSnapshot(value.docs[index])));
  //               print("I have ${decks.length} decks!");
  //             }
  //           }));
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: AppColors.blueColor,
            ),
            onPressed: () {},
          ),
        ],
        title: Text(
          widget.conversation.users.length > 1
              ? "${widget.conversation.users.map((element) => element["firstName"]).join(', ')}"
              : "${widget.conversation.users.map((element) => element["firstName"] + " " + element["lastName"]).join(', ')}",
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conversation Body
          StreamBuilder(
              stream: db.getChatItems(widget.conversation.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: Text("Loading..."));
                else {
                  chatItems = List.generate(
                      snapshot.data.documents.length,
                      (index) => ChatItem.fromSnapshot(
                          snapshot.data.documents[index]));
                }
                return Expanded(
                  child: chatItems.length == 0
                      ? Text("Start a conversation!")
                      : ListView.builder(
                          itemCount: chatItems.length,
                          reverse: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6,
                              ),
                              child: (chatItems[index].sender["id"] != "")
                                  ? Row(
                                      mainAxisAlignment:
                                          chatItems[index].sender["id"] ==
                                                  widget.me.id
                                              ? MainAxisAlignment.end
                                              : MainAxisAlignment.start,
                                      children: [
                                        _isFirstMessage(index) &&
                                                !_chatItemSentByMe(
                                                    chatItems[index])
                                            ? Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: Image.network(
                                                      chatItems[index].sender[
                                                          "profilePicture"],
                                                    ).image,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                              )
                                            : Container(
                                                width: 30,
                                                height: 30,
                                              ),
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .7,
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
                                          margin: EdgeInsets.symmetric(
                                            vertical: 6,
                                            horizontal: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              bottomRight: Radius.circular(10),
                                              topLeft: Radius.circular(
                                                  _isFirstMessage(index)
                                                      ? 5
                                                      : 10),
                                              bottomLeft: Radius.circular(
                                                  _isLastMessage(index)
                                                      ? 5
                                                      : 10),
                                            ),
                                            color: _chatItemSentByMe(
                                                    chatItems[index])
                                                ? AppColors.blueColor
                                                : Colors.white38,
                                          ),
                                          child: Text(
                                            chatItems[index].text,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : StreamBuilder(
                                      stream: db.getQuestion(
                                          widget.conversation.id,
                                          chatItems[index].deck,
                                          chatItems[index].question),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            "Loading...",
                                          );
                                        } else {
                                          GeneratedQuestion question =
                                              GeneratedQuestion.fromSnapshot(
                                                  snapshot.data);
                                          //print("Question ${question.number} has ${question.answers.length} answers right now");
                                          updatedQuestion =
                                              GeneratedQuestion.fromSnapshot(
                                                  snapshot.data);
                                          //print("Updated question ${question.number} with ${question.answers.length} answers");
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: (!question.answered)
                                                  ? Colors.white
                                                  : Colors.red[200],
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              border: (!question.answered &&
                                                      !_answeredByMe(question))
                                                  ? Border.all(
                                                      color: Colors.red[200],
                                                      width: 5,
                                                    )
                                                  : Border.fromBorderSide(
                                                      BorderSide.none),
                                            ),
                                            child: (question.answered)
                                                ? ExpansionTile(
                                                    onExpansionChanged:
                                                        (bool isExpanded) =>
                                                            _changeTextField(
                                                                isExpanded,
                                                                question),
                                                    title: Container(
                                                      child: Text(
                                                        "Q${question.number}. ${question.text}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // color: Colors.white,
                                                    ),
                                                    subtitle: Text(
                                                      "Show answers",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    children: [
                                                      Column(
                                                        children: [
                                                          for (Message answer
                                                              in question
                                                                  .answers)
                                                            Container(
                                                              margin: EdgeInsets
                                                                  .all(5.0),
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(
                                                                          10.0),
                                                              decoration:
                                                                  BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            10)),
                                                                color: AppColors
                                                                    .darkColor,
                                                              ),
                                                              child: Text(
                                                                answer.text,
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                      Column(
                                                        children: [
                                                          for (Message reply
                                                              in question
                                                                  .replies)
                                                            Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      8.0),
                                                              child: Row(
                                                                mainAxisAlignment: _messageSentByMe(
                                                                        reply)
                                                                    ? MainAxisAlignment
                                                                        .end
                                                                    : MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  !_messageSentByMe(
                                                                          reply)
                                                                      ? Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            image:
                                                                                DecorationImage(
                                                                              image: Image.network(
                                                                                reply.sender["profilePicture"],
                                                                              ).image,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.all(
                                                                              Radius.circular(100),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          width:
                                                                              30,
                                                                          height:
                                                                              30,
                                                                        ),
                                                                  Container(
                                                                    margin: EdgeInsets
                                                                        .all(
                                                                            5.0),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10.0),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(10)),
                                                                      color: AppColors
                                                                          .blueColor,
                                                                    ),
                                                                    child: Text(
                                                                      reply
                                                                          .text,
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )
                                                        ],
                                                      ),
                                                    ],
                                                  )
                                                : ExpansionTile(
                                                    onExpansionChanged:
                                                        !_answeredByMe(question)
                                                            ? (bool isExpanded) =>
                                                                _changeTextField(
                                                                    isExpanded,
                                                                    question)
                                                            : (bool isExpanded) =>
                                                                () {},
                                                    trailing:
                                                        SizedBox(width: 0),
                                                    title: Container(
                                                      child: Text(
                                                        "Q${question.number}. ${question.text}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      // color: Colors.white,
                                                    ),
                                                    subtitle: Row(
                                                      children: [
                                                        Text(
                                                          "${question.answers.length}/${widget.conversation.users.length} answered. ",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        _answeredByMe(question)
                                                            ? Text(
                                                                "Waiting for others")
                                                            : Text(
                                                                "Click here to answer",
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .blueColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
                                                              ),
                                                      ],
                                                    ),
                                                  ),
                                          );
                                        }
                                      }),
                            );
                          },
                        ),
                );
              }),
          // isTyping Indicator
          if (widget.conversation.typing["isTyping"])
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.network(
                          widget.conversation.typing["sender"]
                              ["profilePicture"],
                        ).image,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 12,
                    ),
                    child: SpinKitThreeBounce(
                      color: AppColors.blueColor,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          // Text Field
          ChatTextField(key: _keyChatTextField, parentAction: _addMessage),
        ],
      ),
    );
  }

  void _addMessage(String text, {GeneratedQuestion question}) {
    ChatItem chatItem = ChatItem(
        sender: widget.me.info,
        text: text,
        deck: question?.deck ?? "",
        question: question?.id ?? "");
    db
        .addMessage(widget.conversation, chatItem, question: question)
        .then((value) {
      if (question != null) {
        print(
            "setState() called: From ${question.answers.length} to ${this.updatedQuestion.answers.length}");
        _keyChatTextField.currentState
            .updateTarget(question: this.updatedQuestion);
      }
    });
  }

  bool _isFirstMessage(int index) {
    if (index == 0) return true;
    return (chatItems[index].sender["id"] != chatItems[index - 1].sender["id"]);
  }

  bool _isLastMessage(int index) {
    int maxIndex = chatItems.length - 1;
    if (index == maxIndex) return true;
    return (chatItems[index].sender["id"] != chatItems[index + 1].sender["id"]);
  }

  bool _answeredByMe(GeneratedQuestion question) {
    return question.answers
        .any((element) => element.sender["id"] == widget.me.id);
  }

  bool _messageSentByMe(Message message) {
    return message.sender["id"] == widget.me.id;
  }

  bool _chatItemSentByMe(ChatItem chatItem) {
    return chatItem.sender["id"] == widget.me.id;
  }

  void _changeTextField(bool isExpanded, GeneratedQuestion question) {
    if (isExpanded) {
      print("Question ${question.number} Expanded!");
      _keyChatTextField.currentState.updateTarget(question: question);
    } else {
      print("Question ${question.number} Collapsed!");
      _keyChatTextField.currentState.updateTarget();
    }
  }
}

class ChatTextField extends StatefulWidget {
  @override
  ChatTextFieldState createState() => ChatTextFieldState();

  final void Function(String text, {GeneratedQuestion question}) parentAction;

  const ChatTextField({Key key, this.parentAction}) : super(key: key);
}

class ChatTextFieldState extends State<ChatTextField> {
  final textController = TextEditingController();
  GeneratedQuestion _question;
  bool _questionTargetted;

  @override
  void initState() {
    super.initState();

    _questionTargetted = false;

    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.darkColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: (_questionTargetted)
                  ? Border.all(
                      color: (_question.answered)
                          ? Colors.yellow
                          : Colors.red[200],
                      width: 5,
                    )
                  : Border.fromBorderSide(BorderSide.none),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: (_questionTargetted)
                          ? ((_question.answered)
                              ? "Send a reply to question ${_question.number}"
                              : "Answer question ${_question.number}")
                          : "Send a message",
                      hintStyle: TextStyle(
                        color: Colors.white30,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                // IconButton(
                //   icon: Icon(
                //     Icons.photo_outlined,
                //     color: AppColors.blueColor,
                //   ),
                //   onPressed: null,
                // ),
                IconButton(
                  icon: Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    color: AppColors.blueColor,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
        if (textController.text != '')
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: AppColors.blueColor,
              ),
              onPressed: () {
                if (_questionTargetted) {
                  widget.parentAction(textController.text, question: _question);
                } else {
                  widget.parentAction(textController.text);
                }
                textController.clear();
                setState(() {});
              },
            ),
          ),
      ],
    );
  }

  void updateTarget({GeneratedQuestion question}) {
    setState(() {
      if (question == null) {
        this._questionTargetted = false;
      } else {
        this._question = question;
        this._questionTargetted = true;
      }
    });
  }
}
