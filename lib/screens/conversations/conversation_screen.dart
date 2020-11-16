import 'package:CapstoneProject/models/conversation_list_item.dart';
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

  const ConversationScreen({Key key, this.conversation}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int currentUser = 1;
  List<User> users = <User>[];
  List<ChatItem> chatItems = ChatItem.list;

  List<GeneratedDeck> decks = <GeneratedDeck>[];
  List<GeneratedQuestion> questions;
  List<Message> messages;
  List<ConversationListItem> convoListItems = <ConversationListItem>[];

  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    users = widget.conversation.users;
    decks = widget.conversation.content.decks;
    questions =
        decks.map((e) => e.questions).expand((element) => element).toList();
    messages = widget.conversation.content.messages;
    convoListItems.addAll(questions);
    convoListItems.addAll(messages);
    convoListItems.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    print("Hi");
    print(convoListItems);

    textController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainColor,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.blueColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.more_horiz,
              color: AppColors.blueColor,
            ),
            onPressed: () {},
          ),
        ],
        title: Text(
          widget.conversation.users.length > 1
              ? "${widget.conversation.users.map((element) => element.firstName).join(', ')}"
              : "${widget.conversation.users.map((element) => element.name).join(', ')}",
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Conversation Body
          Expanded(
            child: ListView.builder(
              itemCount: convoListItems.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: (convoListItems[index] is Message)
                      ? convoListItems[index].buildItem(context,
                          id: currentUser,
                          isFirst: _isFirstMessage(convoListItems, index),
                          isLast: _isLastMessage(convoListItems, index))
                      : convoListItems[index].buildItem(context,
                          groupSize: users.length + 1, id: currentUser),
                );
              },
            ),
          ),
          // isTyping Indicator
          if (widget.conversation.isTyping)
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: ExactAssetImage(
                          () {
                            for (int i = 0; i < convoListItems.length; i++) {
                              if (convoListItems[i].getMessage() != null) {
                                return "assets/images/${convoListItems[i].getMessage().userId}.png";
                              }
                            }
                            return "assets/default.jpg";
                          }(),
                        ),
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
                      color: AppColors.blueColor,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          // Text Field
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(12),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  decoration: BoxDecoration(
                    color: AppColors.darkColor,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: textController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Type something...",
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
                          Icons.photo_outlined,
                          color: AppColors.blueColor,
                        ),
                        onPressed: null,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.sentiment_satisfied_alt_outlined,
                          color: AppColors.blueColor,
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
                      color: AppColors.blueColor,
                    ),
                    onPressed: _addMessage,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  _addMessage() {
    setState(() {
      chatItems.insert(
          0, ChatItem(senderId: "1", message: textController.text));
      textController.clear();
    });
  }

  _isFirstMessage(List<ConversationListItem> convoListItems, int index) {
    if (index == 0) return true;
    if (convoListItems[index - 1] is! Message) return true;
    Message message = convoListItems[index] as Message;
    Message prevMessage = convoListItems[index - 1] as Message;
    return (message.userId != prevMessage.userId);
  }

  _isLastMessage(List<ConversationListItem> convoListItems, int index) {
    int maxIndex = convoListItems.length - 1;
    if (index == maxIndex) return true;
    if (convoListItems[index + 1] is! Message) return true;
    Message message = convoListItems[index] as Message;
    Message nextMessage = convoListItems[index + 1] as Message;

    return (message.userId != nextMessage.userId);
  }
}
