import 'package:cloud_firestore/cloud_firestore.dart';

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

  Future<QuerySnapshot> getConversations() {
    return _firestore.collection("categories").get();
  }

  Future<DocumentSnapshot> getCategoryById(String id) {
    return _firestore.collection("categories").doc(id).get();
  }
}
