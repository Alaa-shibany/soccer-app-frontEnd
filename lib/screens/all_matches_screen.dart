import '/screens/admin_matches_screen.dart';
import '/screens/show_finished_match_scree.dart';
import '/screens/show_unfinshed_mathch_screen.dart';
import '/screens/start_match_screen.dart';
import '/server/auth_server.dart';
import '/widgets/app_bar_custom.dart';
import '/widgets/match_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/navigation_drawer.dart';

class AllMatchesScreen extends StatefulWidget {
  static const String routName = '/all-mathces-screen';
  const AllMatchesScreen({super.key});

  @override
  State<AllMatchesScreen> createState() => _AllMatchesScreenState();
}

class _AllMatchesScreenState extends State<AllMatchesScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  List<dynamic> _unFinishedMatches = [];
  List<dynamic> _finishedMatches = [];
  late TabController? controller;

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
    getUnFinishedMatches();
  }

  Future<void> getUnFinishedMatches() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).UnFinishedMatches();
      await Provider.of<AuthServer>(context, listen: false).FinishedMatches();
      setState(() {
        _unFinishedMatches =
            Provider.of<AuthServer>(context, listen: false).unFinishedMatches;
        _finishedMatches =
            Provider.of<AuthServer>(context, listen: false).finishedMatches;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  String getTitle() {
    if (AuthServer.userData == 'player') {
      return Provider.of<AuthServer>(context).user()!.name!;
    } else {
      if (AuthServer.userData == 'admin') {
        return 'Administrator';
      } else {
        return 'Guest';
      }
    }
  }

  String getSubtitle() {
    if (AuthServer.userData == 'player') {
      return 'player';
    } else {
      if (AuthServer.userData == 'admin') {
        return 'admin';
      } else {
        return 'guest';
      }
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
                AuthServer.userData == 'admin'
                    ? IconButton(
                        icon: const Icon(Icons.add_circle),
                        color: Colors.white,
                        onPressed: () {
                          print(_unFinishedMatches);
                          Navigator.of(context)
                              .pushNamed(AdminMatchesScreen.routName);
                        },
                      )
                    : const SizedBox(
                        width: 0,
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
            body: GestureDetector(
              onTap: () => print(_unFinishedMatches),
              child: Stack(
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
                      SizedBox(
                        height: mediaQuery.width / 40,
                      ),
                      TabsTeamInfo(
                          controller: controller, mediaQuery: mediaQuery),
                      SlidesForTabs(
                        mediaQuery: mediaQuery,
                        controller: controller,
                        finishedMatches: _finishedMatches,
                        unFinishedMatches: _unFinishedMatches,
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}

class SlidesForTabs extends StatelessWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
    required this.finishedMatches,
    required this.unFinishedMatches,
  });

  final Size mediaQuery;
  final TabController? controller;
  final List<dynamic> unFinishedMatches;
  final List<dynamic> finishedMatches;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: double.infinity,
        height: mediaQuery.height,
        child: TabBarView(
          controller: controller,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    finishedMatches.isEmpty
                        ? const SizedBox(
                            height: 0,
                          )
                        : Container(
                            padding: EdgeInsets.all(mediaQuery.width / 90),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: finishedMatches.length > 6
                                  ? 6
                                  : finishedMatches.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ShowFinishedMatchScreen.routName,
                                    arguments: finishedMatches.reversed
                                        .elementAt(index)['id'],
                                  );
                                },
                                child: MatchWidget(
                                  matchType: 1,
                                  teamLogoUrl1: finishedMatches.reversed
                                      .elementAt(index)['first_team']['logo'],
                                  teamLogoUrl2: finishedMatches.reversed
                                      .elementAt(index)['second_team']['logo'],
                                  teamName1: finishedMatches.reversed
                                      .elementAt(index)['first_team']['name'],
                                  teamName2: finishedMatches.reversed
                                      .elementAt(index)['second_team']['name'],
                                  center: Container(
                                    margin: EdgeInsets.only(
                                        top: mediaQuery.width / 70),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              Provider.of<AuthServer>(context,
                                                      listen: false)
                                                  .finishedMatches
                                                  .reversed
                                                  .elementAt(
                                                      index)['firstTeamScore']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      mediaQuery.width / 30),
                                            ),
                                            SizedBox(
                                              width: mediaQuery.width / 70,
                                            ),
                                            Text(
                                              ' - ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: mediaQuery.width / 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: mediaQuery.width / 70,
                                            ),
                                            Text(
                                              Provider.of<AuthServer>(context,
                                                      listen: false)
                                                  .finishedMatches
                                                  .reversed
                                                  .elementAt(
                                                      index)['secondTeamScore']
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: mediaQuery.width / 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          finishedMatches.reversed
                                              .elementAt(index)['date'],
                                          style: TextStyle(
                                              fontSize: mediaQuery.width / 50,
                                              color: const Color.fromARGB(
                                                  255, 49, 49, 49)),
                                        ),
                                        finishedMatches.reversed.elementAt(
                                                    index)['league'] ==
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
                                  ),
                                  user: AuthServer.userData!,
                                  customWidget: const SizedBox(
                                    width: 0,
                                  ),
                                  mediaQuery: mediaQuery,
                                ),
                              ),
                            ),
                          ),
                    SizedBox(
                      height: mediaQuery.width / 20,
                    ),
                    unFinishedMatches.isEmpty
                        ? const SizedBox(
                            height: 0,
                          )
                        : Container(
                            padding: EdgeInsets.all(mediaQuery.width / 40),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: unFinishedMatches.length > 10
                                  ? 10
                                  : unFinishedMatches.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ShowUnFinishedMatchScreen.routName,
                                    arguments: unFinishedMatches[index]['id'],
                                  );
                                },
                                child: MatchWidget(
                                  matchType: 1,
                                  teamLogoUrl1: unFinishedMatches[index]
                                      ['first_team']['logo'],
                                  teamLogoUrl2: unFinishedMatches[index]
                                      ['second_team']['logo'],
                                  teamName1: unFinishedMatches[index]
                                      ['first_team']['name'],
                                  teamName2: unFinishedMatches[index]
                                      ['second_team']['name'],
                                  center: Column(
                                    children: [
                                      Text(
                                        unFinishedMatches[index]['date'],
                                        style: TextStyle(
                                            fontSize: mediaQuery.height / 80,
                                            color: Colors.grey),
                                      ),
                                      unFinishedMatches[index]['league'] == 1
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
                                                arguments:
                                                    unFinishedMatches[index]
                                                        ['id']);
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
                ),
              ),
            ),
            finishedMatches.isEmpty
                ? const SizedBox(
                    height: 0,
                  )
                : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(mediaQuery.width / 40),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(15),
                                  bottomRight: Radius.circular(15)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black45,
                                  offset: Offset(0, 3),
                                  blurRadius: 8,
                                ),
                              ],
                            ),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: finishedMatches.length,
                              itemBuilder: (context, index) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ShowFinishedMatchScreen.routName,
                                    arguments: finishedMatches[index]['id'],
                                  );
                                },
                                child: MatchWidget(
                                  matchType: 1,
                                  teamLogoUrl1: finishedMatches.reversed
                                      .elementAt(index)['first_team']['logo'],
                                  teamLogoUrl2: finishedMatches.reversed
                                      .elementAt(index)['second_team']['logo'],
                                  teamName1: finishedMatches.reversed
                                      .elementAt(index)['first_team']['name'],
                                  teamName2: finishedMatches.reversed
                                      .elementAt(index)['second_team']['name'],
                                  center: Container(
                                    margin: EdgeInsets.only(
                                        top: mediaQuery.width / 70),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              Provider.of<AuthServer>(context,
                                                      listen: false)
                                                  .finishedMatches
                                                  .reversed
                                                  .elementAt(
                                                      index)['firstTeamScore']
                                                  .toString(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize:
                                                      mediaQuery.width / 30),
                                            ),
                                            SizedBox(
                                              width: mediaQuery.width / 70,
                                            ),
                                            Text(
                                              ' - ',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: mediaQuery.width / 30,
                                              ),
                                            ),
                                            SizedBox(
                                              width: mediaQuery.width / 70,
                                            ),
                                            Text(
                                              Provider.of<AuthServer>(context,
                                                      listen: false)
                                                  .finishedMatches
                                                  .reversed
                                                  .elementAt(
                                                      index)['secondTeamScore']
                                                  .toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: mediaQuery.width / 30,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          finishedMatches.reversed
                                              .elementAt(index)['date'],
                                          style: TextStyle(
                                              fontSize: mediaQuery.width / 50,
                                              color: const Color.fromARGB(
                                                  255, 49, 49, 49)),
                                        ),
                                        finishedMatches.reversed.elementAt(
                                                    index)['league'] ==
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
                                  ),
                                  user: AuthServer.userData!,
                                  customWidget: const SizedBox(
                                    width: 0,
                                  ),
                                  mediaQuery: mediaQuery,
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
      ),
    );
  }
}

class TabsTeamInfo extends StatefulWidget {
  const TabsTeamInfo({
    super.key,
    required this.controller,
    required this.mediaQuery,
  });
  final Size mediaQuery;

  final TabController? controller;

  @override
  State<TabsTeamInfo> createState() => _TabsTeamInfoState();
}

class _TabsTeamInfoState extends State<TabsTeamInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TabBar(
        controller: widget.controller,
        tabs: const [
          Tab(
            text: 'Home',
          ),
          Tab(
            text: 'Old matches',
          ),
        ],
      ),
    );
  }
}
