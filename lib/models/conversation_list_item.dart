import 'package:flutter/cupertino.dart';

abstract class ConversationListItem {
  DateTime timestamp;

  Widget buildItem(BuildContext context,
      {int groupSize, int id, bool isFirst, bool isLast});
}
