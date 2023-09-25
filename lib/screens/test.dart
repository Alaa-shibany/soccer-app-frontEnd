import '/widgets/app_bar_custom.dart';
import '/widgets/soccer_table_league.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../server/auth_server.dart';
import '../server/dio.dart';
import '../widgets/navigation_drawer.dart';

class Test extends StatefulWidget {
  static const routName = '/test';

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  bool _isLoading = false;
  Map<String, dynamic> tabelInfo = {};
  List<dynamic> searchHistory = [];

  @override
  void initState() {
    super.initState();
    getDate();
  }

  getDate() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).TeamsTables();
      setState(() {
        _isLoading = false;
        tabelInfo = Provider.of<AuthServer>(context, listen: false)
            .teamTable()!
            .teamTable;
      });
    } catch (e) {
      print(e);
    }

    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/part1/teamsSearchSuggestions",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................TeamTablesSuggestion');
      print(response.data);
      print('................................');
      setState(() {
        searchHistory = response.data;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
  }

  // ignore: unused_field
  String _searchQuery = '';

  void _onSearchTextChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    // ignore: unused_local_variable
    double opacity = 150;
    return _isLoading
        ? Scaffold(
            extendBodyBehindAppBar: true,
            drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                CustomPaint(
                  //this for the background
                  size: Size(
                    mediaQuery.width,
                    mediaQuery.height,
                    // (screenWidth * 2.1434668500180276)
                    //     .toDouble()
                  ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: Background(),
                ),
                const AppBarCustom(),
                Center(
                  child: Lottie.asset(
                      width: mediaQuery.width / 3,
                      'assets/lotties/loading.json'),
                )
              ],
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(),
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: false,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                        context: context,
                        delegate: MySearchDelegate(
                            history:
                                searchHistory.map((e) => e.toString()).toList(),
                            tabelInfo: tabelInfo,
                            mediaQuery: mediaQuery));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                CustomPaint(
                  //this for the background
                  size: Size(
                    mediaQuery.width,
                    mediaQuery.height,
                    // (screenWidth * 2.1434668500180276)
                    //     .toDouble()
                  ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: Background(),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.only(top: 20, bottom: 50),
                  itemCount: tabelInfo.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: SoccerTableLeague(
                        id: -1,
                        mediaQuery: mediaQuery,
                        leagueName: tabelInfo.keys.elementAt(index),
                        teams: tabelInfo.values.elementAt(index),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: mediaQuery.height / 20,
                ),
              ],
            ),
          );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> history;
  Map<String, dynamic> tabelInfo;
  Size mediaQuery;
  String myNewKey = '';

  MySearchDelegate(
      {required this.mediaQuery,
      required this.history,
      required this.tabelInfo});
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return tabelInfo.keys.contains(query)
        ? SoccerTableLeague(
            leagueName: query,
            teams: tabelInfo[query],
            mediaQuery: mediaQuery,
            id: -1)
        : const Center(child: Text('No result found'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? history
        : history.where(
            (element) => element.toLowerCase().contains(query.toLowerCase()));
    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.search),
          title: Text(suggestionsList.elementAt(index)),
          onTap: () {
            query = suggestionsList.elementAt(index);
            showResults(context);
          },
        );
      },
    );
  }
}
