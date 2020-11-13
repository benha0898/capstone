enum Category {
  friends,
  family,
  couple,
}

extension CategoryExtension on Category {
  String get name {
    switch (this) {
      case Category.friends:
        return "Friends";
      case Category.family:
        return "Family";
      case Category.couple:
        return "Couple";
      default:
        return "Other";
    }
  }
}
