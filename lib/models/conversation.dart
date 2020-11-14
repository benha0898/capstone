import 'package:CapstoneProject/models/conversation_content.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:CapstoneProject/models/user.dart';

class Conversation {
  int id;
  bool isTyping;
  String lastMessage;
  DateTime lastMessageTime;
  List<User> users;
  ConversationContent content;

  Conversation(
      {this.id,
      this.isTyping,
      this.lastMessage,
      this.lastMessageTime,
      this.users,
      this.content});

  static List<Conversation> list = [
    Conversation(
      id: 1,
      isTyping: false,
      lastMessage: "hello!",
      lastMessageTime: DateTime(2020, 10, 31, 19, 30, 00),
      users: [
        User(id: 9, firstName: "Alex", lastName: "Anderson"),
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 11, firstName: "Christine", lastName: "Chang"),
      ],
      content: ConversationContent(
        decks: [
          GeneratedDeck(questions: [
            GeneratedQuestion(
              timestamp: DateTime(2020, 11, 11, 09, 00, 00),
              id: 2,
              question:
                  "How do you make yourself feel confident when you're nervous?",
              answers: [
                Message(
                  userId: 1,
                  text: "Make myself laugh",
                ),
              ],
              messages: List<Message>(),
            ),
            GeneratedQuestion(
              timestamp: DateTime(2020, 11, 10, 09, 00, 00),
              id: 1,
              question:
                  "What is something you've never done, but have always wanted to do?",
              answers: [
                Message(
                  userId: 1,
                  text: "Skydiving!",
                ),
                Message(
                  userId: 9,
                  text: "Standup comedy",
                ),
                Message(
                  userId: 11,
                  text: "Travel by myself",
                ),
              ],
              messages: [
                Message(
                  userId: 9,
                  text: "Ooooh I'd love to try skydiving too!",
                ),
                Message(
                  userId: 1,
                  text: "Aww Christine where would you want to travel?",
                ),
              ],
            ),
          ]),
        ],
        messages: [
          Message(
            timestamp: DateTime(2020, 11, 12, 09, 00, 00),
            userId: 1,
            text: "Hi Alex! How's it going?",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 25, 00),
            userId: 1,
            text: "Talk to you tomorrow",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 20, 00),
            userId: 1,
            text: "Alright sounds good!",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 15, 00),
            userId: 9,
            text: "Hey I gotta head out. Let's circle back to this tomorrow",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 10, 00),
            userId: 1,
            text: "Yeah I know. Hopefully things will get better soon",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 05, 00),
            userId: 9,
            text: "This year has been crazy man. Can't wait for it to be over",
          ),
          Message(
            timestamp: DateTime(2020, 11, 10, 12, 00, 00),
            userId: 9,
            text:
                "That was a great question! I feel like I got to know you a lot better now :)",
          ),
        ],
      ),
    ),
    Conversation(
      id: 2,
      isTyping: false,
      lastMessage: "Sounds great!",
      lastMessageTime: DateTime(2020, 11, 12, 9, 00, 00),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
        User(id: 6, firstName: "Michelle", lastName: "Weremczuk"),
      ],
    ),
    Conversation(
      id: 3,
      isTyping: false,
      lastMessage: "Sure, no problem!",
      lastMessageTime: DateTime(2020, 11, 11, 14, 59, 59),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
        User(id: 3, firstName: "Jeffrey", lastName: "Davis"),
        User(id: 5, firstName: "Robert", lastName: "Andruchow"),
      ],
    ),
    Conversation(
      id: 4,
      isTyping: false,
      lastMessage: "I'm great! How are you?",
      lastMessageTime: DateTime(2020, 11, 8, 00, 30, 00),
      users: [
        User(id: 1, firstName: "Ben", lastName: "Ha"),
        User(id: 10, firstName: "Bob", lastName: "Billy"),
      ],
    ),
  ];
}
