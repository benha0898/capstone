import 'dart:ui';

import 'package:CapstoneProject/db.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/screens/conversations/chat_text_field.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class QuestionContainer extends StatefulWidget {
  @override
  _QuestionContainerState createState() => _QuestionContainerState();

  final User me;
  final AsyncSnapshot<dynamic> snapshot;
  final int index;
  final Conversation conversation;

  final ScrollController scrollController;

  const QuestionContainer({
    Key key,
    this.me,
    this.snapshot,
    this.index,
    this.conversation,
    this.scrollController,
  }) : super(key: key);
}

class _QuestionContainerState extends State<QuestionContainer>
    with AutomaticKeepAliveClientMixin {
  DatabaseService db = DatabaseService();
  Widget subtitle = Text("");
  Widget trailing;
  GeneratedQuestion question;
  List<Message> replies;

  final GlobalKey expansionTileKey = GlobalKey();
  double previousOffset;

  final TextEditingController textController = TextEditingController();
  GlobalKey<ChatTextFieldState> _keyChatTextField = new GlobalKey();

  @override
  void initState() {
    super.initState();

    question =
        GeneratedQuestion.fromSnapshot(widget.snapshot.data.docs[widget.index]);

    subtitle = _setSubtitle(question, false);
    trailing = _setTrailing(false);
    replies = question.replies;

    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: question.color,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0), topRight: Radius.circular(15.0)),
        border: (!question.answered && !_answeredByMe(question))
            ? Border.all(
                color: Colors.red[200],
                width: 5,
              )
            : Border.fromBorderSide(BorderSide.none),
      ),
      child: (question.answered)
          ? ExpansionTile(
              key: expansionTileKey,
              onExpansionChanged: (bool isExpanded) {
                if (isExpanded) previousOffset = widget.scrollController.offset;
                scrollToSelectedContent(
                    isExpanded, previousOffset, expansionTileKey);
                setState(() {
                  subtitle = _setSubtitle(question, isExpanded);
                  trailing = _setTrailing(isExpanded);
                });
              },
              tilePadding: EdgeInsets.all(20.0),
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
              subtitle: this.subtitle,
              trailing: this.trailing,
              children: [
                // Answers
                Column(
                  children: [
                    for (Message answer in question.answers)
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
                ChatTextField(
                    key: _keyChatTextField,
                    parentAction: _addMessage,
                    questionAnswered: question.answered)
              ],
            )
          : ExpansionTile(
              key: expansionTileKey,
              onExpansionChanged: !_answeredByMe(question)
                  ? (bool isExpanded) {
                      setState(() {
                        subtitle = _setSubtitle(question, isExpanded);
                      });
                    }
                  : (bool isExpanded) => () {},
              trailing: SizedBox(width: 0),
              title: Container(
                child: Text(
                  "Q${question.number}. ${question.text}",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // color: Colors.white,
              ),
              subtitle: subtitle,
              children: [
                ChatTextField(
                    key: _keyChatTextField,
                    parentAction: _addMessage,
                    questionAnswered: question.answered)
              ],
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
            "${question.number}/${question.totalQuestions} - ${question.deckName}",
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
    print(
        "yPosition: $yPosition. scrollController's offset: ${widget.scrollController.offset}. scrollPoint: $scrollPoint");
    print(
        "maxScrollExtent: ${widget.scrollController.position.maxScrollExtent}");
    widget.scrollController.animateTo(
        (!isExpanded)
            ? previousOffset
            : (scrollPoint <= widget.scrollController.position.maxScrollExtent)
                ? scrollPoint
                : widget.scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  void _addMessage(String text) {
    Message message = Message(
      sender: widget.me.info,
      text: text,
    );
    db.addMessage(widget.conversation, message, this.question).then((value) {
      // _keyChatTextField.currentState
      //     .updateTarget(question: this.updatedQuestion);
    });
  }
}
