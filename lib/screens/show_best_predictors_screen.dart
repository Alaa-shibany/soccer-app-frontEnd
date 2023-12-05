import 'package:soccer_app_frontend/models/images_url.dart';

import '/server/auth_server.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class showBestPredictorEvetnScreen extends StatefulWidget {
  const showBestPredictorEvetnScreen({super.key});

  @override
  State<showBestPredictorEvetnScreen> createState() =>
      _showBestPredictorEvetnScreenState();
}

class _showBestPredictorEvetnScreenState
    extends State<showBestPredictorEvetnScreen>
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
      await Provider.of<AuthServer>(context, listen: false).getTopPredictors();

      print('........................................adsfasdfasdfaddafs');
      print(AuthServer.topPredictors);
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
                    SingleChildScrollView(
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
                                  'Top predictors',
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
                            height: mediaQuery.height / 100.2,
                          ),
                          SizedBox(
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              itemCount: AuthServer.topPredictors.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {},
                                  child: PlayerChangeDataCard(
                                      profilePicture:
                                          AuthServer.topPredictors[index]
                                              ['profilePicture'],
                                      subTitle: AuthServer.topPredictors[index]
                                          ['team']['name'],
                                      name: AuthServer.topPredictors[index]
                                          ['name'],
                                      mediaQuery: mediaQuery,
                                      title: AuthServer.topPredictors[index]
                                          ['name'],
                                      trailing: AuthServer.topPredictors[index]
                                              ['prediction']
                                          .toString()),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ));
  }
}

class PlayerChangeDataCard extends StatefulWidget {
  PlayerChangeDataCard({
    super.key,
    required this.mediaQuery,
    required this.title,
    required this.subTitle,
    required this.trailing,
    required this.name,
    required this.profilePicture,
  });

  final Size mediaQuery;
  final String name;
  // final int firstTeamScore ;
  // final int secondTeamScore;
  final String title;
  final String subTitle;
  final String trailing;
  final String? profilePicture;
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
          child: widget.profilePicture == null
              ? const Icon(
                  Icons.person,
                )
              : ClipRRect(
                  borderRadius: BorderRadius.circular(360),
                  child: Image(
                    image: NetworkImage(
                      '${imagesUrl.url}${widget.profilePicture}',
                    ),
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
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
