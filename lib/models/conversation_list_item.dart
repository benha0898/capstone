import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:flutter/cupertino.dart';

abstract class ConversationListItem {
  DateTime timestamp;

  Widget buildItem(BuildContext context,
      {int groupSize, int id, bool isFirst, bool isLast});

  Message getMessage();

  GeneratedQuestion getQuestion();
}
