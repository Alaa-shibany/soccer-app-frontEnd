import '/screens/part_one_screen.dart';
import '/screens/part_tow_screen.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBarWithCircles extends StatefulWidget {
  bool isCircle2Locked;
  bool isCircle1Locked;
  BottomBarWithCircles(
      {required this.isCircle2Locked, required this.isCircle1Locked});
  @override
  _BottomBarWithCirclesState createState() => _BottomBarWithCirclesState(
      isCircle2Locked: isCircle2Locked, isCircle1Locked: isCircle1Locked);
}

class _BottomBarWithCirclesState extends State<BottomBarWithCircles>
    with TickerProviderStateMixin {
  late AnimationController _controllerPartOne;
  late AnimationController _controllerPartTow;

  @override
  void initState() {
    super.initState();

    _controllerPartOne = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
    _controllerPartTow = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200),
    );
  }

  bool isCircle1Locked;
  bool isCircle2Locked;
  bool tapCircle1 = false;
  bool tapCircle2 = false;
  _BottomBarWithCirclesState(
      {required this.isCircle2Locked, required this.isCircle1Locked});

  Widget iconData = Icon(
    Icons.lock,
    size: 30,
    color: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    void _onCircle1Pressed() {
      _controllerPartOne.forward(from: 0);
      setState(() {
        tapCircle1 = true;
        tapCircle2 = false;
        iconData = Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(
              image: const AssetImage('assets/images/partOne.png'),
              height: mediaQuery.height / 30,
            ),
            const Text(
              'Part one',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        );
      });
    }

    void _onCircle2Pressed() {
      _controllerPartTow.forward(from: 0);
      setState(() {
        if (!isCircle2Locked) {
          tapCircle1 = false;
          tapCircle2 = true;
          iconData = Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: const AssetImage('assets/images/partTow.png'),
                height: mediaQuery.height / 30,
              ),
              const Text(
                'Part tow',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          );
        }
      });
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (tapCircle2 == true && tapCircle1 == false) {
                Navigator.of(context).pushNamed(PartTowScreen.routName);
              } else if (tapCircle1 == true && tapCircle2 == false) {
                Navigator.of(context).pushNamed(PartOneScreen.routeName);
              } else {
                null;
              }
            },
            child: Container(
                width: mediaQuery.width / 2,
                height: mediaQuery.height / 13,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(15)),
                  color: isCircle1Locked == false || isCircle2Locked == false
                      ? const Color.fromRGBO(37, 48, 106, 1)
                      : Colors.grey,
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: iconData),
          ),
          SizedBox(height: mediaQuery.height / 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: isCircle1Locked == false ? _onCircle1Pressed : null,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 0.9)
                      .animate(_controllerPartOne),
                  child: CircleAvatar(
                      radius: 30,
                      backgroundColor:
                          isCircle1Locked ? Colors.grey[400] : Colors.amber,
                      child: isCircle1Locked
                          ? const Icon(
                              Icons.lock,
                              color: Colors.white,
                            )
                          : Center(
                              child: Image(
                                image: const AssetImage(
                                  'assets/images/partOne.png',
                                ),
                                height: mediaQuery.height / 30,
                              ),
                            )),
                ),
              ),
              SizedBox(
                width: mediaQuery.width / 40,
              ),
              Container(
                width: mediaQuery.width / 20,
                height: mediaQuery.height / 200,
                color: isCircle2Locked ? Colors.grey[400] : Colors.amber,
              ),
              SizedBox(
                width: mediaQuery.width / 40,
              ),
              Container(
                width: mediaQuery.width / 20,
                height: mediaQuery.height / 200,
                color: isCircle2Locked ? Colors.grey[400] : Colors.amber,
              ),
              SizedBox(
                width: mediaQuery.width / 40,
              ),
              Container(
                width: mediaQuery.width / 20,
                height: mediaQuery.height / 200,
                color: isCircle2Locked ? Colors.grey[400] : Colors.amber,
              ),
              SizedBox(
                width: mediaQuery.width / 40,
              ),
              GestureDetector(
                onTap: isCircle2Locked == false ? _onCircle2Pressed : null,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 1, end: 0.9)
                      .animate(_controllerPartTow),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor:
                        isCircle2Locked ? Colors.grey[400] : Colors.amber,
                    child: isCircle2Locked
                        ? const Icon(
                            Icons.lock,
                            color: Colors.white,
                          )
                        : Center(
                            child: Image(
                              image: const AssetImage(
                                'assets/images/partTow.png',
                              ),
                              height: mediaQuery.height / 30,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controllerPartOne.dispose();
    _controllerPartTow.dispose();
    super.dispose();
  }
}
