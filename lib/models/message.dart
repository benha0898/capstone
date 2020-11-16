import 'package:CapstoneProject/models/conversation_list_item.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message implements ConversationListItem {
  int userId;
  String text;
  DateTime timestamp;

  Message({this.userId, this.text, timestamp})
      : this.timestamp = timestamp ?? DateTime.now();

  Message getMessage() {
    return this;
  }

  GeneratedQuestion getQuestion() {
    return null;
  }

  Widget buildItem(BuildContext context,
      {int groupSize, int id, bool isFirst, bool isLast}) {
    return Row(
      mainAxisAlignment:
          userId == id ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        isFirst && userId != id
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: ExactAssetImage(
                      "assets/images/${this.userId}.png",
                    ),
                  ),
                  borderRadius: BorderRadius.all(
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
            maxWidth: MediaQuery.of(context).size.width * .7,
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
              topLeft: Radius.circular(isFirst ? 5 : 10),
              bottomLeft: Radius.circular(isLast ? 5 : 10),
            ),
            color: userId == id ? AppColors.blueColor : Colors.white38,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
