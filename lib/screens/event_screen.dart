import '/models/Event.dart';
import '/screens/show_best_player_screen.dart';
import '/screens/show_best_predictors_screen.dart';
import '/widgets/app_bar_custom.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/navigation_drawer.dart';

class EventScreen extends StatefulWidget {
  static const String routName = '/event-screen';
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<Event> data = [
    Event(imagePath: 'assets/images/show1.png', title: 'Best players'),
    Event(imagePath: 'assets/images/show2.png', title: 'Best predictors'),
    Event(imagePath: 'assets/images/show0.png', title: 'The all stars'),
  ];
  int index = 1;
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
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
            children: [
              AppBarCustom(),
              Stack(
                children: [
                  Container(
                    height: mediaQuery.height / 2,
                    margin: EdgeInsets.only(top: mediaQuery.height / 6),
                    child: ScrollSnapList(
                        itemBuilder: _buildListItem,
                        itemCount: data.length,
                        itemSize: mediaQuery.width / 1.5,
                        dynamicItemSize: true,
                        onItemFocus: (index) {}),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: mediaQuery.height / 1.6),
                    alignment: Alignment.center,
                    height: mediaQuery.height / 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(87, 101, 187, 1),
                          Color.fromRGBO(37, 48, 106, 1),
                        ],
                        begin: Alignment.bottomLeft,
                        end: Alignment.topRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 0, 0, 0)
                              .withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset:
                              const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: const Image(
                      image: AssetImage(
                        'assets/images/ball.png',
                      ),
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(BuildContext context, int index) {
    final event = data[index];
    final mediaQuery = MediaQuery.of(context).size;

    return SizedBox(
      width: mediaQuery.width / 1.5,
      height: mediaQuery.height / 2,
      child: GestureDetector(
        onTap: () {
          index == 0
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => showBestPlayerEvetnScreen()))
              : index == 1
                  ? Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => showBestPredictorEvetnScreen()))
                  : Fluttertoast.showToast(
                      msg: "This event is not available right now",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.black38,
                      textColor: Colors.white,
                      fontSize: 16.0);
        },
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            side: BorderSide(
              width: 2,
              color: Color.fromRGBO(37, 48, 106, 1),
            ),
          ),
          elevation: 2,
          borderOnForeground: true,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            child: Column(
              children: [
                SizedBox(
                  width: mediaQuery.width / 1.5,
                  height: mediaQuery.height / 2.5,
                  child: index == 0
                      ? Image.asset(
                          event.imagePath,
                          fit: BoxFit.fill,
                        )
                      : Image.asset(
                          event.imagePath,
                          fit: BoxFit.cover,
                        ),
                ),
                SizedBox(
                  height: mediaQuery.height / 50,
                ),
                Text(
                  event.title,
                  style: TextStyle(
                      fontSize: mediaQuery.height / 50,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
