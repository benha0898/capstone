import 'dart:async';
import 'dart:math';

import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/deck.dart';
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

  // Get all users, EXCEPT current user
  Future<QuerySnapshot> getUsers(String id) {
    return _firestore
        .collection("users")
        .where(FieldPath.documentId, isNotEqualTo: id)
        .get();
  }

  Future<DocumentSnapshot> getUserById(String id) {
    return _firestore.collection("users").doc(id).get();
  }

  Future<void> addUser(String uid, Map<String, dynamic> user) async {
    await _firestore.collection("users").doc(uid).set(user);
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

  Stream<DocumentSnapshot> getQuestion(String cid, String qid) {
    return _firestore
        .collection("conversations/$cid/questions")
        .doc(qid)
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
      }).then((_) async {
        print("New reply created!");
        await _firestore
            .collection("conversations")
            .doc(conversation.id)
            .update({
          "timestamp": message.timestamp,
        }).then((_) => print("Conversation doc ${conversation.id} updated!"));
      });
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
      }).then((_) async {
        print("New answer created!");
        await _firestore
            .collection("conversations")
            .doc(conversation.id)
            .update({
          "timestamp": message.timestamp,
        }).then((value) =>
                print("Conversation doc ${conversation.id} updated!"));
      });
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
    String questionText = deckQuery.data()["questions"]
        [deck.questionsOrder[deck.questionsGenerated]];
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
      "background": deck.background,
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
        print("Deck doc ${deck.id} updated!");
        await _firestore.collection("conversations").doc(cid).update({
          "timestamp": now,
        }).then((value) => print("Conversation doc $cid updated!"));
      });
    });
    return newQuestionRef.get();
  }

  Future<DocumentSnapshot> addDeck(String cid, Deck deck) async {
    DocumentReference newDeckRef;
    DateTime now = DateTime.now();
    // 1. Randomize the questions order
    List<int> questionsOrder =
        List<int>.generate(deck.questions.length, (index) => index);
    Random random = new Random(now.hashCode);
    questionsOrder.shuffle(random);
    print("New deck's questions order: $questionsOrder");

    // 2. Prepare data to be added
    Map<String, dynamic> generatedDeck = {
      "category": deck.category,
      "categoryID": deck.categoryID,
      "color": deck.color.value,
      "completed": false,
      "deckID": deck.id,
      "name": deck.name,
      "questionsGenerated": 0,
      "questionsOrder": questionsOrder,
      "timestamp": now,
      "totalQuestions": deck.questions.length,
      "background": deck.background,
    };

    // 3. Add generated deck to the conversation/decks subcollection
    await _firestore
        .collection("conversations/$cid/decks")
        .add(generatedDeck)
        .then((value) async {
      print("New deck added to conversations/decks! ${value.id}");
      newDeckRef = value;
      // 4. Update Conversation document fields
      await _firestore.collection("conversations").doc(cid).update({
        "lastActivity": deck.name,
        "timestamp": now,
        "color": deck.color.value,
      }).then((_) => print("Conversation doc $cid updated!"));
    });
    return newDeckRef.get();
  }

  Future<DocumentSnapshot> createConversation(List<User> members) async {
    DocumentReference conversationRef;
    // 1. Prepare conversation to be added
    DateTime now = DateTime.now();

    Map<String, dynamic> conversation = {
      "groupPicture": "",
      "lastActivity": "",
      "timestamp": now,
      "typing": {
        "isTyping": false,
      },
      "users":
          List.generate(members.length, (index) => members[index].infoShort),
    };

    // 2. Add conversation to Conversations collection
    await _firestore
        .collection("conversations")
        .add(conversation)
        .then((value) async {
      print("New conversation created! ${value.id}");
      conversationRef = value;
    });
    return conversationRef.get();
  }
}
