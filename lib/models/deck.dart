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
      name: "So Hey, Let's Be Friends",
      description:
          "Meeting new people? Skip the small talk and take a first step to building a great friendship with this deck of fun, non-weather-related questions!",
      questions: [
        "What are you doing right now?",
        "If you could go back to any age for a month, what would you choose?",
        "If you could have dinner with any person in the world, who would it be?",
        "If you were a food, what would you be?",
        "What are you interested in that most people aren't?",
        "Where is your favourite place?",
        "What is something you've never done, but have always wanted to do?",
        "What is something about you that people wouldn't expect from first meeting you?",
        "Would you want to know the future if you had the option to?",
        "How do you make yourself feel confident when you're nervous?",
      ],
    ),
    Deck(
      category: Category.family,
      name: "Family Album",
      description:
          "Take a trip down memory lane with your family members. Relive the experiences you all share together and how they shaped you as individuals and as a family.",
      questions: [
        "Is there a tendency or habit of mine that you with you could change?",
        "Was there an event or moment that radically changed the way you saw the world?",
        "What is the most trouble you've ever gotten into?",
        "What's the biggest lesson you've learned from each other?",
        "What event in the past made you grow the most?",
        "What's been on your mind lately?",
        "Where do you see yourself in five years?",
        "If you could grant our family one wish, what would it be and why?",
        "What's a memory from your childhood you never want to forget?",
      ],
    ),
    Deck(
      category: Category.family,
      name: "Things Unsaid",
      description:
          "Sometimes the things you want to say the most are the things you are most afraid to say. As a family, allow each other to express love and gratitude, as well as pain and shame, as a way to truly see one another as they are, as a way to heal.",
      questions: [
        "When was the last time you felt I was vulnerable with you?",
        "Describe the secret talent of everyone in our family?",
        "What is it about me that makes you feel I understand you?",
        "What experiences did you have as a child that you wish I had experienced as well?",
        "What are you hesitant to tell me?",
        "When do you think you inspired me?",
        "When was the last time the family misunderstood me and why?",
        "What is the question you know I don't want you to ask me? why?",
        "What makes our family unique and special?",
        "What do I do that makes you love me?",
      ],
    ),
    Deck(
      category: Category.couple,
      name: "At First Sight",
      description:
          "There is nothing quite like a newly bloomed relationship. The excitement of learning about each other, the passion, the new experiences. Explore this magical time together with these candid questions.",
      questions: [
        "What's the first thing you noticed about me that interests you?",
        "What do you really want to know about me?",
        "What do you value more in a person, their intent or their action?",
        "What do you think I prioritize, success or happiness? why?",
        "Why are you here with me now playing this game?",
        "If your ex were here, what would they warn me about dating you?",
        "What's something about you that will make me keep coming back for more?",
        "What do you think I have yet to learn about life?",
        "What do you think you can learn from me?",
        "How do you suggest we build this relationship?",
      ],
    ),
    Deck(
      category: Category.couple,
      name: "Til Death Do Us Part",
      description: "Deck description",
      questions: [
        "How have I changed since we first met?",
        "At what point did you realize you wanted to know me better?",
        "What about our relationship makes you really happy?",
        "In what ways is our relationship unhealthy?",
        "Are you satisfied with the amount of time we spend together?",
        "What are you too afraid to ask me, but really want to know the answer to?",
        "What are you most excited about at this stage of our relationship?",
        "What ways can I honor you more?",
        "Are you dealing with anything that I can help you with currently?",
        "How can we improve our intimacy or take it to the next level?",
      ],
    ),
    Deck(
      category: Category.couple,
      name: "For Better of For Worse",
      description: "Deck description",
      questions: [
        "As a husband/wife, how can I show more love/sensitivity to you?",
        "What’s your dream datenight or weekend with me?",
        "If you had three wishes to wish for our future, what would they be?",
        "What strengths do I bring to our relationship?",
        "Do you feel more emotionally connected than we did early in our relationship?",
        "What were some things we used to do before we were married that you miss now?",
        "What do I need to know most about you right now?",
        "How do you know that you love me?",
        "How do you know that I love you?",
        "What’s your favorite non-sex activity that we do together?",
      ],
    ),
  ];
}
