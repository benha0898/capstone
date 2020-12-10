import 'package:CapstoneProject/screens/services/database.dart';
import 'package:CapstoneProject/theme/consts.dart';
import 'package:CapstoneProject/theme/flutter_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchFriends extends StatefulWidget {
  @override
  _SearchFriendsState createState() => _SearchFriendsState();
}

class _SearchFriendsState extends State<SearchFriends> {
  DatabaseMethods dbMethods = new DatabaseMethods();

  TextEditingController searchController = new TextEditingController();

  QuerySnapshot searchSnapshot;

  initiateSearch() {
    dbMethods.getUserbyEmail(searchController.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                username: searchSnapshot.docs[index].get('username'),
                email: searchSnapshot.docs[index].get('email'),
              );
            })
        : Container();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: MyTheme.mainColor,
        title: Text(
          'Search Friends',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: Container(
          child: Column(children: [
        Container(
          color: Colors.grey,
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "search email...",
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    print('start search');
                    initiateSearch();
                  }),
            ],
          ),
        ),
        searchList(),
      ])),
    );
  }
}

class SearchTile extends StatelessWidget {
  final String username;
  final String email;
  SearchTile({this.username, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: IconButton(
              icon: Icon(
                FlutterIcons.add_circle_outline,
                color: Colors.white,
              ),
              onPressed: () {
                print('add friend to invite list');
              },
            ),
          ),
          Spacer(),
          Column(
            children: [
              Text(
                username,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              Text(
                email,
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
