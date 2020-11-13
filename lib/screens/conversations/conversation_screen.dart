import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/models/chat_item.dart';
import 'package:CapstoneProject/models/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ConversationScreen extends StatefulWidget {
  final Conversation otherMember;

  const ConversationScreen({Key key, this.otherMember}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String currentUser = "1";
  String pairUser = "2";
  List<ChatItem> chatItems = ChatItem.list;
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
          widget.otherMember.users.length > 1
              ? "${widget.otherMember.users.map((element) => element.firstName).join(', ')}"
              : "${widget.otherMember.users.map((element) => element.name).join(', ')}",
        ),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: chatItems.length,
              reverse: true,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  child: Row(
                    mainAxisAlignment: chatItems[index].senderId == currentUser
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      _isFirstMessage(chatItems, index) &&
                              chatItems[index].senderId == pairUser
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
                            topLeft: Radius.circular(
                                _isFirstMessage(chatItems, index) ? 5 : 10),
                            bottomLeft: Radius.circular(
                                _isLastMessage(chatItems, index) ? 5 : 10),
                          ),
                          color: chatItems[index].senderId == currentUser
                              ? AppColors.blueColor
                              : Colors.white38,
                        ),
                        child: Text(
                          "${chatItems[index].message}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          if (widget.otherMember.isTyping)
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
                          "assets/default.jpg",
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

  _isFirstMessage(List<ChatItem> chatItems, int index) {
    return (chatItems[index].senderId !=
            chatItems[index - 1 < 0 ? 0 : index - 1].senderId) ||
        index == 0;
  }

  _isLastMessage(List<ChatItem> chatItems, int index) {
    int maxIndex = chatItems.length - 1;
    return (chatItems[index].senderId !=
            chatItems[index + 1 > maxIndex ? maxIndex : index + 1].senderId) ||
        index == 0;
  }
}
