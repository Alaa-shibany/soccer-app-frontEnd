import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:soccer_app_frontend/screens/team_profile_screen.dart';
import 'package:soccer_app_frontend/server/auth_server.dart';
import 'package:soccer_app_frontend/styles/app_colors.dart';
import 'package:soccer_app_frontend/widgets/part_two_team_widget.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class TeamsPartTowScreen extends StatefulWidget {
  const TeamsPartTowScreen({super.key});

  @override
  State<TeamsPartTowScreen> createState() => _TeamsPartTowScreenState();
}

class _TeamsPartTowScreenState extends State<TeamsPartTowScreen> {
  bool _isLoading = false;
  Map<String, dynamic> partTowTeams = {};

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).partTowTeams();
      setState(() {
        partTowTeams = AuthServer.partTwoTeams;
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
            drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
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
                Center(
                  child: Lottie.asset(
                      width: mediaQuery.width / 3,
                      'assets/lotties/loading.json'),
                )
              ],
            ),
          )
        : Scaffold(
            extendBodyBehindAppBar: true,
            drawer: NavigationDrawerWidget(),
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
                const AppBarCustom(),
                Padding(
                  padding:
                      EdgeInsets.symmetric(vertical: mediaQuery.height / 8),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: mediaQuery.height / 20,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width / 30),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
                          child: const Center(
                            child: Text(
                              'Qualified teams ( 7 and 8 )',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: partTowTeams['7&8 League'].length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  TeamProfileScreen.routeName,
                                  arguments: partTowTeams['7&8 League'][index]
                                      ['id']);
                            },
                            child: PartTwoTeamWidget(
                              mediaQuery: mediaQuery,
                              logo: partTowTeams['7&8 League'][index]['logo'],
                              teamName: partTowTeams['7&8 League'][index]
                                  ['name'],
                              teamPoints: partTowTeams['7&8 League'][index]
                                      ['points']
                                  .toString(),
                            ),
                          ),
                        ),
                        Container(
                          height: mediaQuery.height / 20,
                          width: double.infinity,
                          margin: EdgeInsets.symmetric(
                              horizontal: mediaQuery.width / 30),
                          decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
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
                          child: const Center(
                            child: Text(
                              'Qualified teams ( 9 )',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          itemCount: partTowTeams['9 League'].length,
                          itemBuilder: (context, index) => GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  TeamProfileScreen.routeName,
                                  arguments: partTowTeams['9 League'][index]
                                      ['id']);
                            },
                            child: PartTwoTeamWidget(
                              mediaQuery: mediaQuery,
                              logo: partTowTeams['9 League'][index]['logo'],
                              teamName: partTowTeams['9 League'][index]['name'],
                              teamPoints: partTowTeams['9 League'][index]
                                      ['points']
                                  .toString(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
