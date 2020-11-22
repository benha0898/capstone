import 'package:CapstoneProject/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GeneratedQuestion {
  String id;
  int number;
  String text;
  DateTime timestamp;
  List<Message> answers = List<Message>();
  List<Message> replies = List<Message>();
  bool answered;

  GeneratedQuestion(
      {this.id, this.number, this.text, timestamp, answers, replies, answered})
      : this.timestamp = timestamp ?? DateTime.now(),
        this.answers = answers ?? List<Map<String, dynamic>>(),
        this.replies = replies ?? List<Map<String, dynamic>>(),
        this.answered = answered ?? false;

  GeneratedQuestion.fromSnapshot(DocumentSnapshot snapshot) {
    this.id = snapshot.id;
    this.number = snapshot["number"];
    this.text = snapshot["text"];
    this.timestamp = snapshot["timestamp"].toDate();
    if (snapshot.data().containsKey("answers"))
      this.answers.addAll(List.generate(
          snapshot["answers"].length,
          (index) => Message.fromMap(
              Map<String, dynamic>.from(snapshot["answers"][index]))));
    if (snapshot.data().containsKey("replies")) {
      print("Question $number: I have replies!");
      this.replies.addAll(List.generate(
          snapshot["replies"].length,
          (index) => Message.fromMap(
              Map<String, dynamic>.from(snapshot["replies"][index]))));
    } else {
      print("Question $number: I ain't got no replies!");
    }
    this.answered = snapshot["answered"];
  }
}
