import 'package:CapstoneProject/screens/services/search_screen.dart';
import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:flutter/material.dart';

class DeckViewScreen extends StatefulWidget {
  final Deck deck;

  const DeckViewScreen({Key key, this.deck}) : super(key: key);

  @override
  _DeckViewScreenState createState() => _DeckViewScreenState();
}

class _DeckViewScreenState extends State<DeckViewScreen> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
      content: SingleChildScrollView(
        child: AspectRatio(
          aspectRatio: 5 / 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                widget.deck.name,
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                widget.deck.description,
              ),
            ],
          ),
        ),
      ),
      actionsPadding: EdgeInsets.symmetric(horizontal: 8.0),
      actions: [
        RaisedButton(
          color: MyTheme.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Text("Select"),
          onPressed: () {
            print("open invite friends screen");
            Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (_) => SearchScreen(
                  deck: widget.deck,
                ),
                  ));
          },
        ),
      ],
    );
  }

  // _showDeckDescription(BuildContext context, Deck deck) {
  //   showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: Text(
  //             deck.name,
  //           ),
  //           content: Text(
  //             deck.description,
  //           ),
  //           actions: [
  //             FlatButton(
  //               child: Text("Back"),
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //               },
  //             ),
  //             FlatButton(
  //               child: Text("Invite Players"),
  //               onPressed: () {
  //                 print("TODO");
  //               },
  //             ),
  //           ],
  //         );
  //       });
  // }
}
