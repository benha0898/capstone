class Message {
  Map<String, String> sender;
  String text;
  DateTime timestamp;

  Message({this.sender, this.text, timestamp})
      : this.timestamp = timestamp ?? DateTime.now();

  Message.fromMap(Map<String, dynamic> map) {
    this.sender = Map<String, String>.from(map["sender"]);
    this.text = map["text"];
    this.timestamp = map["timestamp"].toDate();
  }

  Map<String, dynamic> toMap() => {
        "sender": {
          "id": this.sender["id"],
          "firstName": this.sender["firstName"],
          "lastName": this.sender["lastName"],
          "profilePicture": this.sender["profilePicture"],
        },
        "text": this.text,
        "timestamp": DateTime.now(),
      };
}
