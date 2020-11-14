import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/message.dart';

class ConversationContent {
  List<GeneratedDeck> decks;
  List<Message> messages;
  DateTime lastTimestamp;
  String lastActivity;

  ConversationContent({List<GeneratedDeck> decks, List<Message> messages})
      : this.decks = decks ?? null,
        this.messages = messages ?? null;

  void addMessage(Message message) {
    this.messages.add(message);
  }

  void addDeck(GeneratedDeck deck) {
    this.decks.add(deck);
  }

  // void setTimestamp() {
  //   DateTime lastMessageTimestamp = DateTime(1970, 01, 01);
  //   DateTime lastQuestionTimestamp = DateTime(1970, 01, 01);
  //   DateTime lastAnswerTimestamp = DateTime(1970, 01, 01);
  //   DateTime lastDiscussionTimestamp = DateTime(1970, 01, 01);
  // }
}
