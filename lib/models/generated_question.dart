import 'package:CapstoneProject/models/conversation_list_item.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GeneratedQuestion implements ConversationListItem {
  int id;
  String question;
  DateTime timestamp;
  List<Message> answers;
  List<Message> messages;
  bool answered = false;

  GeneratedQuestion({this.id, this.question, timestamp, answers, messages})
      : this.timestamp = timestamp ?? DateTime.now(),
        this.answers = answers ?? List<Message>(),
        this.messages = messages ?? List<Message>();

  void addAnswer(Message answer) {
    this.answers.add(answer);
  }

  void addMessage(Message message) {
    this.messages.add(message);
  }

  void setAnswered(bool answered) {
    this.answered = answered;
  }

  Widget buildItem(BuildContext context,
      {int groupSize, int id, bool isFirst, bool isLast}) {
    return Card(
      child: ExpansionTile(
        title: Container(
          child: Text(
            "Question ${this.id}",
            // style: TextStyle(
            //   color: Colors.black,
            // ),
          ),
          // color: Colors.white,
        ),
        subtitle: Text("${answers.length}/$groupSize answered"),
        children: [
          Column(
            children: [
              for (Message answer in answers)
                Container(
                  margin: EdgeInsets.all(5.0),
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: AppColors.darkColor,
                  ),
                  child: Text(
                    answer.text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                )
            ],
          ),
          Column(
            children: [
              for (Message message in messages)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: message.userId == id
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      message.userId != id
                          ? Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: ExactAssetImage(
                                    "assets/default.jpg",
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
                        margin: EdgeInsets.all(5.0),
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: AppColors.blueColor,
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
