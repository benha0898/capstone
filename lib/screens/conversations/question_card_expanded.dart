import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/conversations/chat_text_field.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestionCardExpanded extends StatefulWidget {
  @override
  _QuestionCardExpandedState createState() => _QuestionCardExpandedState();

  final User me;
  final GeneratedQuestion question;
  final Conversation conversation;

  const QuestionCardExpanded({
    Key key,
    this.me,
    this.question,
    this.conversation,
  }) : super(key: key);
}

class _QuestionCardExpandedState extends State<QuestionCardExpanded> {
  DatabaseService db = DatabaseService();
  GeneratedQuestion question;
  List<Message> replies;

  double previousOffset;

  final TextEditingController textController = TextEditingController();
  GlobalKey<ChatTextFieldState> _keyChatTextField = new GlobalKey();

  @override
  void initState() {
    super.initState();

    question = widget.question;
    replies = question.replies;

    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    //final Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          image: MyTheme.backgroundImage,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBody: true,
          body: Hero(
            tag: question.id,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: question.color,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0)),
                  boxShadow: [
                    BoxShadow(
                      color: MyTheme.darkColor.withOpacity(0.5),
                      spreadRadius: 5.0,
                      blurRadius: 7.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Card's header
                    Stack(
                      children: [
                        ListTile(
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
                          trailing: Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: MyTheme.whiteColor,
                          ),
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                              onTap: () {
                                print("Question expand!");
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Card's content
                    Expanded(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          // Answers
                          Column(
                            children: [
                              for (Message answer in question.answers)
                                (question.answered ||
                                        answer.sender["id"] == widget.me.id)
                                    ? Stack(
                                        overflow: Overflow.visible,
                                        children: [
                                          // Answer container
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: EdgeInsets.only(
                                                left: 20.0,
                                                top: 5.0,
                                                right: 20.0,
                                                bottom: 20.0),
                                            padding: EdgeInsets.all(20.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10)),
                                              color: MyTheme.whiteColor
                                                  .withOpacity(0.8),
                                            ),
                                            child: Text(
                                              answer.text,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          // User avatar
                                          Positioned.fill(
                                            child: Align(
                                              alignment: Alignment(0, 1),
                                              child: Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image: Image.network(
                                                      answer.sender[
                                                          "profilePicture"],
                                                    ).image,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(100),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      )
                                    : SizedBox(),
                            ],
                          ),
                          // Replies
                          Column(
                            children: [
                              for (int i = 0; i < replies.length; i++)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        _messageSentByMe(replies[i])
                                            ? MainAxisAlignment.end
                                            : MainAxisAlignment.start,
                                    children: [
                                      // Chat avater
                                      _isFirstMessage(i) &&
                                              !_messageSentByMe(replies[i])
                                          ? Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: Image.network(
                                                    replies[i].sender[
                                                        "profilePicture"],
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
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.7,
                                        ),
                                        padding: EdgeInsets.all(12.0),
                                        margin: EdgeInsets.symmetric(
                                          vertical: (!_isFirstMessage(i) &&
                                                  !_isLastMessage(i))
                                              ? 0
                                              : 6,
                                          horizontal:
                                              (replies[i].sender["id"] !=
                                                      widget.me.id)
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (!_messageSentByMe(replies[i]))
                                                ? Column(
                                                    children: [
                                                      Text(
                                                        replies[i].sender[
                                                            "firstName"],
                                                        style: TextStyle(
                                                          color: MyTheme
                                                              .whiteColor,
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
                      ),
                    ),
                    (question.answered || !_answeredByMe(question))
                        ? ChatTextField(
                            key: _keyChatTextField,
                            parentAction: _addMessage,
                            questionAnswered: question.answered,
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
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
    final keyContext = key.currentContext;
    if (keyContext != null) {
      Future.delayed(Duration(milliseconds: 200)).then((value) {
        Scrollable.ensureVisible(
          keyContext,
          duration: Duration(microseconds: 200),
        );
      });
    }
  }

  void _addMessage(String text) {
    Message message = Message(
      sender: widget.me.info,
      text: text,
    );
    db.addMessage(widget.conversation, message, this.question).then((value) {
      // _keyChatTextField.currentState
      //     .updateTarget(question: this.updatedQuestion);
    }).then((value) {
      if (!_answeredByMe(this.question)) {
        Navigator.pop(context);
      }
    });
  }
}
