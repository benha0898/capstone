import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class ChatTextField extends StatefulWidget {
  @override
  ChatTextFieldState createState() => ChatTextFieldState();

  final void Function(String text) parentAction;
  final bool questionAnswered;

  const ChatTextField({Key key, this.parentAction, this.questionAnswered})
      : super(key: key);
}

class ChatTextFieldState extends State<ChatTextField> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

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
              border: Border.fromBorderSide(BorderSide.none),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: (widget.questionAnswered)
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
                widget.parentAction(textController.text);
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
