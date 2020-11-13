import 'package:CapstoneProject/models/deck.dart';
import 'package:CapstoneProject/models/category.dart';
import 'package:flutter/material.dart';

import 'package:CapstoneProject/core/consts.dart';

class BrowseDecksScreen extends StatefulWidget {
  @override
  _BrowseDecksScreenState createState() => _BrowseDecksScreenState();
}

class _BrowseDecksScreenState extends State<BrowseDecksScreen> {
  List<Deck> _decks = Deck.decks;
  List<bool> _viewSelections = [true, false];
  List<bool> _categorySelections;
  List<Category> _categories;
  Category _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categories = _decks.map((deck) => deck.category).toSet().toList();
    _categorySelections =
        List.generate(_categories.length, (index) => (index == 0));
    _selectedCategory = _categories[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.mainColor,
        title: Text(
          "Browse Decks",
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
        leading: TextButton(
          child: Text(
            "Sort by",
            style: TextStyle(
              color: AppColors.blueColor,
            ),
          ),
          onPressed: () {},
        ),
        leadingWidth: 70,
        actions: [
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              color: AppColors.blueColor,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                ToggleButtons(
                  selectedColor: AppColors.blueColor,
                  children: [
                    Icon(Icons.view_module_rounded),
                    Icon(Icons.view_list_rounded),
                  ],
                  isSelected: _viewSelections,
                  onPressed: (int index) {
                    setState(() {
                      for (var i = 0; i < _viewSelections.length; i++) {
                        _viewSelections[i] = (i == index);
                      }
                    });
                  },
                ),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: ToggleButtons(
                      renderBorder: false,
                      color: Colors.black38,
                      selectedColor: Colors.black,
                      fillColor: Colors.transparent,
                      children: List<Widget>.generate(
                        _categories.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _categories[index].name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      isSelected: _categorySelections,
                      onPressed: (int index) {
                        setState(() {
                          for (var i = 0; i < _categorySelections.length; i++) {
                            _categorySelections[i] = (i == index);
                          }
                          _selectedCategory = _categories[index];
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: _decks
                  .where((element) => element.category == _selectedCategory)
                  .length,
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                List<Deck> categoryDecks = _decks
                    .where((element) => element.category == _selectedCategory)
                    .toList();
                return Card(
                  child: InkWell(
                    onTap: () {
                      print(categoryDecks[index].name);
                      _showDeckDescription(context, categoryDecks[index]);
                    },
                    child: Text(
                      categoryDecks[index].name,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _showDeckDescription(BuildContext context, Deck deck) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              deck.name,
            ),
            content: Text(
              deck.description,
            ),
            actions: [
              FlatButton(
                child: Text("Back"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text("Invite Players"),
                onPressed: () {
                  print("TODO");
                },
              ),
            ],
          );
        });
  }
}
