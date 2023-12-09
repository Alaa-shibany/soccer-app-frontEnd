import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:soccer_app_frontend/screens/show_unfinshed_mathch_screen.dart';
import 'package:soccer_app_frontend/screens/start_match_screen.dart';
import 'package:soccer_app_frontend/server/auth_server.dart';
import 'package:soccer_app_frontend/widgets/match_part_tow_widget.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class PartTwoMatchesScreen extends StatefulWidget {
  const PartTwoMatchesScreen({super.key});

  @override
  State<PartTwoMatchesScreen> createState() => _PartTwoMatchesScreenState();
}

class _PartTwoMatchesScreenState extends State<PartTwoMatchesScreen> {
  bool _isLoading = false;
  Map<String, dynamic> matches = {};

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).partTowMatches();
      setState(() {
        matches = AuthServer.partTowMatchesMap;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
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
                    Scaffold.of(this.context).openDrawer();
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
                const Positioned(
                  // top: 0,
                  child: AppBarCustom(),
                ),
                Center(
                  child: Lottie.asset(
                      width: mediaQuery.width / 3,
                      'assets/lotties/loading.json'),
                ),
              ],
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                  children: [
                    AppBarCustom(),
                    matches['unFinished'].isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height / 1.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Center(
                                  child:
                                      Text('Ops...No matches in part tow yet'),
                                ),
                                Center(
                                  child: Text(
                                    'Go back and do your homeworks',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize:
                                            MediaQuery.of(context).size.width /
                                                20),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: mediaQuery.width / 40,
                                vertical: mediaQuery.height / 80),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: matches['unFinished'].length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ShowUnFinishedMatchScreen.routName,
                                    arguments: matches['unFinished'][index]
                                        ['id'],
                                  );
                                },
                                child: MatchPartTowWidget(
                                  matchType: 1,
                                  teamLogoUrl1: matches['unFinished'][index]
                                      ['first_team']['logo'],
                                  teamLogoUrl2: matches['unFinished'][index]
                                      ['second_team']['logo'],
                                  teamName1: matches['unFinished'][index]
                                      ['first_team']['name'],
                                  teamName2: matches['unFinished'][index]
                                      ['second_team']['name'],
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        matches['unFinished'][index]['date'],
                                        style: TextStyle(
                                            fontSize: mediaQuery.height / 80,
                                            color: Colors.grey),
                                      ),
                                      matches['unFinished'][index]['league'] ==
                                              1
                                          ? Row(
                                              children: [
                                                Text(
                                                  'League',
                                                  style: TextStyle(
                                                      fontSize:
                                                          mediaQuery.height /
                                                              90,
                                                      color: Colors.grey),
                                                ),
                                                Image(
                                                  image: const AssetImage(
                                                      'assets/images/matchLeague.png'),
                                                  height:
                                                      mediaQuery.height / 70,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              'Friendly',
                                              style: TextStyle(
                                                  fontSize:
                                                      mediaQuery.height / 90,
                                                  color: Colors.grey),
                                            ),
                                    ],
                                  ),
                                  user: AuthServer.userData!,
                                  customWidget: ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                StartMatchScreen.routName,
                                                arguments: matches['unFinished']
                                                    [index]['id']);
                                      },
                                      child: SizedBox(
                                          width: mediaQuery.width / 10,
                                          height: mediaQuery.height / 35,
                                          child: const Text(
                                            'start',
                                            textAlign: TextAlign.center,
                                          ))),
                                  mediaQuery: mediaQuery,
                                ),
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
          );
  }
}
