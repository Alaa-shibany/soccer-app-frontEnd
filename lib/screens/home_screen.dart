import 'package:soccer_app_frontend/models/images_url.dart';
import 'package:soccer_app_frontend/screens/part_tow_admin_screen.dart';
import 'package:soccer_app_frontend/screens/shop_screen.dart';
import 'package:soccer_app_frontend/screens/team_profile_screen.dart';

import '/models/league_part_settings.dart';
import '/screens/all_matches_screen.dart';
import '/screens/event_screen.dart';
import '/screens/part_one_admin_screen.dart';
import '/screens/user_profile_screen.dart';
import '/server/auth_server.dart';
import '/styles/app_text_styles.dart';
import '/widgets/bottom%20_bar_with_circles.dart';
import '../widgets/image_slider_widget.dart';
import '/widgets/finished_match_home_widget.dart';
import '/widgets/navigation_drawer.dart';
import 'package:iconsax/iconsax.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../styles/app_colors.dart';
import '../widgets/head_profile_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const String routName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = false;

  Future<void> data() async {
    setState(() {
      _isLoading = true;
    });
    print('////////////////////////////////////////////////////');
    // print(Provider.of<AuthServer>(context, listen: false)
    //     .leagueStatue()!
    //     .currentStage);
    print('////////////////////////////////////////////////////');
    try {
      await Provider.of<AuthServer>(context, listen: false).League();
      print(Provider.of<AuthServer>(context, listen: false)
          .leagueStatue()!
          .currentStage);
      setState(() {
        if (Provider.of<AuthServer>(context, listen: false)
                .leagueStatue()!
                .currentStage ==
            'PART ONE') {
          setState(() {
            LeaguePartSettings.isPartOneLocked = false;
          });
        } else if (Provider.of<AuthServer>(context, listen: false)
                .leagueStatue()!
                .currentStage ==
            'PART TWO') {
          setState(() {
            LeaguePartSettings.isPartOneLocked = false;
            LeaguePartSettings.isPartTowLocked = false;
          });
        } else if (Provider.of<AuthServer>(context, listen: false)
                .leagueStatue()!
                .currentStage ==
            'END OF LEAGUE') {
          LeaguePartSettings.isPartOneLocked = false;
          LeaguePartSettings.isPartTowLocked = false;
        }
      });
      await Provider.of<AuthServer>(context, listen: false).FinishedMatches();
      print(Provider.of<AuthServer>(context, listen: false).finishedMatches);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    data();
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
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ShopScreen(),
                      ));
                    },
                    icon: Icon(
                      Iconsax.shop5,
                      color: AppColors.mainColor,
                    ))
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
                Provider.of<AuthServer>(context, listen: false)
                            .leagueStatue()!
                            .currentStage ==
                        'END OF LEAGUE'
                    ? Lottie.asset(
                        width: double.infinity,
                        fit: BoxFit.fill,
                        'assets/lotties/celebrate.json')
                    : const SizedBox(
                        width: 0,
                      ),
                Consumer(
                  builder: (context, value, child) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          //this head widget for user name and image and grade
                          Container(
                            margin: EdgeInsets.only(
                                top: mediaQuery.height / 17,
                                left: mediaQuery.width / 5),
                            child: GestureDetector(
                              onTap: () {
                                AuthServer.userData == 'admin' ||
                                        AuthServer.userData == 'guest'
                                    ? Fluttertoast.showToast(
                                        msg:
                                            "Admin or guest don't have a profile to see",
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.black38,
                                        textColor: Colors.white,
                                        fontSize: 16.0)
                                    : Navigator.of(context).pushNamed(
                                        UserProfileScreen.routName,
                                        arguments: Provider.of<AuthServer>(
                                                context,
                                                listen: false)
                                            .user()!
                                            .id);
                              },
                              child: headProfileWidget(
                                profilePicture: AuthServer.userData == 'admin'
                                    ? null
                                    : AuthServer.userData == 'guest'
                                        ? null
                                        : Provider.of<AuthServer>(context,
                                                listen: false)
                                            .user()!
                                            .profilePicture,
                                name: AuthServer.userData == 'admin'
                                    ? 'Admin'
                                    : AuthServer.userData == 'guest'
                                        ? 'Guest'
                                        : Provider.of<AuthServer>(context,
                                                listen: false)
                                            .user()!
                                            .name
                                            .toString(),
                                subTitle: AuthServer.userData == 'admin'
                                    ? 'Admin'
                                    : AuthServer.userData == 'guest'
                                        ? 'Guest'
                                        : Provider.of<AuthServer>(context,
                                                listen: false)
                                            .user()!
                                            .position
                                            .toString(),
                                icon: const Icon(
                                  CupertinoIcons.person,
                                  size: 25,
                                ),
                                circleColor: AppColors.secondaryColor,
                                screenHight: mediaQuery.height,
                                screenWidth: mediaQuery.width,
                                nameColor: AppColors.mainColor,
                              ),
                            ),
                          ),

                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaQuery.width / 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Events',
                                  style: AppTextStyles.poppinsTitle,
                                )
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(EventScreen.routName);
                            },
                            child: ImageSliderWidget(
                              mediaQuery: mediaQuery,
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height / 30,
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: mediaQuery.width / 9),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Provider.of<AuthServer>(context, listen: false)
                                            .leagueStatue()!
                                            .currentStage ==
                                        'END OF LEAGUE'
                                    ? const Text(
                                        'Winners',
                                        style: TextStyle(
                                            color: Colors.amber,
                                            fontWeight: FontWeight.bold),
                                      )
                                    : Text(
                                        'Matches',
                                        style: AppTextStyles.poppinsTitle,
                                      ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(AllMatchesScreen.routName);
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                              ),
                              width: mediaQuery.height / 2.5,
                              height: mediaQuery.height / 6,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
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
                              child: Provider.of<AuthServer>(context,
                                              listen: false)
                                          .leagueStatue()!
                                          .currentStage ==
                                      'END OF LEAGUE'
                                  ? Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: 0.4,
                                          child: Image(
                                            image: const AssetImage(
                                                'assets/images/winners.png'),
                                            width: mediaQuery.width / 3,
                                            height: mediaQuery.height / 5,
                                          ),
                                        ),
                                        SizedBox(
                                          height: mediaQuery.height / 10,
                                          child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: AuthServer
                                                .leagueResponse['winners']
                                                .length,
                                            itemBuilder: (context, index) =>
                                                Container(
                                              margin: EdgeInsets.symmetric(
                                                  horizontal:
                                                      mediaQuery.width / 20),
                                              child: GestureDetector(
                                                onTap: () {
                                                  Navigator.of(context).pushNamed(
                                                      TeamProfileScreen
                                                          .routeName,
                                                      arguments: AuthServer
                                                                  .leagueResponse[
                                                              'winners'][index]
                                                          ['id']);
                                                },
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Image(
                                                      image: NetworkImage(
                                                        '${imagesUrl.url}${AuthServer.leagueResponse['winners'][index]['logo']}',
                                                      ),
                                                      height:
                                                          mediaQuery.height /
                                                              15,
                                                      width:
                                                          mediaQuery.width / 10,
                                                      alignment:
                                                          Alignment.center,
                                                    ),
                                                    Text(
                                                      AuthServer.leagueResponse[
                                                              'winners'][index]
                                                          ['name'],
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  : Provider.of<AuthServer>(context,
                                              listen: false)
                                          .finishedMatches
                                          .isNotEmpty
                                      ? FinishedMatchWidget(
                                          teamLogoUrl1: Provider.of<AuthServer>(
                                                  context,
                                                  listen: false)
                                              .finishedMatches
                                              .last['first_team']['logo'],
                                          teamName1: Provider.of<AuthServer>(
                                                  context,
                                                  listen: false)
                                              .finishedMatches
                                              .last['first_team']['name'],
                                          teamLogoUrl2: Provider.of<AuthServer>(
                                                  context,
                                                  listen: false)
                                              .finishedMatches
                                              .last['second_team']['logo'],
                                          teamName2: Provider.of<AuthServer>(
                                                  context,
                                                  listen: false)
                                              .finishedMatches
                                              .last['second_team']['name'],
                                          center: Container(
                                            margin: EdgeInsets.only(
                                                top: mediaQuery.width / 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      Provider.of<AuthServer>(
                                                              context,
                                                              listen: false)
                                                          .finishedMatches
                                                          .last[
                                                              'firstTeamScore']
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize:
                                                              mediaQuery.width /
                                                                  15),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          mediaQuery.width / 40,
                                                    ),
                                                    Text(
                                                      ' - ',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            mediaQuery.width /
                                                                15,
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          mediaQuery.width / 40,
                                                    ),
                                                    Text(
                                                      Provider.of<AuthServer>(
                                                              context,
                                                              listen: false)
                                                          .finishedMatches
                                                          .last[
                                                              'secondTeamScore']
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize:
                                                            mediaQuery.width /
                                                                15,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: mediaQuery.width / 90,
                                                ),
                                                Text(
                                                  Provider.of<AuthServer>(
                                                          context,
                                                          listen: false)
                                                      .finishedMatches
                                                      .last['date']
                                                      .toString(),
                                                ),
                                                Provider.of<AuthServer>(context,
                                                                listen: false)
                                                            .finishedMatches
                                                            .last['league'] ==
                                                        1
                                                    ? Row(
                                                        children: [
                                                          const Text(
                                                            'League',
                                                            style: TextStyle(
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        63,
                                                                        63,
                                                                        63)),
                                                          ),
                                                          Image(
                                                            image: const AssetImage(
                                                                'assets/images/matchLeague.png'),
                                                            height: mediaQuery
                                                                    .height /
                                                                70,
                                                          ),
                                                        ],
                                                      )
                                                    : const Text(
                                                        'Friendly',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    63,
                                                                    63,
                                                                    63)),
                                                      ),
                                              ],
                                            ),
                                          ),
                                          mediaQuery: mediaQuery,
                                          matchType: Provider.of<AuthServer>(
                                                  context,
                                                  listen: false)
                                              .finishedMatches
                                              .last['league'],
                                        )
                                      : Image.asset(
                                          'assets/images/start-soon.png',
                                          fit: BoxFit.fitWidth),
                            ),
                          ),
                          SizedBox(
                            height: mediaQuery.height / 20,
                          ),
                          BottomBarWithCircles(
                              isCircle2Locked:
                                  LeaguePartSettings.isPartTowLocked,
                              isCircle1Locked:
                                  LeaguePartSettings.isPartOneLocked),
                          AuthServer.userData == 'admin'
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                              PartOneAdminScreen.routeName);
                                        },
                                        child: const Text('part one lock')),
                                    SizedBox(
                                      width: mediaQuery.width / 6,
                                    ),
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) =>
                                                PartTwoScreen(),
                                          ));
                                        },
                                        child: const Text('part tow lock')),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                )
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
  }
}
