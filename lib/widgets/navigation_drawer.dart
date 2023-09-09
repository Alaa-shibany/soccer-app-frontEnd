import '/screens/all_matches_screen.dart';
import '/screens/auth_screen.dart';
import '/screens/home_screen.dart';
import '/screens/team_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/upload_flie_screen.dart';
import '../screens/user_profile_screen.dart';
import '../server/auth_server.dart';
import '../styles/app_colors.dart';
import 'head_profile_widget.dart';

class NavigationDrawerWidget extends StatefulWidget {
  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      // width: screenWidth / 2,
      child: row(mediaQuery),
    );
  }

  Widget row(Size mediaQuery) {
    return Row(
      children: [
        !isExpanded ? startMenuIcon(mediaQuery) : invisibleSubMenu(mediaQuery),
      ],
    );
  }

  Widget startMenuIcon(Size mediaQuery) {
    return Container(
      width: mediaQuery.width / 5,
      color: AppColors.mainColor,
      child: Column(
        children: [
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  isExpanded = true;
                });
              },
              icon: const Icon(
                Icons.format_list_bulleted_rounded,
                color: Colors.white,
                size: 35,
              )),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routName, (Route<dynamic> route) => false);
            },
            child: const circleIconWidget(
              color: Color.fromRGBO(254, 178, 91, 1),
              widget: Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 15,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AllMatchesScreen.routName);
            },
            child: const circleIconWidget(
                color: Color.fromRGBO(254, 91, 96, 1),
                widget: Image(
                  image: AssetImage('assets/images/leagueDrawer.png'),
                  height: 25,
                )),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () {
              AuthServer.userData == 'admin' || AuthServer.userData == 'guest'
                  ? Fluttertoast.showToast(
                      msg: "Admin or guest don't have a team profile to see",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 16.0)
                  : Navigator.of(context).pushNamed(TeamProfileScreen.routeName,
                      arguments: Provider.of<AuthServer>(context, listen: false)
                          .user()!
                          .team['id']);
            },
            child: const circleIconWidget(
              color: Color.fromRGBO(84, 179, 155, 1),
              widget: Image(
                image: AssetImage('assets/images/teamLogo.png'),
                height: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 5,
          ),
          GestureDetector(
            child: const Icon(
              Icons.info,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: const Divider(
              height: 10,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          AuthServer.userData == 'admin'
              ? InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, UploadFildScreen.routName);
                  },
                  child: const circleIconWidget(
                    color: Color.fromRGBO(97, 91, 254, 1),
                    widget: Icon(
                      Icons.upload,
                      color: Colors.white,
                      size: 25,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () async {
              final _per = await SharedPreferences.getInstance();
              _per.remove('token');
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  OnboardingScreen.routeName, (Route<dynamic> route) => false);
            },
            child: const circleIconWidget(
              color: Color.fromRGBO(97, 91, 254, 1),
              widget: Icon(
                Icons.logout,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget invisibleSubMenu(Size mediaQuery) {
    return Container(
      padding: EdgeInsets.only(left: mediaQuery.width / 20),
      width: mediaQuery.width / 1.5,
      color: AppColors.mainColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          GestureDetector(
            onTap: () {
              AuthServer.userData == 'admin' || AuthServer.userData == 'guest'
                  ? Fluttertoast.showToast(
                      msg: "Admin or guest don't have a profile to see",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 16.0)
                  : Navigator.of(context).pushNamed(UserProfileScreen.routName,
                      arguments: Provider.of<AuthServer>(context, listen: false)
                          .user()!
                          .id);
            },
            child: headProfileWidget(
              name: AuthServer.userData == 'admin'
                  ? 'Admin'
                  : AuthServer.userData == 'guest'
                      ? 'Guest'
                      : Provider.of<AuthServer>(context, listen: false)
                          .user()!
                          .name
                          .toString(),
              subTitle: AuthServer.userData == 'admin'
                  ? 'Admin'
                  : AuthServer.userData == 'guest'
                      ? 'Guest'
                      : Provider.of<AuthServer>(context, listen: false)
                          .user()!
                          .position
                          .toString(),
              icon: const Icon(
                CupertinoIcons.person,
                size: 25,
              ),
              circleColor: AppColors.secondaryColor,
              screenHight: mediaQuery.width,
              screenWidth: mediaQuery.height,
              nameColor: Colors.white,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routName, (Route<dynamic> route) => false);
            },
            child: circleIconWidget2(
              iconName: 'Home',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(254, 178, 91, 1),
              widget: const Icon(
                Icons.home,
                color: Colors.white,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 15,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(AllMatchesScreen.routName);
            },
            child: circleIconWidget2(
              iconName: 'All matches',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(254, 91, 96, 1),
              widget: const Image(
                image: AssetImage('assets/images/leagueDrawer.png'),
                height: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () {
              AuthServer.userData == 'admin' || AuthServer.userData == 'guest'
                  ? Fluttertoast.showToast(
                      msg: "Admin or guest don't have a team to see",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 16.0)
                  : Navigator.of(context).pushNamed(TeamProfileScreen.routeName,
                      arguments: Provider.of<AuthServer>(context, listen: false)
                          .user()!
                          .team['id']);
            },
            child: circleIconWidget2(
              iconName: 'Your team profile',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(84, 179, 155, 1),
              widget: const Image(
                image: AssetImage('assets/images/teamLogo.png'),
                height: 25,
              ),
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 5,
          ),
          Container(
            margin: EdgeInsets.only(left: mediaQuery.width / 40),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: const Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: mediaQuery.width / 20,
                ),
                const Text(
                  'About us',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Euclid Circular A'),
                )
              ],
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 20,
          ),
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: const Divider(
              height: 10,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          AuthServer.userData == 'admin'
              ? InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, UploadFildScreen.routName);
                  },
                  child: circleIconWidget2(
                    iconName: 'Up load data',
                    mediaQuery: mediaQuery,
                    color: const Color.fromRGBO(97, 91, 254, 1),
                    widget: const Icon(
                      Icons.upload,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
          SizedBox(
            height: mediaQuery.height / 40,
          ),
          InkWell(
            onTap: () async {
              final _per = await SharedPreferences.getInstance();
              _per.remove('token');
              // ignore: use_build_context_synchronously
              Navigator.of(context).pushNamedAndRemoveUntil(
                  OnboardingScreen.routeName, (Route<dynamic> route) => false);
            },
            child: circleIconWidget2(
              iconName: 'Log out',
              mediaQuery: mediaQuery,
              color: const Color.fromRGBO(97, 91, 254, 1),
              widget: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class circleIconWidget extends StatelessWidget {
  const circleIconWidget({
    super.key,
    required this.color,
    required this.widget,
  });

  final Color color;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Center(child: widget),
    );
  }
}

// ignore: camel_case_types
class circleIconWidget2 extends StatelessWidget {
  const circleIconWidget2({
    super.key,
    required this.color,
    required this.widget,
    required this.mediaQuery,
    required this.iconName,
  });

  final Color color;
  final Widget widget;
  final Size mediaQuery;
  final String iconName;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
            child: Center(child: widget),
          ),
          SizedBox(
            width: mediaQuery.width / 20,
          ),
          Text(
            iconName,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                fontFamily: 'Euclid Circular A'),
          )
        ],
      ),
    );
  }
}

class HeaderUser extends StatelessWidget {
  const HeaderUser({
    super.key,
    required this.mediaQuery,
    required this.title,
    required this.subtitle,
  });

  final Size mediaQuery;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(87, 101, 187, 1),
            Color.fromRGBO(37, 48, 106, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      width: double.infinity,
      height: mediaQuery.height / 4,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(bottom: 10, top: 10),
            height: mediaQuery.height / 15,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.person,
              color: Colors.white,
              size: mediaQuery.height / 20,
            ),
          ),
          SizedBox(
            height: mediaQuery.height / 150,
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}
