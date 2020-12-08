import 'package:CapstoneProject/models/conversation.dart';
import 'package:CapstoneProject/models/user.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/screens/services/search_screen.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class DeckViewScreen extends StatefulWidget {
  final Deck deck;
  final User me;
  final Conversation conversation;

  const DeckViewScreen({Key key, this.deck, this.me, this.conversation})
      : super(key: key);

  @override
  _DeckViewScreenState createState() => _DeckViewScreenState();
}

class _DeckViewScreenState extends State<DeckViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AlertDialog(
          backgroundColor: widget.deck.color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
                highlightColor: Colors.transparent,
                icon: Icon(
                  Icons.arrow_back_ios_sharp,
                  color: MyTheme.mainColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ),
          content: Stack(
            children: [
              SingleChildScrollView(
                child: AspectRatio(
                  aspectRatio: 5 / 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        widget.deck.name,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.deck.description,
                      ),
                      SizedBox(height: 20),
                      (widget.conversation != null)
                          ? Stack(
                              children: [
                                FractionallySizedBox(
                                  widthFactor: 1.0,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: MyTheme.whiteColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                    ),
                                    child: Text(
                                      "Use Deck",
                                      style: TextStyle(
                                        fontSize: 22.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)),
                                      onTap: () {
                                        print("Hello");
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : RaisedButton(
                              color: MyTheme.whiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Text("Select"),
                              onPressed: () {
                                print("open invite friends screen");
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (_) => SearchScreen(
                                    deck: widget.deck,
                                  ),
                                ));
                              }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
