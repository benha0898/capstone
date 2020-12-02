import 'dart:ui';

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
  GeneratedDeck playingDeck;
  GeneratedQuestion updatedQuestion;
  bool questionAnswered;
  List<Map<String, String>> users;

  final TextEditingController textController = TextEditingController();
  GlobalKey<ChatTextFieldState> _keyChatTextField = new GlobalKey();

  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    users = widget.conversation.users
        .where((element) => element["id"] != widget.me.id)
        .toList();

    textController.addListener(() {
      setState(() {});
    });

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
          child: Column(
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
                        snapshot.data.documents[index],
                      ),
                    );
                  }
                  if (chatItems.length == 0)
                    return Center(child: Text("Start a conversation!"));
                  return Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: chatItems.length + 2,
                      reverse: true,
                      addAutomaticKeepAlives: true,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          if (widget.conversation.typing["isTyping"])
                            return Padding(
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
                                      color: MyTheme.blueColor,
                                      size: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          return SizedBox();
                        }
                        return StreamBuilder(
                          stream: db.getPlayingDeck(widget.conversation.id),
                          builder: (context, snapshot) {
                            print("Playing Deck gets built");
                            if (!snapshot.hasData) {
                              return Center(child: Text("Fetching decks"));
                            } else if (snapshot.data.docs.length == 0) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: RaisedButton(
                                  onPressed: null,
                                  child: Text("No deck playing"),
                                  disabledColor: Colors.grey,
                                  disabledTextColor: Colors.grey[50],
                                ),
                              );
                            }
                            playingDeck = GeneratedDeck.fromSnapshot(
                                snapshot.data.docs[0]);
                            if (index == 1)
                              return StreamBuilder(
                                  stream: db.questionAnswered(
                                      widget.conversation.id, playingDeck.id),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      print("playingDeck: ${playingDeck.id}");
                                      return Center(
                                          child: Text("Fetching questions"));
                                    } else {
                                      questionAnswered =
                                          snapshot.data.docs.last["answered"];
                                      print(
                                          "questionAnswered: $questionAnswered.");
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: RaisedButton(
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
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
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
                                      ),
                                    );
                                  });
                            index -= 2;
                            if (chatItems[index].sender["id"] != "")
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      _chatItemSentByMe(chatItems[index])
                                          ? MainAxisAlignment.end
                                          : MainAxisAlignment.start,
                                  children: [
                                    // Chat avatar
                                    _isFirstMessage(index) &&
                                            !_chatItemSentByMe(chatItems[index])
                                        ? Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: Image.network(
                                                  chatItems[index]
                                                      .sender["profilePicture"],
                                                ).image,
                                              ),
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(100),
                                              ),
                                            ),
                                          )
                                        : !_chatItemSentByMe(chatItems[index])
                                            ? SizedBox(
                                                width: 30,
                                                height: 30,
                                              )
                                            : SizedBox(),
                                    // Message bubble
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 12,
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: (!_isFirstMessage(index) &&
                                                !_isLastMessage(index))
                                            ? 0
                                            : 6,
                                        horizontal:
                                            (chatItems[index].sender["id"] !=
                                                    widget.me.id)
                                                ? 12
                                                : 0,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10),
                                          topLeft: Radius.circular(
                                              _isFirstMessage(index) ? 5 : 10),
                                          bottomLeft: Radius.circular(
                                              _isLastMessage(index) ? 5 : 10),
                                        ),
                                        color:
                                            _chatItemSentByMe(chatItems[index])
                                                ? MyTheme.blueColor
                                                : MyTheme.greyColor,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          (!_chatItemSentByMe(chatItems[index]))
                                              ? Column(
                                                  children: [
                                                    Text(
                                                      chatItems[index]
                                                          .sender["firstName"],
                                                      style: TextStyle(
                                                        color:
                                                            MyTheme.whiteColor,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: 5,
                                                    ),
                                                  ],
                                                )
                                              : SizedBox(),
                                          Text(
                                            chatItems[index].text,
                                            style: TextStyle(
                                              color: MyTheme.whiteColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            // Question containers
                            else
                              return StreamBuilder(
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
                                    updatedQuestion =
                                        GeneratedQuestion.fromSnapshot(
                                            snapshot.data);
                                    return QuestionContainer(
                                      me: widget.me,
                                      question: question,
                                      deck: playingDeck,
                                      conversation: widget.conversation,
                                      scrollController: scrollController,
                                      parentAction: _changeTextField,
                                    );
                                  }
                                },
                              );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
              // Text Field
              ChatTextField(key: _keyChatTextField, parentAction: _addMessage),
            ],
          ),
        ),
      ),
    );
  }

  void _addQuestion(GeneratedDeck deck) {
    db.addQuestion(widget.conversation.id, deck);
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
              color: MyTheme.darkColor,
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
                    color: MyTheme.blueColor,
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
                color: MyTheme.blueColor,
              ),
              onPressed: () {
                if (_questionTargetted) {
                  widget.parentAction(textController.text, question: _question);
                } else {
                  widget.parentAction(textController.text);
                }
                setState(() {
                  FocusScope.of(context).unfocus();
                  textController.clear();
                });
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

class QuestionContainer extends StatefulWidget {
  @override
  _QuestionContainerState createState() => _QuestionContainerState();

  final User me;
  final GeneratedQuestion question;
  final GeneratedDeck deck;
  final Conversation conversation;
  final ScrollController scrollController;
  final void Function(bool isExpanded, GeneratedQuestion question) parentAction;

  const QuestionContainer(
      {Key key,
      this.me,
      this.question,
      this.deck,
      this.conversation,
      this.scrollController,
      this.parentAction})
      : super(key: key);
}

class _QuestionContainerState extends State<QuestionContainer>
    with AutomaticKeepAliveClientMixin {
  Widget subtitle = Text("");
  Widget trailing;
  List<Message> replies;
  final GlobalKey expansionTileKey = GlobalKey();
  double previousOffset;

  @override
  void initState() {
    super.initState();

    subtitle = _setSubtitle(widget.question, false);
    trailing = _setTrailing(false);
    replies = widget.question.replies;
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: widget.question.color,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        border: (!widget.question.answered && !_answeredByMe(widget.question))
            ? Border.all(
                color: Colors.red[200],
                width: 5,
              )
            : Border.fromBorderSide(BorderSide.none),
      ),
      child: (widget.question.answered)
          ? ExpansionTile(
              key: expansionTileKey,
              onExpansionChanged: (bool isExpanded) {
                if (isExpanded) previousOffset = widget.scrollController.offset;
                scrollToSelectedContent(
                    isExpanded, previousOffset, expansionTileKey);
                setState(() {
                  subtitle = _setSubtitle(widget.question, isExpanded);
                  trailing = _setTrailing(isExpanded);
                });
                widget.parentAction(isExpanded, widget.question);
              },
              tilePadding: EdgeInsets.all(20.0),
              title: Container(
                margin: EdgeInsets.only(bottom: 10.0),
                child: Text(
                  widget.question.text,
                  style: TextStyle(
                    fontFamily: "DottiesChocolate",
                    fontSize: 22.0,
                    color: MyTheme.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                // color: Colors.white,
              ),
              subtitle: this.subtitle,
              trailing: this.trailing,
              children: [
                // Answers
                Column(
                  children: [
                    for (Message answer in widget.question.answers)
                      Stack(
                        overflow: Overflow.visible,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: 20.0,
                                top: 5.0,
                                right: 20.0,
                                bottom: 20.0),
                            padding: EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: MyTheme.whiteColor.withOpacity(0.8),
                            ),
                            child: Text(
                              answer.text,
                              style: TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Positioned.fill(
                            child: Align(
                              alignment: Alignment(0, 1),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: Image.network(
                                      answer.sender["profilePicture"],
                                    ).image,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(100),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                  ],
                ),
                // Replies
                Column(
                  children: [
                    for (int i = 0; i < replies.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: _messageSentByMe(replies[i])
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            // Chat avater
                            _isFirstMessage(i) && !_messageSentByMe(replies[i])
                                ? Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: Image.network(
                                          replies[i].sender["profilePicture"],
                                        ).image,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  )
                                : !_messageSentByMe(replies[i])
                                    ? SizedBox(
                                        width: 30,
                                        height: 30,
                                      )
                                    : SizedBox(),
                            // Message bubble
                            Container(
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              padding: EdgeInsets.all(12.0),
                              margin: EdgeInsets.symmetric(
                                vertical:
                                    (!_isFirstMessage(i) && !_isLastMessage(i))
                                        ? 0
                                        : 6,
                                horizontal:
                                    (replies[i].sender["id"] != widget.me.id)
                                        ? 12
                                        : 0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                  topLeft: Radius.circular(
                                      _isFirstMessage(i) ? 5 : 10),
                                  bottomLeft: Radius.circular(
                                      _isLastMessage(i) ? 5 : 10),
                                ),
                                color: _messageSentByMe(replies[i])
                                    ? MyTheme.blueColor
                                    : MyTheme.greyColor,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  (!_messageSentByMe(replies[i]))
                                      ? Column(
                                          children: [
                                            Text(
                                              replies[i].sender["firstName"],
                                              style: TextStyle(
                                                color: MyTheme.whiteColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        )
                                      : SizedBox(),
                                  Text(
                                    replies[i].text,
                                    style: TextStyle(
                                      color: MyTheme.whiteColor,
                                    ),
                                  ),
                                ],
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
              key: expansionTileKey,
              onExpansionChanged: !_answeredByMe(widget.question)
                  ? (bool isExpanded) {
                      setState(() {
                        subtitle = _setSubtitle(widget.question, isExpanded);
                      });
                      widget.parentAction(isExpanded, widget.question);
                    }
                  : (bool isExpanded) => () {},
              trailing: SizedBox(width: 0),
              title: Container(
                child: Text(
                  "Q${widget.question.number}. ${widget.question.text}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // color: Colors.white,
              ),
              subtitle: subtitle,
            ),
    );
  }

  Widget _setSubtitle(GeneratedQuestion question, bool isExpanded) {
    if (isExpanded)
      return SizedBox(
        height: 0.0,
        width: 0.0,
      );
    if (question.answered)
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${widget.question.number}/${widget.deck.totalQuestions} - ${widget.deck.name}",
            style: TextStyle(
              color: MyTheme.whiteColor,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: 10.0),
          Text(
            "Show answers",
            style: TextStyle(color: MyTheme.whiteColor),
          ),
        ],
      );
    return Row(
      children: [
        Text(
          "${question.answers.length}/${widget.conversation.users.length} answered. ",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        _answeredByMe(question)
            ? Text("Waiting for others")
            : Text(
                "Click here to answer",
                style: TextStyle(
                    color: MyTheme.blueColor, fontWeight: FontWeight.w700),
              ),
      ],
    );
  }

  Widget _setTrailing(bool isExpanded) {
    return Icon(
      (isExpanded)
          ? Icons.keyboard_arrow_up_rounded
          : Icons.keyboard_arrow_down_rounded,
      color: MyTheme.whiteColor,
      size: 28.0,
    );
  }

  bool _answeredByMe(GeneratedQuestion question) {
    return question.answers
        .any((element) => element.sender["id"] == widget.me.id);
  }

  bool _messageSentByMe(Message message) {
    return message.sender["id"] == widget.me.id;
  }

  bool _isFirstMessage(int i) {
    if (i == 0) return true;
    return (this.replies[i].sender["id"] != this.replies[i - 1].sender["id"]);
  }

  bool _isLastMessage(int i) {
    int maxIndex = replies.length - 1;
    if (i == maxIndex) return true;
    return (this.replies[i].sender["id"] != this.replies[i + 1].sender["id"]);
  }

  void scrollToSelectedContent(
      bool isExpanded, double previousOffset, GlobalKey key) {
    RenderBox box = key.currentContext.findRenderObject();
    double yPosition = box.localToGlobal(Offset.zero).dy;
    double scrollPoint = widget.scrollController.offset +
        yPosition -
        MediaQueryData.fromWindow(window).padding.top -
        56.0;
    widget.scrollController.animateTo(
        (!isExpanded)
            ? previousOffset
            : (scrollPoint <= widget.scrollController.position.maxScrollExtent)
                ? scrollPoint
                : widget.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }
}
