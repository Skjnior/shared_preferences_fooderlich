import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../colors.dart';
import '../widgets/custom_dropdown.dart';
// TODO: Add imports

class RecipeList extends StatefulWidget {
  const RecipeList({Key? key}) : super(key: key);

  @override
  _RecipeListState createState() => _RecipeListState();
}

class _RecipeListState extends State<RecipeList> {
  // TODO: Add key
  static const String preSearchKey = 'previousSearches';
  late TextEditingController searchTextController;
  final ScrollController _scrollController = ScrollController();
  List currentSearchList = [];
  int currentCount = 0;
  int currentStartPosition = 0;
  int currentEndPosition = 20;
  int pageCount = 20;
  bool hasMore = false;
  bool loading = false;
  bool inErrorState = false;
  // TODO: Add searches array
  List<String> previousSearches = <String>[];

  @override
  void initState() {
    super.initState();
    // TODO: Call getPreviousSearches
    getPreviousSearches();

    searchTextController = TextEditingController(text: '');
    _scrollController
      .addListener(() {
        final triggerFetchMoreSize =
            0.7 * _scrollController.position.maxScrollExtent;

        if (_scrollController.position.pixels > triggerFetchMoreSize) {
          if (hasMore &&
              currentEndPosition < currentCount &&
              !loading &&
              !inErrorState) {
            setState(() {
              loading = true;
              currentStartPosition = currentEndPosition;
              currentEndPosition =
                  min(currentStartPosition + pageCount, currentCount);
            });
          }
        }
      });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  // TODO: Add savePreviousSearches
  void savePreviousSearches()  async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(preSearchKey, previousSearches);
}

void getPreviousSearches() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(preSearchKey)) {
      final searches = prefs.getStringList(preSearchKey);
      if(searches != null) {
        previousSearches = searches;
      } else {
        previousSearches = <String>[];
      }
    }
}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildSearchCard(),
            _buildRecipeLoader(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0))),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Row(
          children: [
            // Replace
            IconButton(
              onPressed: () {
                startSearch(searchTextController.text);
                final currentFocus = FocusScope.of(context);
                if(!currentFocus.hasPrimaryFocus) {
                  currentFocus.unfocus();
                }
              },
                icon: const Icon(
                    Icons.search
                ),
            ),
            const SizedBox(
              width: 6.0,
            ),
            /// *** Start Replace
            Expanded(
              child: Row(
                children: <Widget>[
                  Expanded(
                    // 3
                      child: TextField(
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Search'),
                        autofocus: false,
                      // 4
                      textInputAction: TextInputAction.done,
                        // 5
                        onSubmitted: (value) {
                          if (!previousSearches.contains(value)) {
                            previousSearches.add(value);
                            savePreviousSearches();
                          }
                        },
                        controller: searchTextController,
                      )),
                  // 6
                  PopupMenuButton<String>(
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: lightGrey,
                    ),
                    // 7
                    onSelected: (String value) {
                      searchTextController.text = value;
                      startSearch(searchTextController.text);
                    },
                    itemBuilder: (BuildContext context) {
                      // 8
                      return previousSearches
                          .map<CustomDropdownMenuItem<String>>((String
                      value) {
                        return CustomDropdownMenuItem<String>(
                          text: value,
                          value: value,
                          callback: () {
                            setState(() {
                              // 9
                              previousSearches.remove(value);
                              Navigator.pop(context);
                            });
                          },
                        );
                      }).toList();
                    },
                  ),
                ],
              ),
            ),
            /// *** End Replace
          ],
        ),
      ),
    );
  }

  // TODO: Add startSearch
  void startSearch(String value) {
    setState(() {
      currentSearchList.clear();
      currentCount = 0;
      currentEndPosition = pageCount;
      currentStartPosition = 0;
      value = value.trim();

      if(!previousSearches.contains(value)) {
        previousSearches.add(value);
        savePreviousSearches();
      }
    });
  }

  Widget _buildRecipeLoader(BuildContext context) {
    if (searchTextController.text.length < 3) {
      return Container();
    }
    // Show a loading indicator while waiting for the movies
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
