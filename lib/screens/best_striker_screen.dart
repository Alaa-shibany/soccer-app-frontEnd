import '/screens/user_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../server/auth_server.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class BestStrikerScreen extends StatefulWidget {
  const BestStrikerScreen({super.key});

  @override
  State<BestStrikerScreen> createState() => _BestStrikerScreenState();
}

class _BestStrikerScreenState extends State<BestStrikerScreen> {
  bool _isLoading = false;
  List<dynamic> bestStrikersList = [];
  List<dynamic> searchHistory = [];
  Map<String, dynamic> tabelInfo = {};

  @override
  void initState() {
    super.initState();
    getBestStrikers();
  }

  Future<void> getBestStrikers() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).BestStriker();
      setState(() {
        bestStrikersList = Provider.of<AuthServer>(context, listen: false)
            .BestStrikerM()!
            .bestStrikerList;
        for (int i = 0; i < bestStrikersList.length; i++) {
          searchHistory.add(bestStrikersList[i]['name']);
        }

        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
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
                            bestStrikersList: bestStrikersList,
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
                Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          height: mediaQuery.height / 18,
                          margin: EdgeInsets.only(
                              right: mediaQuery.width / 20,
                              left: mediaQuery.width / 20,
                              top: mediaQuery.width / 12),
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(255, 0, 0, 0)
                                    .withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: const ListTile(
                            title: Text(
                              'player name',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                            trailing: Text(
                              'goals',
                              style: TextStyle(
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.only(
                                  top: mediaQuery.height / 25,
                                  bottom: mediaQuery.height / 11),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: bestStrikersList.length <= 20
                                    ? bestStrikersList.length
                                    : 20,
                                itemBuilder: (context, index) =>
                                    GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        UserProfileScreen.routName,
                                        arguments: bestStrikersList[index]
                                            ['id']);
                                  },
                                  child: PlayerForTeam(
                                    subtitle: bestStrikersList[index]['team']
                                        ['name'],
                                    mediaQuery: mediaQuery,
                                    name: bestStrikersList[index]['name'],
                                    goals: bestStrikersList[index]['goals']
                                        .toString(),
                                    number: (index + 1).toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
  }
}

// ignore: must_be_immutable
class PlayerForTeam extends StatelessWidget with ChangeNotifier {
  PlayerForTeam({
    super.key,
    required this.mediaQuery,
    required this.name,
    required this.goals,
    required this.number,
    required this.subtitle,
  });

  final Size mediaQuery;
  final String name;
  final String goals;
  final String number;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin: const EdgeInsets.only(right: 15, left: 15, top: 12),
          width: double.infinity,
          height: mediaQuery.height / 15,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(37, 48, 106, 1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            height: mediaQuery.height,
            margin: EdgeInsets.only(left: mediaQuery.width / 20),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/userHader.png'))),
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.height / 60,
              ),
            ),
          ),
        ),
        Container(
          height: mediaQuery.height / 14,
          margin:
              EdgeInsets.only(right: 15, left: mediaQuery.width / 6, top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              height: mediaQuery.height / 20,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(37, 48, 106, 1),
                child: Container(
                  padding: const EdgeInsets.all(1),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      CupertinoIcons.person,
                      color: Color.fromRGBO(37, 48, 106, 1),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                  color: Color.fromRGBO(37, 48, 106, 1),
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              subtitle,
              style: const TextStyle(
                color: Color.fromRGBO(37, 48, 106, 100),
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                    image: const AssetImage('assets/images/ball.png'),
                    height: mediaQuery.height / 40),
                SizedBox(
                  width: mediaQuery.width / 40,
                ),
                Text(
                  goals,
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> history;
  Map<String, dynamic> tabelInfo;
  List<dynamic> bestStrikersList;
  Map<String, dynamic> resultPlayer = {};
  Size mediaQuery;
  String myNewKey = '';
  int index = 0;

  MySearchDelegate(
      {required this.mediaQuery,
      required this.bestStrikersList,
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
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    for (int i = 0; i < bestStrikersList.length; i++) {
      index = i + 1;
      if (bestStrikersList[i]['name'] == query) {
        resultPlayer = bestStrikersList[i];
        break;
      }
    }
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(UserProfileScreen.routName,
            arguments: resultPlayer['id']);
      },
      child: PlayerForTeam(
        subtitle: resultPlayer['team']['name'],
        mediaQuery: mediaQuery,
        name: resultPlayer['name'],
        goals: resultPlayer['goals'].toString(),
        number: (index).toString(),
      ),
    );
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
          leading: const Icon(Icons.search),
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
