class ChatItem {
  final String senderId;
  final String message;

  ChatItem({this.senderId, this.message});

  static List<ChatItem> list = [
    ChatItem(
      senderId: "1",
      message: "Hi Alex! How's it going?",
    ),
    ChatItem(
      senderId: "1",
      message: "Talk to you tomorrow",
    ),
    ChatItem(
      senderId: "1",
      message: "Alright sounds good!",
    ),
    ChatItem(
      senderId: "2",
      message: "Hey I gotta head out. Let's circle back to this tomorrow",
    ),
    ChatItem(
      senderId: "1",
      message: "Yeah I know. Hopefully things will get better soon",
    ),
    ChatItem(
      senderId: "2",
      message: "This year has been crazy man. Can't wait for it to be over",
    ),
    ChatItem(
      senderId: "2",
      message:
          "That was a great question! I feel like I got to know you a lot better now :)",
    ),
  ];
}
