import 'package:CapstoneProject/models/user.dart';
import 'package:flutter/material.dart';

import 'theme/consts.dart';

import 'screens/browse_decks/browse_decks_screen.dart';
import 'screens/conversations/conversations_screen.dart';
import 'screens/settings/settings_screen.dart';

class CustomNavigatorHomePage extends StatefulWidget {
  final User me;

  const CustomNavigatorHomePage({Key key, this.me}) : super(key: key);

  @override
  _CustomNavigatorHomePageState createState() =>
      _CustomNavigatorHomePageState();
}

class _CustomNavigatorHomePageState extends State<CustomNavigatorHomePage> {
  int _currentIndex = 0;
  List<Widget> _screens;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _screens = [
      BrowseDecksScreen(me: widget.me),
      ConversationsScreen(me: widget.me),
      SettingsScreen(me: widget.me),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: MyTheme.backgroundImage,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _screens[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) => onTabTapped(index),
          backgroundColor: MyTheme.darkColor,
          currentIndex: _currentIndex,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: MyTheme.yellowColor,
          unselectedItemColor: Colors.white24,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.view_carousel_rounded),
              label: "Decks",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_rounded),
              label: "Conversations",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: "Settings",
            )
          ],
        ),
      ),
    );
  }
}
