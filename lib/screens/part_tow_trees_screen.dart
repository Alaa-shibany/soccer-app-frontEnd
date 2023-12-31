import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:soccer_app_frontend/screens/tree_screen.dart';

import 'package:soccer_app_frontend/widgets/tree_btn_widget.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class PartTowTreesScreen extends StatefulWidget {
  const PartTowTreesScreen({super.key});
  static const String routeName = '/part-tow-grade-7-screen';

  @override
  State<PartTowTreesScreen> createState() => _PartTowTreesScreenState();
}

class _PartTowTreesScreenState extends State<PartTowTreesScreen> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
          SingleChildScrollView(
            child: Column(
              children: [
                const AppBarCustom(),
                SizedBox(
                  height: mediaQuery.height / 10,
                ),
                TreeButtonWidget(
                  mediaQuery: mediaQuery,
                  btnText: 'Grade 7 tree',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const TreeScreen(grade: '7', tree: '7'),
                    ));
                  },
                ),
                SizedBox(
                  height: mediaQuery.height / 30,
                ),
                TreeButtonWidget(
                  mediaQuery: mediaQuery,
                  btnText: 'Grade 8 tree',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const TreeScreen(grade: '8', tree: '8'),
                    ));
                  },
                ),
                SizedBox(
                  height: mediaQuery.height / 30,
                ),
                TreeButtonWidget(
                  mediaQuery: mediaQuery,
                  btnText: 'Grade 7 & 8 tree',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const TreeScreen(
                        grade: '7&8',
                        tree: '10',
                      ),
                    ));
                  },
                ),
                SizedBox(
                  height: mediaQuery.height / 30,
                ),
                TreeButtonWidget(
                  mediaQuery: mediaQuery,
                  btnText: 'Grade 9 tree',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          const TreeScreen(grade: '9', tree: '9'),
                    ));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
