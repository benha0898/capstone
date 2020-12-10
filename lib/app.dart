import 'package:CapstoneProject/models/user.dart';
import 'package:flutter/material.dart';

import 'theme/consts.dart';

import 'screens/browse_decks/browse_decks_screen.dart';
import 'screens/conversations/conversations_screen.dart';
import 'screens/settings/settings_screen.dart';

class CustomNavigatorHomePage extends StatefulWidget {
  const CustomNavigatorHomePage({Key key}) : super(key: key);

  @override
  _CustomNavigatorHomePageState createState() =>
      _CustomNavigatorHomePageState();
}

class _CustomNavigatorHomePageState extends State<CustomNavigatorHomePage> {
  User me;
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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final arguments =
        ModalRoute.of(context).settings.arguments as Map<String, dynamic>;
    me = arguments["me"];
    _screens = [
      BrowseDecksScreen(me: me),
      ConversationsScreen(me: me),
      SettingsScreen(me: me),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Container(
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
                label: "Browse Decks",
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
      ),
    );
  }
}
