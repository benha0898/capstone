class User {
  int id;
  String firstName;
  String lastName;

  User({this.id, this.firstName, this.lastName});

  String get name {
    return '$firstName $lastName';
  }

  static List<User> names = [
    User(id: 1, firstName: "Ben", lastName: "Ha"),
    User(id: 2, firstName: "Josephine", lastName: "Estudillo"),
    User(id: 3, firstName: "Jeffrey", lastName: "Davis"),
    User(id: 4, firstName: "Cam", lastName: "Macdonell"),
    User(id: 5, firstName: "Robert", lastName: "Andruchow"),
    User(id: 6, firstName: "Michelle", lastName: "Weremczuk"),
    User(id: 7, firstName: "Quinton", lastName: "Wong"),
    User(id: 8, firstName: "Rebecca", lastName: "Hardy"),
    User(id: 9, firstName: "Alex", lastName: "Anderson"),
    User(id: 10, firstName: "Bob", lastName: "Billy"),
    User(id: 11, firstName: "Christine", lastName: "Chang"),
  ];
}
