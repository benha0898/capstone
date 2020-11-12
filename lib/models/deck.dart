import 'package:CapstoneProject/models/category.dart';

class Deck {
  final Category category;
  final String name;
  final String description;
  final List<String> questions;

  Deck({this.category, this.name, this.description, this.questions});

  static List<Deck> decks = [
    Deck(
      category: Category.friends,
      name: "Besties Edition",
      description: "This is a deck for the bestest of friends!",
      questions: [
        "Question 1",
        "Question 2",
        "Question 3",
      ],
    ),
    Deck(
      category: Category.friends,
      name: "New Friends Edition",
      description: "Nice to meet you, where've you been?",
      questions: [
        "Question 1",
        "Question 2",
        "Question 3",
        "Question 4",
        "Question 5",
      ],
    ),
    Deck(
      category: Category.family,
      name: "Mom & Son Edition",
      description: "Deck description",
      questions: [
        "Question 1",
        "Question 2",
        "Question 3",
        "Question 4",
      ],
    ),
    Deck(
      category: Category.couple,
      name: "Long Distance Edition",
      description: "Deck description",
      questions: [
        "Question 1",
        "Question 2",
        "Question 3",
      ],
    ),
  ];
}
