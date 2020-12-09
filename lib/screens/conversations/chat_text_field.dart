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

  @override
  void initState() {
    super.initState();

    accentColor = widget.question.color.withBlue(150).withGreen(50);

    textController.addListener(() {
      setState(() {});
    });
    focusNode.addListener(() {
      setState(() {
        maxLines = (focusNode.hasFocus) ? 6 : 1;
      });
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
              color: MyTheme.darkColor,
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
                        color: Colors.white30,
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
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
        if (textController.text != '')
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
