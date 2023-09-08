import '/server/auth_server.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class showBestPlayerEvetnScreen extends StatefulWidget {
  const showBestPlayerEvetnScreen({super.key});

  @override
  State<showBestPlayerEvetnScreen> createState() =>
      _showBestPlayerEvetnScreenState();
}

class _showBestPlayerEvetnScreenState extends State<showBestPlayerEvetnScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  bool _isLoading = false;

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).getTopStrikers();
      await Provider.of<AuthServer>(context, listen: false).getTopAssistants();
      await Provider.of<AuthServer>(context, listen: false).getTopDefenders();
      await Provider.of<AuthServer>(context, listen: false).getTopHonor();
      await Provider.of<AuthServer>(context, listen: false).getTopGoalKeepers();
      print('........................................adsfasdfasdfaddafs');
      print(AuthServer.topAssisstants);
      setState(() {
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
                const AppBarCustom(),
                ListView(
                  children: [
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
                    Container(
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
                      margin: const EdgeInsets.all(10),
                      height: mediaQuery.height / 2.6,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //This for first team container
                            Container(
                              height: mediaQuery.width / 8,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top Strikers',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mediaQuery.height / 50),
                                  ),
                                ],
                              ),
                            ),
                            //This for top attacker
                            SizedBox(
                              height: mediaQuery.height / 60,
                            ),
                            SizedBox(
                              height: mediaQuery.height / 3.5,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: AuthServer.topStriker.length > 3
                                    ? 3
                                    : AuthServer.topStriker.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: PlayerChangeDataCard(
                                        subTitle: AuthServer.topStriker[index]
                                            ['team']['name'],
                                        name: AuthServer.topStriker[index]
                                            ['name'],
                                        mediaQuery: mediaQuery,
                                        title: AuthServer.topStriker[index]
                                            ['name'],
                                        trailing: AuthServer.topStriker[index]
                                                ['goals']
                                            .toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
                    Container(
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
                      margin: const EdgeInsets.all(10),
                      height: mediaQuery.height / 2.6,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //This for first team container
                            Container(
                              height: mediaQuery.width / 8,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top Assistants',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mediaQuery.height / 50),
                                  ),
                                ],
                              ),
                            ),
                            //This for top attacker
                            SizedBox(
                              height: mediaQuery.height / 60,
                            ),
                            SizedBox(
                              height: mediaQuery.height / 3.5,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: AuthServer.topAssisstants.length > 3
                                    ? 3
                                    : AuthServer.topAssisstants.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: PlayerChangeDataCard(
                                        subTitle:
                                            AuthServer.topAssisstants[index]
                                                ['team']['name'],
                                        name: AuthServer.topAssisstants[index]
                                            ['name'],
                                        mediaQuery: mediaQuery,
                                        title: AuthServer.topAssisstants[index]
                                            ['name'],
                                        trailing: AuthServer
                                            .topAssisstants[index]['assists']
                                            .toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
                    Container(
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
                      margin: const EdgeInsets.all(10),
                      height: mediaQuery.height / 2.6,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //This for first team container
                            Container(
                              height: mediaQuery.width / 8,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top goalKeepers',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mediaQuery.height / 50),
                                  ),
                                ],
                              ),
                            ),
                            //This for top attacker
                            SizedBox(
                              height: mediaQuery.height / 60,
                            ),
                            SizedBox(
                              height: mediaQuery.height / 3.5,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: AuthServer.topGoalKeeper.length > 3
                                    ? 3
                                    : AuthServer.topGoalKeeper.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: PlayerChangeDataCard(
                                        subTitle:
                                            AuthServer.topGoalKeeper[index]
                                                ['team']['name'],
                                        name: AuthServer.topGoalKeeper[index]
                                            ['name'],
                                        mediaQuery: mediaQuery,
                                        title: AuthServer.topGoalKeeper[index]
                                            ['name'],
                                        trailing: AuthServer
                                            .topGoalKeeper[index]['saves']
                                            .toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
                    Container(
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
                      margin: const EdgeInsets.all(10),
                      height: mediaQuery.height / 2.6,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //This for first team container
                            Container(
                              height: mediaQuery.width / 8,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top defenders',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mediaQuery.height / 50),
                                  ),
                                ],
                              ),
                            ),
                            //This for top attacker
                            SizedBox(
                              height: mediaQuery.height / 60,
                            ),
                            SizedBox(
                              height: mediaQuery.height / 3.5,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: AuthServer.topDefenders.length > 3
                                    ? 3
                                    : AuthServer.topDefenders.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: PlayerChangeDataCard(
                                        subTitle: AuthServer.topDefenders[index]
                                            ['team']['name'],
                                        name: AuthServer.topDefenders[index]
                                            ['name'],
                                        mediaQuery: mediaQuery,
                                        title: AuthServer.topDefenders[index]
                                            ['name'],
                                        trailing: AuthServer.topDefenders[index]
                                                ['defences']
                                            .toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: mediaQuery.height / 50,
                    ),
                    Container(
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
                      margin: const EdgeInsets.all(10),
                      height: mediaQuery.height / 2.6,
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //This for first team container
                            Container(
                              height: mediaQuery.width / 8,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                  )),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Top honor',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: mediaQuery.height / 50),
                                  ),
                                ],
                              ),
                            ),
                            //This for top attacker
                            SizedBox(
                              height: mediaQuery.height / 60,
                            ),
                            SizedBox(
                              height: mediaQuery.height / 3.5,
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                primary: false,
                                shrinkWrap: true,
                                itemCount: AuthServer.topHonor.length > 3
                                    ? 3
                                    : AuthServer.topHonor.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {},
                                    child: PlayerChangeDataCard(
                                        subTitle: AuthServer.topHonor[index]
                                            ['team']['name'],
                                        name: AuthServer.topHonor[index]
                                            ['name'],
                                        mediaQuery: mediaQuery,
                                        title: AuthServer.topHonor[index]
                                            ['name'],
                                        trailing: AuthServer.topHonor[index]
                                                ['honor']
                                            .toString()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ));
  }
}

class PlayerChangeDataCard extends StatefulWidget {
  PlayerChangeDataCard(
      {super.key,
      required this.mediaQuery,
      required this.title,
      required this.subTitle,
      required this.trailing,
      required this.name});

  final Size mediaQuery;
  final String name;
  // final int firstTeamScore ;
  // final int secondTeamScore;
  final String title;
  final String subTitle;
  final String trailing;

  @override
  State<PlayerChangeDataCard> createState() => PlayerChangeDataCardState();
}

class PlayerChangeDataCardState extends State<PlayerChangeDataCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        subtitle: Text(
          widget.subTitle,
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
        leading: Container(
          width: widget.mediaQuery.width / 9,
          height: widget.mediaQuery.width / 9,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black45,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
          child: const Icon(
            Icons.person,
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        trailing: Text(
          widget.trailing,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: widget.mediaQuery.height / 50),
        ),
      ),
    );
  }
}
