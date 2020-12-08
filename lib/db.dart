import 'dart:async';

import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/generated_deck.dart';
import 'package:CapstoneProject/models/generated_question.dart';
import 'package:CapstoneProject/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final DatabaseService _singleton = DatabaseService._internal();

  factory DatabaseService() {
    return _singleton;
  }

  DatabaseService._internal();

  Future<QuerySnapshot> getUsers() {
    return _firestore.collection("users").get();
  }

  Future<DocumentSnapshot> getUserById(String id) {
    return _firestore.collection("users").doc(id).get();
  }

  Future<void> addUser() async {
    await _firestore.collection("users").add({
      "email": "example@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "profilePicture": "",
      "conversations": List<String>(),
    }).then((value) => print("New user id: ${value.id}"));
  }

  Future<QuerySnapshot> getCategories() {
    return _firestore.collection("categories").get();
  }

  Stream<QuerySnapshot> getDecksByCategory(String name) async* {
    QuerySnapshot query = await _firestore
        .collection("categories")
        .where("name", isEqualTo: name)
        .limit(1)
        .get();
    String categoryId = query.docs.first.id;
    yield* _firestore
        .collection("categories")
        .doc(categoryId)
        .collection("decks")
        .snapshots();
  }

  Future<DocumentSnapshot> getCategoryById(String id) {
    return _firestore.collection("categories").doc(id).get();
  }

  Stream<QuerySnapshot> getQuestions(String cid) {
    return _firestore
        .collection("conversations/$cid/questions")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  Stream<QuerySnapshot> getConversations(User user) {
    Map<String, dynamic> u = {
      "firstName": user.firstName,
      "id": user.id,
      "lastName": user.lastName,
    };
    return _firestore
        .collection("conversations")
        .where("users", arrayContains: u)
        .orderBy("timestamp", descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getPlayingDeck(String cid) {
    return _firestore
        .collection("conversations")
        .doc(cid)
        .collection("decks")
        .where("completed", isEqualTo: false)
        .limit(1)
        .snapshots();
  }

  Future<void> addMessage(Conversation conversation, Message message,
      GeneratedQuestion question) async {
    // If question has been answered, addMessage adds a message to the "replies" array
    if (question.answered) {
      await _firestore
          .collection("conversations/${conversation.id}/questions")
          .doc(question.id)
          .update({
        "replies": FieldValue.arrayUnion([message.toMap()])
      }).then((value) => print("New reply created!"));
    }
    // Otherwise, addMessage adds a message to the "answers" array
    else {
      bool answered =
          (question.answers.length + 1 == conversation.users.length);
      // print(
      //     "Users: ${conversation.users.length}. Answers: ${question.answers.length + 1}. $answered.");
      await _firestore
          .collection("conversations/${conversation.id}/questions")
          .doc(question.id)
          .update({
        "answers": FieldValue.arrayUnion([message.toMap()]),
        "answered": answered,
      }).then((value) => print("New answer created!"));
    }
  }

  Future<DocumentSnapshot> addQuestion(String cid, GeneratedDeck deck) async {
    DateTime now = DateTime.now();
    DocumentReference newQuestionRef;
    // 1. Get the next question text
    DocumentSnapshot deckQuery = await _firestore
        .collection("categories/${deck.categoryID}/decks")
        .doc(deck.deckID)
        .get();
    String questionText =
        deckQuery.data()["questions"][deck.questionsGenerated];
    print(questionText);
    // 2. Prepare data to be added
    Map<String, dynamic> question = {
      "answered": false,
      "deck": deck.id,
      "deckName": deck.name,
      "totalQuestions": deck.totalQuestions,
      "color": deck.color.value,
      "number": deck.questionsGenerated + 1,
      "text": questionText,
      "timestamp": now,
    };
    // 3. Add question to conversations/questions subcollection
    await _firestore
        .collection("conversations/$cid/questions")
        .add(question)
        .then((value) async {
      print("New question added to conversations/questions! ${value.id}");
      newQuestionRef = value;
      // 4. Update "questionsGenerated" and "completed" fields in deck document
      await _firestore
          .collection("conversations/$cid/decks")
          .doc(deck.id)
          .update({
        "questionsGenerated": deck.questionsGenerated + 1,
        "completed": (deck.questionsGenerated + 1 == deck.totalQuestions)
      }).then((value) async {
        print("Deck document ${deck.id} updated!");
      });
    });
    return newQuestionRef.get();
  }
}
