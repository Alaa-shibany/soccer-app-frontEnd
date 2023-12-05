import 'package:soccer_app_frontend/screens/part_two_matches_screen.dart';

import '/screens/test.dart';
import '/widgets/app_bar_custom.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../server/auth_server.dart';
import '../widgets/navigation_drawer.dart';

class PartTowScreen extends StatefulWidget {
  static const routName = '/part-tow';
  const PartTowScreen({super.key});

  @override
  State<PartTowScreen> createState() => _PartTowScreenState();
}

class _PartTowScreenState extends State<PartTowScreen> {
  int index = 0;

  final screens = [
    const PartTwoMatchesScreen(),
    Test(),
    Test(),
    Test(),
  ];

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

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    final items = <Widget>[
      Padding(
        padding: EdgeInsets.all(mediaQuery.height / 90),
        child: Image(
          image: const AssetImage('assets/images/partTwoMatchesBtn.png'),
          height: mediaQuery.height / 30,
          fit: BoxFit.contain,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(mediaQuery.height / 90),
        child: Image(
          image: const AssetImage('assets/images/partTow7.png'),
          height: mediaQuery.height / 30,
          fit: BoxFit.contain,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(mediaQuery.height / 90),
        child: Image(
          image: const AssetImage('assets/images/partTow8.png'),
          height: mediaQuery.height / 30,
          fit: BoxFit.contain,
        ),
      ),
      Padding(
        padding: EdgeInsets.all(mediaQuery.height / 90),
        child: Image(
          image: const AssetImage('assets/images/partTow9.png'),
          height: mediaQuery.height / 30,
          fit: BoxFit.contain,
        ),
      ),
    ];

    return Scaffold(
      extendBody: true,
      drawer: NavigationDrawerWidget(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        child: CurvedNavigationBar(
            backgroundColor: Colors.transparent,
            color: const Color.fromRGBO(37, 48, 106, 1),
            animationCurve: Curves.easeInOut,
            height: mediaQuery.height / 17,
            animationDuration: Duration(milliseconds: 200),
            items: items,
            onTap: (index) {
              setState(() {
                this.index = index;
              });
              index == 3 ? _scaffoldKey.currentState?.openDrawer() : null;
            }),
      ),
      body: Stack(
        children: [
          AppBarCustom(),
          screens[index],
        ],
      ),
    );
  }
}
