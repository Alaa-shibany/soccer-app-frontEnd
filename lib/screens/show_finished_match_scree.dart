import 'package:soccer_app_frontend/models/images_url.dart';

import '/screens/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../server/auth_server.dart';

class ShowFinishedMatchScreen extends StatefulWidget {
  static const String routName = '/show-finished-match-screen';
  const ShowFinishedMatchScreen({super.key});

  @override
  State<ShowFinishedMatchScreen> createState() =>
      _ShowFinishedMatchScreenState();
}

class _ShowFinishedMatchScreenState extends State<ShowFinishedMatchScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  Map<String, dynamic> viewMatchInfo = {};

  late TabController? controller;

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void initState() {
    controller = TabController(length: 2, vsync: this);
    super.initState();
    Future.delayed(Duration.zero).then((value) => getData());
  }

  Future<void> getData() async {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false)
          .viewMatchInfo(matchId: id);
      await Provider.of<AuthServer>(context, listen: false).League();
      setState(() {
        viewMatchInfo =
            Provider.of<AuthServer>(context, listen: false).viewMatchInfoMap;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        elevation: 0,
        actions: [
          AuthServer.userData == 'admin'
              ? IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Row(
                          children: [
                            Text(
                              'Admin things',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.admin_panel_settings,
                              color: Colors.amber,
                            )
                          ],
                        ),
                        content: const Text(
                            'Are you sure you want to delete this match ???'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Provider.of<AuthServer>(context, listen: false)
                                  .retreatMatchResults(
                                viewMatchInfo['id'].toString(),
                              );
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Center(
                                      child: Icon(
                                    Icons.info,
                                    color: Colors.amber,
                                    size: 45,
                                  )),
                                  content: Text(AuthServer.message),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('Cancle'))
                                  ],
                                ),
                              );
                            },
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancle'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.white,
                  ),
                )
              : const SizedBox(
                  height: 0,
                ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: <Widget>[
                InkWell(
                  onTap: () => print(viewMatchInfo),
                  child: Stack(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: mediaQuery.height / 4,
                        child: const Image(
                          image: AssetImage('assets/images/image_match.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Opacity(
                        opacity: 0.2,
                        child: Container(
                          width: double.infinity,
                          height: mediaQuery.height / 4,
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
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: mediaQuery.height / 4,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            //for first team image and name
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: NetworkImage(
                                    '${imagesUrl.url}${viewMatchInfo['firstTeam']['logo']}',
                                  ),
                                  height: mediaQuery.width / 6,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                                SizedBox(
                                  height: mediaQuery.width / 50,
                                ),
                                Text(
                                  viewMatchInfo['firstTeam']['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              width: mediaQuery.width / 10,
                            ),
                            //for info in the middle
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      viewMatchInfo['firstTeamScore']
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mediaQuery.width / 14),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.width / 50,
                                    ),
                                    Text(
                                      '-',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mediaQuery.width / 14),
                                    ),
                                    SizedBox(
                                      width: mediaQuery.width / 50,
                                    ),
                                    Text(
                                      viewMatchInfo['secondTeamScore']
                                          .toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: mediaQuery.width / 14),
                                    ),
                                  ],
                                ),
                                viewMatchInfo['league'] == 1
                                    ? Text(
                                        'League',
                                        style: TextStyle(
                                            fontSize: mediaQuery.height / 50,
                                            color: Colors.white),
                                      )
                                    : Text(
                                        'Friendly',
                                        style: TextStyle(
                                            fontSize: mediaQuery.height / 50,
                                            color: Colors.white),
                                      ),
                              ],
                            ),
                            SizedBox(
                              width: mediaQuery.width / 10,
                            ),
                            //for second team image and name
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image(
                                  image: NetworkImage(
                                    '${imagesUrl.url}${viewMatchInfo['secondTeam']['logo']}',
                                  ),
                                  height: mediaQuery.width / 6,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                                SizedBox(
                                  height: mediaQuery.width / 50,
                                ),
                                Text(
                                  viewMatchInfo['secondTeam']['name'],
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      const SizedBox(
                        width: double.infinity,
                        height: double.infinity,
                        child: Image(
                            image: AssetImage('assets/images/background.png'),
                            fit: BoxFit.fill),
                      ),
                      Column(
                        children: [
                          TabsTeamInfo(
                              controller: controller, mediaQuery: mediaQuery),
                          SlidesForTabs(
                              viewMatchInfo: viewMatchInfo,
                              mediaQuery: mediaQuery,
                              controller: controller)
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
    );
  }
}

class Circle extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;
  final Widget widget;

  Circle({required this.color, required this.onPressed, required this.widget});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 50,
        height: 50,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Center(
          child: widget,
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class SlidesForTabs extends StatelessWidget {
  SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
    required this.viewMatchInfo,
  });

  Map<String, dynamic> viewMatchInfo;
  final Size mediaQuery;
  final TabController? controller;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        controller: controller,
        children: [
          //Match slide for show info screen
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: mediaQuery.width / 60,
                ),
                //this container show the title of the container
                Container(
                  height: mediaQuery.width / 15,
                  margin:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width / 200),
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(left: mediaQuery.width / 20),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(37, 48, 106, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                //This container has the questions and the answers
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width / 200),
                  height: mediaQuery.height / 4,
                  padding: EdgeInsets.only(top: mediaQuery.width / 20),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: ShowQuestions(
                    viewMatchInfo: viewMatchInfo,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 50,
                ),
                //This container has the players who scored
                viewMatchInfo['goals'].isNotEmpty ||
                        viewMatchInfo['yellow_cards'].isNotEmpty ||
                        viewMatchInfo['red_cards'].isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.width / 90),
                        child: Row(
                          // mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //this for first team details
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: mediaQuery.width / 15,
                                  width: mediaQuery.width / 2.1,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: mediaQuery.width / 20),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(37, 48, 106, 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    viewMatchInfo['firstTeam']['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.height / 60,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mediaQuery.width / 200,
                                      vertical: mediaQuery.width / 200),
                                  padding: EdgeInsets.only(
                                      top: mediaQuery.width / 20,
                                      bottom: mediaQuery.width / 20),
                                  width: mediaQuery.width / 2.1,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // this a list of player who scored
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['goals'].length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['goals'][index]
                                                        ['team_id'] ==
                                                    viewMatchInfo[
                                                        'firstTeam_id']
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          image:
                                                              const AssetImage(
                                                            'assets/images/ball.png',
                                                          ),
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['goals']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                      //  this a list of player who got a yellow card
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['yellow_cards']
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['yellow_cards']
                                                            [index]['player']
                                                        ['team_id'] ==
                                                    viewMatchInfo[
                                                        'firstTeam_id']
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                          image: const AssetImage(
                                                              'assets/images/yellow_card.png'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['yellow_cards']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                      //this a list of player who got a red card
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['red_cards'].length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['red_cards']
                                                                    [index]
                                                                ['player']
                                                            ['team_id']
                                                        .toString() ==
                                                    viewMatchInfo[
                                                            'firstTeam_id']
                                                        .toString()
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          image: const AssetImage(
                                                              'assets/images/red_card.png'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['red_cards']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            //this for second team details
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  height: mediaQuery.width / 15,
                                  width: mediaQuery.width / 2.1,
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.only(
                                      left: mediaQuery.width / 20),
                                  decoration: const BoxDecoration(
                                    color: Color.fromRGBO(37, 48, 106, 1),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                  ),
                                  child: Text(
                                    viewMatchInfo['secondTeam']['name'],
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.height / 60,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: mediaQuery.width / 200,
                                      vertical: mediaQuery.width / 200),
                                  padding: EdgeInsets.only(
                                      top: mediaQuery.width / 20,
                                      bottom: mediaQuery.width / 20),
                                  width: mediaQuery.width / 2.1,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(15),
                                      bottomLeft: Radius.circular(15),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black45,
                                        offset: Offset(0, 3),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      // this a list of player who scored
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['goals'].length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['goals'][index]
                                                        ['team_id'] ==
                                                    viewMatchInfo[
                                                        'secondTeam_id']
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          image:
                                                              const AssetImage(
                                                            'assets/images/ball.png',
                                                          ),
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['goals']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                      //  this a list of player who got a yellow card
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['yellow_cards']
                                                  .length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['yellow_cards']
                                                            [index]['player']
                                                        ['team_id'] ==
                                                    viewMatchInfo[
                                                        'secondTeam_id']
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                          image: const AssetImage(
                                                              'assets/images/yellow_card.png'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['yellow_cards']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                      //this a list of player who got a red card
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: mediaQuery.width / 50),
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount:
                                              viewMatchInfo['red_cards'].length,
                                          itemBuilder: (context, index) {
                                            return viewMatchInfo['red_cards']
                                                                    [index]
                                                                ['player']
                                                            ['team_id']
                                                        .toString() ==
                                                    viewMatchInfo[
                                                            'secondTeam_id']
                                                        .toString()
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                20,
                                                        height:
                                                            mediaQuery.width /
                                                                20,
                                                        child: Image(
                                                          width:
                                                              mediaQuery.width /
                                                                  60,
                                                          height: mediaQuery
                                                                  .height /
                                                              60,
                                                          image: const AssetImage(
                                                              'assets/images/red_card.png'),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            mediaQuery.width /
                                                                80,
                                                      ),
                                                      Text(
                                                        viewMatchInfo['red_cards']
                                                                        [index]
                                                                    ['player']
                                                                ['name']
                                                            .toString(),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.end,
                                                        style: TextStyle(
                                                          fontSize: mediaQuery
                                                                  .height /
                                                              60,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : const SizedBox(
                                                    height: 0,
                                                  );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),

                //This container has the match ditails and the answers
                Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: mediaQuery.width / 200),
                  height: mediaQuery.height / 3.1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black45,
                        offset: Offset(0, 3),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: mediaQuery.width / 30,
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'Stadium',
                              style: TextStyle(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: mediaQuery.width / 90,
                            ),
                            const Icon(
                              Icons.location_pin,
                              color: Color.fromRGBO(37, 48, 106, 1),
                            )
                          ],
                        ),
                        trailing: Text(viewMatchInfo['place'].toString()),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'Date',
                              style: TextStyle(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: mediaQuery.width / 90,
                            ),
                            const Icon(
                              Icons.date_range_rounded,
                              color: Color.fromRGBO(37, 48, 106, 1),
                            )
                          ],
                        ),
                        trailing: Text(viewMatchInfo['date'].toString()),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'Stage',
                              style: TextStyle(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: mediaQuery.width / 90,
                            ),
                            const Icon(
                              Icons.assistant,
                              color: Color.fromRGBO(37, 48, 106, 1),
                            )
                          ],
                        ),
                        trailing: Text(viewMatchInfo['stage'].toString()),
                      ),
                      ListTile(
                        title: Row(
                          children: [
                            const Text(
                              'League',
                              style: TextStyle(
                                  color: Color.fromRGBO(37, 48, 106, 1),
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: mediaQuery.width / 90,
                            ),
                            Image(
                              image:
                                  const AssetImage('assets/images/league.png'),
                              height: mediaQuery.width / 20,
                            ),
                          ],
                        ),
                        trailing: viewMatchInfo['league'] == 1
                            ? const Text(
                                'League',
                              )
                            : const Text(
                                'Friendly',
                              ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          //Info slide for show info screen
          SingleChildScrollView(
            child: Column(
              children: [
                //for the first team
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  height: mediaQuery.height / 1.81,
                  width: double.infinity,
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
                            Image(
                              image: NetworkImage(
                                '${imagesUrl.url}${viewMatchInfo['firstTeam']['logo']}',
                              ),
                              height: mediaQuery.width / 11,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              width: mediaQuery.width / 30,
                            ),
                            Text(
                              '${viewMatchInfo['firstTeam']['name']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mediaQuery.height / 45),
                            ),
                          ],
                        ),
                      ),
                      //This for first team captain
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            UserProfileScreen.routName,
                            arguments: viewMatchInfo['firstTeam']['captain']
                                ['id'],
                          );
                        },
                        child: PlayerChangeDataCard(
                          name: viewMatchInfo['firstTeam']['captain']['name'],
                          mediaQuery: mediaQuery,
                          title:
                              '${viewMatchInfo['firstTeam']['captain']['name']}',
                          trailing: 'captain',
                        ),
                      ),
                      //This for first team goal keeper
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            UserProfileScreen.routName,
                            arguments: viewMatchInfo['firstTeam']['goalKeeper']
                                ['id'],
                          );
                        },
                        child: PlayerChangeDataCard(
                          name: viewMatchInfo['firstTeam']['goalKeeper']
                              ['name'],
                          mediaQuery: mediaQuery,
                          title:
                              '${viewMatchInfo['firstTeam']['goalKeeper']['name']}',
                          trailing: 'goalKeeper',
                        ),
                      ),
                      //This for attacker of first team
                      SizedBox(
                        height: mediaQuery.height / 2.9,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              viewMatchInfo['firstTeam']['attackers'].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                    UserProfileScreen.routName,
                                    arguments: viewMatchInfo['firstTeam']
                                        ['attackers'][index]['id']);
                              },
                              child: PlayerChangeDataCard(
                                  name: viewMatchInfo['firstTeam']['attackers']
                                      [index]['name'],
                                  mediaQuery: mediaQuery,
                                  title: viewMatchInfo['firstTeam']['attackers']
                                      [index]['name'],
                                  trailing: 'attackers'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                //for the second team
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  margin: const EdgeInsets.all(10),
                  height: mediaQuery.height / 1.81,
                  width: double.infinity,
                  child: Column(
                    children: [
                      //This for second team container
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
                            Image(
                              image: NetworkImage(
                                '${imagesUrl.url}${viewMatchInfo['secondTeam']['logo']}',
                              ),
                              height: mediaQuery.width / 11,
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              width: mediaQuery.width / 30,
                            ),
                            Text(
                              '${viewMatchInfo['secondTeam']['name']}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: mediaQuery.height / 45),
                            ),
                          ],
                        ),
                      ),
                      //This for second team captain
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            UserProfileScreen.routName,
                            arguments: viewMatchInfo['secondTeam']['captain']
                                ['id'],
                          );
                        },
                        child: PlayerChangeDataCard(
                          name: viewMatchInfo['secondTeam']['captain']['name'],
                          mediaQuery: mediaQuery,
                          title:
                              '${viewMatchInfo['secondTeam']['captain']['name']}',
                          trailing: 'captain',
                        ),
                      ),
                      //This for second team goal keeper
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            UserProfileScreen.routName,
                            arguments: viewMatchInfo['secondTeam']['goalKeeper']
                                ['id'],
                          );
                        },
                        child: PlayerChangeDataCard(
                          name: viewMatchInfo['secondTeam']['goalKeeper']
                              ['name'],
                          mediaQuery: mediaQuery,
                          title:
                              '${viewMatchInfo['secondTeam']['goalKeeper']['name']}',
                          trailing: 'goalKeeper',
                        ),
                      ),
                      //This for attacker of second team
                      Container(
                        height: mediaQuery.height / 2.9,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          primary: false,
                          shrinkWrap: true,
                          itemCount:
                              viewMatchInfo['secondTeam']['attackers'].length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  UserProfileScreen.routName,
                                  arguments: viewMatchInfo['secondTeam']
                                      ['attackers'][index]['id'],
                                );
                              },
                              child: PlayerChangeDataCard(
                                  name: viewMatchInfo['secondTeam']['attackers']
                                      [index]['name'],
                                  mediaQuery: mediaQuery,
                                  title: viewMatchInfo['secondTeam']
                                      ['attackers'][index]['name'],
                                  trailing: 'attackers'),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
      height: 30,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: TabBar(
        controller: widget.controller,
        tabs: const [
          Tab(
            text: 'Match',
          ),
          Tab(
            text: 'Players',
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ShowQuestions extends StatefulWidget {
  ShowQuestions({super.key, required this.viewMatchInfo});
  Map<String, dynamic> viewMatchInfo;
  @override
  State<ShowQuestions> createState() => _ShowQuestions();
}

class _ShowQuestions extends State<ShowQuestions>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  void changeQuestion(int newIndex) {
    setState(() {
      currentQuestionIndex = newIndex;
    });
  }

  int currentState = 1;

  int firstAnswer = 0;
  int secondAnswer = 0;
  int thirdAnswer = 0;
  int fourthAnswer = 0;

  bool circle1Q1Pressed = false;
  bool circle2Q1Pressed = false;
  bool circle3Q1Pressed = false;

  bool circle1Q2Pressed = false;
  bool circle2Q2Pressed = false;

  bool circle1Q3Pressed = false;
  bool circle2Q3Pressed = false;

  bool circle1Q4Pressed = false;
  bool circle2Q4Pressed = false;
  @override
  Widget build(BuildContext context) {
    List<String?> questions = [
      'Who will win?',
      Provider.of<AuthServer>(context, listen: false)
          .leagueStatue()!
          .predictionQuestion1!,
      Provider.of<AuthServer>(context, listen: false)
          .leagueStatue()!
          .predictionQuestion2!,
    ];

    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(questions[currentQuestionIndex]!,
                key: ValueKey<String>(questions[currentQuestionIndex]!),
                style: TextStyle(
                    fontSize: mediaQuery.width / 25,
                    fontWeight: FontWeight.bold)),
            transitionBuilder: (child, animation) {
              final inAnimation = Tween<Offset>(
                begin: const Offset(4.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              final outAnimation = Tween<Offset>(
                begin: const Offset(-4.0, 0.0),
                end: Offset.zero,
              ).animate(animation);

              return SlideTransition(
                position: currentState == 0 ? inAnimation : outAnimation,
                child: child,
              );
            },
          ),
          SizedBox(height: mediaQuery.width / 50),
          Stack(
            children: [
              currentQuestionIndex == 0
                  //first question
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Circle(
                                widget: Text(
                                  '1',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.width / 20),
                                ),
                                color:
                                    widget.viewMatchInfo['answer_winner'] == 1
                                        ? Colors.amber
                                        : Colors.grey,
                                onPressed: () {},
                              ),
                              Text(widget.viewMatchInfo['firstTeam']['name']),
                            ],
                          ),
                          Column(
                            children: [
                              Circle(
                                widget: Text(
                                  'X',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.width / 20),
                                ),
                                color:
                                    widget.viewMatchInfo['answer_winner'] == 0
                                        ? Colors.amber
                                        : Colors.grey,
                                onPressed: () {
                                  setState(() {});
                                },
                              ),
                              const Text('Draw')
                            ],
                          ),
                          Column(
                            children: [
                              Circle(
                                widget: Text(
                                  '2',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: mediaQuery.width / 20),
                                ),
                                color:
                                    widget.viewMatchInfo['answer_winner'] == 2
                                        ? Colors.amber
                                        : Colors.grey,
                                onPressed: () {},
                              ),
                              Text(widget.viewMatchInfo['secondTeam']['name']),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              currentQuestionIndex == 1
                  //second question
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Circle(
                                widget: const SizedBox(
                                  width: 0,
                                ),
                                color: widget.viewMatchInfo[
                                            'answerOfFirstQuestion'] ==
                                        1
                                    ? Colors.amber
                                    : Colors.grey,
                                onPressed: () {},
                              ),
                              const Text('Yes'),
                            ],
                          ),
                          Column(
                            children: [
                              Circle(
                                widget: const SizedBox(
                                  width: 0,
                                ),
                                color: widget.viewMatchInfo[
                                            'answerOfFirstQuestion'] !=
                                        1
                                    ? Colors.amber
                                    : Colors.grey,
                                onPressed: () {},
                              ),
                              const Text('No')
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
              currentQuestionIndex == 2
                  //third question
                  ? Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: mediaQuery.width / 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Circle(
                                widget: const SizedBox(
                                  width: 0,
                                ),
                                color: widget.viewMatchInfo[
                                            'answerOfSecondQuestion'] ==
                                        true
                                    ? Colors.amber
                                    : Colors.grey,
                                onPressed: () {},
                              ),
                              Text('Yes'),
                            ],
                          ),
                          Column(
                            children: [
                              Circle(
                                widget: const SizedBox(
                                  width: 0,
                                ),
                                color: widget.viewMatchInfo[
                                            'answerOfSecondQuestion'] ==
                                        false
                                    ? Colors.amber
                                    : Colors.grey,
                                onPressed: () {},
                              ),
                              Text('No')
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(
                      height: 0,
                    ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 50),
            child: Row(
              mainAxisAlignment: currentQuestionIndex == 0
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (currentQuestionIndex > 0)
                  TextButton(
                    onPressed: () {
                      changeQuestion(currentQuestionIndex - 1);
                      setState(() {
                        currentState = 1;
                      });
                    },
                    child: const Text(
                      'Previous',
                      style: TextStyle(color: Color.fromRGBO(37, 48, 106, 1)),
                    ),
                  ),
                const SizedBox(width: 20.0),
                currentQuestionIndex < questions.length - 1 &&
                        questions[currentQuestionIndex + 1] != null
                    ? TextButton(
                        onPressed: () {
                          changeQuestion(
                              (currentQuestionIndex + 1) % questions.length);
                          setState(() {
                            currentState = 0;
                          });
                        },
                        child: const Text(
                          'Next',
                          style: TextStyle(
                            color: Color.fromRGBO(37, 48, 106, 1),
                          ),
                        ),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class ShowQuestions1 extends StatefulWidget {
  ShowQuestions1({super.key, required this.viewMatchInfo});
  Map<String, dynamic> viewMatchInfo;
  @override
  State<ShowQuestions1> createState() => _ShowQuestions1();
}

class _ShowQuestions1 extends State<ShowQuestions1>
    with TickerProviderStateMixin {
  int currentQuestionIndex = 0;
  void changeQuestion(int newIndex) {
    setState(() {
      currentQuestionIndex = newIndex;
    });
  }

  int currentState = 1;

  int firstAnswer = 0;
  int secondAnswer = 0;
  int thirdAnswer = 0;
  int fourthAnswer = 0;

  bool circle1Q1Pressed = false;
  bool circle2Q1Pressed = false;
  bool circle3Q1Pressed = false;

  bool circle1Q2Pressed = false;
  bool circle2Q2Pressed = false;

  bool circle1Q3Pressed = false;
  bool circle2Q3Pressed = false;

  bool circle1Q4Pressed = false;
  bool circle2Q4Pressed = false;
  @override
  Widget build(BuildContext context) {
    List<String> questions = [
      'Who will win?',
      Provider.of<AuthServer>(context, listen: false)
          .leagueStatue()!
          .predictionQuestion1!,
      Provider.of<AuthServer>(context, listen: false)
          .leagueStatue()!
          .predictionQuestion2!,
    ];
    final mediaQuery = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: mediaQuery.width / 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(widget.viewMatchInfo['firstTeam']['name']),
                    SizedBox(width: mediaQuery.width / 30),
                    Expanded(
                      flex: (55 * 100).toInt(),
                      child: _buildAnimatedPercentageBar(
                          '55%', 0.55, Colors.amber),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Draw'),
                    SizedBox(width: mediaQuery.width / 30),
                    Expanded(
                      flex: (55 * 100).toInt(),
                      child:
                          _buildAnimatedPercentageBar('35%', 0.35, Colors.red),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(widget.viewMatchInfo['secondTeam']['name']),
                    SizedBox(width: mediaQuery.width / 30),
                    Expanded(
                      flex: (55 * 100).toInt(),
                      child: _buildAnimatedPercentageBar(
                          '20%', 0.1, Colors.purple),
                    ),
                  ],
                ),
              ],
            ),
          ),
          transitionBuilder: (child, animation) {
            final inAnimation = Tween<Offset>(
              begin: const Offset(4.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            final outAnimation = Tween<Offset>(
              begin: const Offset(-4.0, 0.0),
              end: Offset.zero,
            ).animate(animation);

            return SlideTransition(
              position: currentState == 0 ? inAnimation : outAnimation,
              child: child,
            );
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (currentQuestionIndex > 0)
                TextButton(
                  onPressed: () {
                    changeQuestion(currentQuestionIndex - 1);
                    setState(() {
                      currentState = 1;
                    });
                  },
                  child: const Text(
                    'Previous',
                    style: TextStyle(color: Color.fromRGBO(37, 48, 106, 1)),
                  ),
                ),
              const SizedBox(width: 20.0),
              currentQuestionIndex < questions.length - 1
                  ? TextButton(
                      onPressed: () {
                        changeQuestion(
                            (currentQuestionIndex + 1) % questions.length);
                        setState(() {
                          currentState = 0;
                        });
                      },
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Color.fromRGBO(37, 48, 106, 1),
                        ),
                      ),
                    )
                  : const SizedBox(
                      width: 0,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

class PlayerChangeDataCard extends StatefulWidget {
  PlayerChangeDataCard(
      {super.key,
      required this.mediaQuery,
      required this.title,
      required this.trailing,
      required this.name});

  final Size mediaQuery;
  final String name;
  // final int firstTeamScore ;
  // final int secondTeamScore;
  final String title;
  final String trailing;

  @override
  State<PlayerChangeDataCard> createState() => PlayerChangeDataCardState();
}

class PlayerChangeDataCardState extends State<PlayerChangeDataCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
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
        trailing: Text(widget.trailing),
      ),
    );
  }
}

Widget _buildAnimatedPercentageBar(
    String label, double targetPercentage, Color color) {
  return TweenAnimationBuilder(
    tween: Tween<double>(begin: 0, end: targetPercentage),
    duration: Duration(seconds: 1),
    builder: (BuildContext context, double percentage, Widget? child) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      );
    },
  );
}
