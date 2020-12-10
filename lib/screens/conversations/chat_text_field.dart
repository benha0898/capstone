import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  @override
  ChatTextFieldState createState() => ChatTextFieldState();

  final void Function(String text) parentAction;
  final GeneratedQuestion question;

  const ChatTextField({Key key, this.parentAction, this.question})
      : super(key: key);
}

class ChatTextFieldState extends State<ChatTextField> {
  final textController = TextEditingController();
  final FocusNode focusNode = FocusNode();
  Color accentColor;
  int maxLines = 6;
  bool isEmpty = true;

  @override
  void initState() {
    super.initState();

    if (widget.question.color == MyTheme.yellowColor)
      accentColor = Color(0xFF094BF2).withOpacity(1);
    else if (widget.question.color == MyTheme.blueColor)
      accentColor = Color(0xFFAA6F49).withOpacity(1);
    else if (widget.question.color == MyTheme.redColor)
      accentColor = Color(0xFF72EBE4).withOpacity(1);
    else
      accentColor = MyTheme.darkColor;

    textController.addListener(() {
      if (isEmpty && textController.text.length > 0)
        setState(() => isEmpty = false);
      else if (!isEmpty && textController.text.length == 0)
        setState(() => isEmpty = true);
    });
    focusNode.addListener(() {
      if (maxLines == 6 && !focusNode.hasFocus)
        setState(() => maxLines = 1);
      else if (maxLines == 1 && focusNode.hasFocus)
        setState(() => maxLines = 6);
    });
  }

  @override
  Widget build(BuildContext context) {
    print("Chatfield rebuilt");
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.all(12),
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: MyTheme.whiteColor,
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              border: Border.fromBorderSide(BorderSide.none),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    minLines: 1,
                    maxLines: maxLines,
                    controller: textController,
                    focusNode: focusNode,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: (widget.question.answered)
                          ? "Send a message"
                          : "Type your answer",
                      hintStyle: TextStyle(
                        color: MyTheme.greyAccentColor,
                      ),
                    ),
                    style: TextStyle(
                      color: MyTheme.darkColor,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.sentiment_satisfied_alt_outlined,
                    color: accentColor,
                  ),
                  onPressed: null,
                ),
              ],
            ),
          ),
        ),
        if (!isEmpty)
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: IconButton(
              icon: Icon(
                Icons.send,
                color: accentColor,
              ),
              onPressed: () {
                widget.parentAction(textController.text);
                setState(() {
                  textController.clear();
                });
              },
            ),
          )
        else if (!widget.question.answered)
          Padding(
            padding: EdgeInsets.only(right: 0.0),
            child: MaterialButton(
              elevation: 5,
              onPressed: () {
                print("PASS!!!");
                widget.parentAction("");
                setState(() {
                  textController.clear();
                });
              },
              color: accentColor,
              shape: CircleBorder(),
              padding: EdgeInsets.all(22.0),
              child: Text(
                "PASS",
                style: TextStyle(
                  color: MyTheme.whiteColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  // void updateTarget({GeneratedQuestion question}) {
  //   setState(() {
  //     if (question == null) {
  //       this._questionTargetted = false;
  //     } else {
  //       this._question = question;
  //       this._questionTargetted = true;
  //     }
  //   });
  // }
}
