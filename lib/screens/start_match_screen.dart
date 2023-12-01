import 'package:soccer_app_frontend/models/images_url.dart';

import '/models/map_player_result.dart';
import '/screens/all_matches_screen.dart';
import '/server/auth_server.dart';
import '/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StartMatchScreen extends StatefulWidget {
  static const String routName = '/start-match-screen';
  StartMatchScreen({super.key});

  @override
  State<StartMatchScreen> createState() => _StartMatchScreenState();
}

class _StartMatchScreenState extends State<StartMatchScreen>
    with TickerProviderStateMixin {
  int teamOneScore = 0;
  int teamTowScore = 0;

  int captain1Score = 0;
  int captain2Score = 0;

  int goalKeeper1Score = 0;
  int goalKeeper2Score = 0;

  Map<String, List<int>> playerResult = {
    'firstTeamGoals': [],
    'secondTeamGoals': [],
  };

  double _containerHeight1 = 100.0;
  double _containerHeight2 = 100.0;
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  bool _isExpandedPlayer = false;
  bool _isLoading = false;
  Map<String, dynamic> mathcInfoForAdmin = {};
  List<dynamic> attackers1 = [];
  List<dynamic> attackers2 = [];
  List<int> zeroList1 = [];
  List<int> zeroList2 = [];
  PlayerChangeDataCardState plyerData = PlayerChangeDataCardState();

  void _toggleContainerPlayer() {
    setState(() {
      _isExpandedPlayer = !_isExpandedPlayer;
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getMatchInfo();
  }

  void initState() {
    super.initState();
    getMatchInfo();
    teamOneScore = 0;
  }

  teamOneAdd() {
    teamOneScore++;
  }

  Future<void> getMatchInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final id = ModalRoute.of(context)!.settings.arguments as int;
      await Provider.of<AuthServer>(context, listen: false)
          .ViewMatchInfoForAdmin(id);
      setState(() {
        mathcInfoForAdmin =
            Provider.of<AuthServer>(context, listen: false).mathcInfoForAdmin;
        attackers1 = mathcInfoForAdmin['firstTeam']['attackers'];
        attackers2 = mathcInfoForAdmin['secondTeam']['attackers'];
        zeroList1 = List.generate(attackers1.length, (index) => 0);
        zeroList2 = List.generate(attackers2.length, (index) => 0);

        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  bool firstTeamScoredFirst = false;

  Future<void> declearMatch() async {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<AuthServer>(context, listen: false).DeclearMatchResult(
        matchId: id,
        playerResult: MapPlayerResult.playerResult,
        firstTeamScoredFirst: firstTeamScoredFirst,
      );
      setState(() {
        MapPlayerResult.playerResultName['firstTeamGoals']!.clear();
        MapPlayerResult.playerResultName['secondTeamGoals']!.clear();
        MapPlayerResult.playerResultName['yellowCards']!.clear();
        MapPlayerResult.playerResultName['assists']!.clear();
        MapPlayerResult.playerResultName['redCards']!.clear();
        MapPlayerResult.playerResultName['honor']!.clear();
        MapPlayerResult.playerResultName['saves']!.clear();
        MapPlayerResult.playerResultName['defense']!.clear();
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      MapPlayerResult.playerResultName['firstTeamGoals']!.clear();
      MapPlayerResult.playerResultName['secondTeamGoals']!.clear();
      MapPlayerResult.playerResultName['yellowCards']!.clear();
      MapPlayerResult.playerResultName['assists']!.clear();
      MapPlayerResult.playerResultName['redCards']!.clear();
      MapPlayerResult.playerResultName['honor']!.clear();
      MapPlayerResult.playerResultName['saves']!.clear();
      MapPlayerResult.playerResultName['defense']!.clear();
    }
  }

  void _toggleContainer1(Size mediaQuery) {
    setState(() {
      _isExpanded1 = !_isExpanded1;
      _isExpanded2 = false;
      _containerHeight2 = mediaQuery.height / 10;
      _containerHeight1 =
          _isExpanded1 ? mediaQuery.height / 2 : mediaQuery.height / 10;
    });
  }

  void _toggleContainer2(Size mediaQuery) {
    setState(() {
      _isExpanded2 = !_isExpanded2;
      _isExpanded1 = false;
      _containerHeight1 = mediaQuery.height / 10;
      _containerHeight2 =
          _isExpanded2 ? mediaQuery.height / 2 : mediaQuery.height / 10;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                print(MapPlayerResult.playerResult);
              },
              icon: const Icon(
                Icons.done,
                color: Colors.white,
              ))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AdminMatchHeader(
                      mediaQuery: mediaQuery,
                      mathcInfoForAdmin: mathcInfoForAdmin,
                      teamOneScore: teamOneScore,
                      teamTowScore: teamTowScore),
                  SizedBox(
                    height: mediaQuery.height / 1.6,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //for the first team
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                            curve: Curves.easeInOut,
                            height: _containerHeight1,
                            width: double.infinity,
                            child: _isExpanded1
                                ? SingleChildScrollView(
                                    child: Column(children: [
                                      //This for first team container
                                      GestureDetector(
                                        onTap: () =>
                                            _toggleContainer1(mediaQuery),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: mediaQuery.height / 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: NetworkImage(
                                                  '${imagesUrl.url}${mathcInfoForAdmin['firstTeam']['logo']}',
                                                ),
                                                height: mediaQuery.width / 9,
                                                fit: BoxFit.contain,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                width: mediaQuery.width / 30,
                                              ),
                                              Text(
                                                '${mathcInfoForAdmin['firstTeam']['name']}',
                                                style: TextStyle(
                                                    color: const Color.fromRGBO(
                                                        37, 48, 106, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        mediaQuery.height / 40),
                                              ),
                                              IconButton(
                                                  onPressed: () =>
                                                      _toggleContainer1(
                                                          mediaQuery),
                                                  icon: const Icon(
                                                    Icons.arrow_drop_up,
                                                    color: Colors.black,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                      //This for first team captain
                                      PlayerChangeDataCard(
                                        name: mathcInfoForAdmin['firstTeam']
                                            ['captain']['name'],
                                        teamNumber: 1,
                                        id: mathcInfoForAdmin['firstTeam']
                                            ['captain']['id'],
                                        playersGoals:
                                            playerResult['firstTeamGoals']!,
                                        goalWidget: ListTile(
                                          title: Text('Goals'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  if (teamOneScore != 0)
                                                    teamOneScore--;
                                                  if (captain1Score != 0) {
                                                    captain1Score--;
                                                    MapPlayerResult
                                                        .playerResult[
                                                            'firstTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                'firstTeam']
                                                            ['captain']['id']);
                                                    MapPlayerResult
                                                        .playerResultName[
                                                            'firstTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                    'firstTeam']
                                                                ['captain']
                                                            ['name']);
                                                  }
                                                }),
                                                icon: Icon(Icons.remove),
                                              ),
                                              Text(captain1Score.toString()),
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  teamOneScore++;
                                                  captain1Score++;
                                                  MapPlayerResult.playerResult[
                                                          'firstTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'firstTeam']
                                                          ['captain']['id']);
                                                  MapPlayerResult
                                                      .playerResultName[
                                                          'firstTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'firstTeam']
                                                          ['captain']['name']);
                                                }),
                                                icon: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                        mediaQuery: mediaQuery,
                                        mathcInfoForAdmin: mathcInfoForAdmin,
                                        title:
                                            '${mathcInfoForAdmin['firstTeam']['captain']['name']}',
                                        trailing: 'captain',
                                      ),
                                      //This for first team goal keeper
                                      PlayerChangeDataCard(
                                        name: mathcInfoForAdmin['firstTeam']
                                            ['goalKeeper']['name'],
                                        teamNumber: 1,
                                        id: mathcInfoForAdmin['firstTeam']
                                            ['goalKeeper']['id'],
                                        playersGoals:
                                            playerResult['firstTeamGoals']!,
                                        goalWidget: ListTile(
                                          title: Text('Goals'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  if (teamOneScore != 0)
                                                    teamOneScore--;
                                                  if (goalKeeper1Score != 0) {
                                                    goalKeeper1Score--;
                                                    MapPlayerResult
                                                        .playerResult[
                                                            'firstTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                    'firstTeam']
                                                                ['goalKeeper']
                                                            ['id']);
                                                    MapPlayerResult
                                                        .playerResultName[
                                                            'firstTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                    'firstTeam']
                                                                ['goalKeeper']
                                                            ['name']);
                                                  }
                                                }),
                                                icon: const Icon(Icons.remove),
                                              ),
                                              Text(goalKeeper1Score.toString()),
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  teamOneScore++;
                                                  goalKeeper1Score++;
                                                  MapPlayerResult.playerResult[
                                                          'firstTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'firstTeam']
                                                          ['goalKeeper']['id']);
                                                  MapPlayerResult
                                                      .playerResultName[
                                                          'firstTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                                  'firstTeam']
                                                              ['goalKeeper']
                                                          ['name']);
                                                }),
                                                icon: const Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                        mediaQuery: mediaQuery,
                                        mathcInfoForAdmin: mathcInfoForAdmin,
                                        title:
                                            '${mathcInfoForAdmin['firstTeam']['goalKeeper']['name']}',
                                        trailing: 'goalKeeper',
                                      ),
                                      //This for attacker of first team
                                      Container(
                                        height: mediaQuery.height / 2.9,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: attackers1.length,
                                          itemBuilder: (context, index) {
                                            return PlayerChangeDataCard(
                                                name: mathcInfoForAdmin[
                                                            'firstTeam']
                                                        ['attackers'][index]
                                                    ['name'],
                                                teamNumber: 1,
                                                id: mathcInfoForAdmin[
                                                        'firstTeam']
                                                    ['attackers'][index]['id'],
                                                playersGoals:
                                                    playerResult[
                                                        'firstTeamGoals']!,
                                                goalWidget: ListTile(
                                                  title: Text('Goals'),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          if (teamOneScore != 0)
                                                            teamOneScore--;
                                                          if (zeroList1[
                                                                  index] !=
                                                              0) {
                                                            zeroList1[index]--;
                                                            MapPlayerResult
                                                                .playerResult[
                                                                    'firstTeamGoals']!
                                                                .remove(mathcInfoForAdmin[
                                                                            'firstTeam']
                                                                        [
                                                                        'attackers']
                                                                    [
                                                                    index]['id']);
                                                            MapPlayerResult
                                                                .playerResultName[
                                                                    'firstTeamGoals']!
                                                                .remove(mathcInfoForAdmin[
                                                                            'firstTeam']
                                                                        [
                                                                        'attackers']
                                                                    [
                                                                    index]['name']);
                                                          }
                                                        }),
                                                        icon:
                                                            Icon(Icons.remove),
                                                      ),
                                                      Text(zeroList1[index]
                                                          .toString()),
                                                      IconButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          teamOneScore++;
                                                          zeroList1[index]++;
                                                          MapPlayerResult
                                                              .playerResult[
                                                                  'firstTeamGoals']!
                                                              .add(mathcInfoForAdmin[
                                                                          'firstTeam']
                                                                      [
                                                                      'attackers']
                                                                  [
                                                                  index]['id']);
                                                          MapPlayerResult
                                                              .playerResultName[
                                                                  'firstTeamGoals']!
                                                              .add(mathcInfoForAdmin[
                                                                          'firstTeam']
                                                                      [
                                                                      'attackers']
                                                                  [
                                                                  index]['name']);
                                                        }),
                                                        icon: Icon(Icons.add),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                mediaQuery: mediaQuery,
                                                mathcInfoForAdmin:
                                                    mathcInfoForAdmin,
                                                title:
                                                    mathcInfoForAdmin['firstTeam']
                                                            ['attackers'][index]
                                                        ['name'],
                                                trailing: 'attackers');
                                          },
                                        ),
                                      ),
                                    ]),
                                  )
                                : GestureDetector(
                                    onTap: () => _toggleContainer1(mediaQuery),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                            '${imagesUrl.url}${mathcInfoForAdmin['firstTeam']['logo']}',
                                          ),
                                          height: mediaQuery.width / 9,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                        SizedBox(
                                          width: mediaQuery.width / 30,
                                        ),
                                        Text(
                                          '${mathcInfoForAdmin['firstTeam']['name']}',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  37, 48, 106, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: mediaQuery.height / 40),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                _toggleContainer1(mediaQuery),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                          ),

                          //for second team Container
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 100),
                            decoration: BoxDecoration(
                              color: Colors.white,
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
                            curve: Curves.easeInOut,
                            height: _containerHeight2,
                            width: double.infinity,
                            child: _isExpanded2
                                ? SingleChildScrollView(
                                    child: Column(children: [
                                      GestureDetector(
                                        onTap: () =>
                                            _toggleContainer2(mediaQuery),
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: mediaQuery.height / 50),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image(
                                                image: NetworkImage(
                                                  '${imagesUrl.url}${mathcInfoForAdmin['secondTeam']['logo']}',
                                                ),
                                                height: mediaQuery.width / 9,
                                                fit: BoxFit.contain,
                                                alignment: Alignment.center,
                                              ),
                                              SizedBox(
                                                width: mediaQuery.width / 30,
                                              ),
                                              Text(
                                                '${mathcInfoForAdmin['secondTeam']['name']}',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        37, 48, 106, 1),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize:
                                                        mediaQuery.height / 40),
                                              ),
                                              IconButton(
                                                  onPressed: () =>
                                                      _toggleContainer2(
                                                          mediaQuery),
                                                  icon: const Icon(
                                                    Icons.arrow_drop_up,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ),
                                      //This for second team captain
                                      PlayerChangeDataCard(
                                        name: mathcInfoForAdmin['secondTeam']
                                            ['captain']['name'],
                                        teamNumber: 2,
                                        id: mathcInfoForAdmin['secondTeam']
                                            ['captain']['id'],
                                        playersGoals:
                                            playerResult['secondTeamGoals']!,
                                        goalWidget: ListTile(
                                          title: Text('Goals'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  if (teamTowScore != 0)
                                                    teamTowScore--;
                                                  if (captain2Score != 0) {
                                                    captain2Score--;
                                                    MapPlayerResult
                                                        .playerResult[
                                                            'secondTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                'secondTeam']
                                                            ['captain']['id']);
                                                    MapPlayerResult
                                                        .playerResultName[
                                                            'secondTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                'secondTeam'][
                                                            'captain']['name']);
                                                  }
                                                }),
                                                icon: Icon(Icons.remove),
                                              ),
                                              Text(captain2Score.toString()),
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  teamTowScore++;
                                                  captain2Score++;
                                                  MapPlayerResult.playerResult[
                                                          'secondTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'secondTeam']
                                                          ['captain']['id']);
                                                  MapPlayerResult
                                                      .playerResultName[
                                                          'secondTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'secondTeam']
                                                          ['captain']['name']);
                                                }),
                                                icon: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                        mediaQuery: mediaQuery,
                                        mathcInfoForAdmin: mathcInfoForAdmin,
                                        title:
                                            '${mathcInfoForAdmin['secondTeam']['captain']['name']}',
                                        trailing: 'captain',
                                      ),
                                      //This for second team goal keeper
                                      PlayerChangeDataCard(
                                        name: mathcInfoForAdmin['secondTeam']
                                            ['goalKeeper']['name'],
                                        teamNumber: 2,
                                        id: mathcInfoForAdmin['secondTeam']
                                            ['goalKeeper']['id'],
                                        playersGoals:
                                            playerResult['secondTeamGoals']!,
                                        goalWidget: ListTile(
                                          title: Text('Goals'),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  if (teamTowScore != 0)
                                                    teamTowScore--;
                                                  if (goalKeeper2Score != 0) {
                                                    goalKeeper2Score--;
                                                    MapPlayerResult
                                                        .playerResult[
                                                            'secondTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                    'secondTeam']
                                                                ['goalKeeper']
                                                            ['id']);
                                                    MapPlayerResult
                                                        .playerResultName[
                                                            'secondTeamGoals']!
                                                        .remove(mathcInfoForAdmin[
                                                                    'secondTeam']
                                                                ['goalKeeper']
                                                            ['name']);
                                                  }
                                                }),
                                                icon: Icon(Icons.remove),
                                              ),
                                              Text(goalKeeper2Score.toString()),
                                              IconButton(
                                                onPressed: () => setState(() {
                                                  teamTowScore++;
                                                  goalKeeper2Score++;
                                                  MapPlayerResult.playerResult[
                                                          'secondTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                              'secondTeam']
                                                          ['goalKeeper']['id']);
                                                  MapPlayerResult
                                                      .playerResultName[
                                                          'secondTeamGoals']!
                                                      .add(mathcInfoForAdmin[
                                                                  'secondTeam']
                                                              ['goalKeeper']
                                                          ['name']);
                                                }),
                                                icon: Icon(Icons.add),
                                              ),
                                            ],
                                          ),
                                        ),
                                        mediaQuery: mediaQuery,
                                        mathcInfoForAdmin: mathcInfoForAdmin,
                                        title:
                                            '${mathcInfoForAdmin['secondTeam']['goalKeeper']['name']}',
                                        trailing: 'goalKeeper',
                                      ),
                                      //This for attakers of second team
                                      Container(
                                        height: mediaQuery.height / 2.9,
                                        child: ListView.builder(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: attackers2.length,
                                          itemBuilder: (context, index) {
                                            return PlayerChangeDataCard(
                                                name: mathcInfoForAdmin[
                                                        'secondTeam']['attackers']
                                                    [index]['name'],
                                                teamNumber: 2,
                                                id: mathcInfoForAdmin[
                                                        'secondTeam']
                                                    ['attackers'][index]['id'],
                                                playersGoals: playerResult[
                                                    'secondTeamGoals']!,
                                                goalWidget: ListTile(
                                                  title: Text('Goals'),
                                                  trailing: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          if (teamTowScore != 0)
                                                            teamTowScore--;
                                                          if (zeroList2[
                                                                  index] !=
                                                              0) {
                                                            zeroList2[index]--;
                                                            MapPlayerResult
                                                                .playerResult[
                                                                    'secondTeamGoals']!
                                                                .remove(mathcInfoForAdmin[
                                                                            'secondTeam']
                                                                        [
                                                                        'attackers']
                                                                    [
                                                                    index]['id']);
                                                            MapPlayerResult
                                                                .playerResultName[
                                                                    'secondTeamGoals']!
                                                                .remove(mathcInfoForAdmin[
                                                                            'secondTeam']
                                                                        [
                                                                        'attackers']
                                                                    [
                                                                    index]['name']);
                                                          }
                                                        }),
                                                        icon:
                                                            Icon(Icons.remove),
                                                      ),
                                                      Text(zeroList2[index]
                                                          .toString()),
                                                      IconButton(
                                                        onPressed: () =>
                                                            setState(() {
                                                          teamTowScore++;
                                                          zeroList2[index]++;
                                                          MapPlayerResult
                                                              .playerResult[
                                                                  'secondTeamGoals']!
                                                              .add(mathcInfoForAdmin[
                                                                          'secondTeam']
                                                                      [
                                                                      'attackers']
                                                                  [
                                                                  index]['id']);
                                                          MapPlayerResult
                                                              .playerResultName[
                                                                  'secondTeamGoals']!
                                                              .add(mathcInfoForAdmin[
                                                                          'secondTeam']
                                                                      [
                                                                      'attackers']
                                                                  [
                                                                  index]['name']);
                                                        }),
                                                        icon: Icon(Icons.add),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                mediaQuery: mediaQuery,
                                                mathcInfoForAdmin:
                                                    mathcInfoForAdmin,
                                                title: mathcInfoForAdmin[
                                                        'secondTeam']
                                                    ['attackers'][index]['name'],
                                                trailing: 'attackers');
                                          },
                                        ),
                                      )
                                    ]),
                                  )
                                : GestureDetector(
                                    onTap: () => _toggleContainer2(mediaQuery),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: NetworkImage(
                                            '${imagesUrl.url}/${mathcInfoForAdmin['secondTeam']['logo']}',
                                          ),
                                          height: mediaQuery.width / 9,
                                          fit: BoxFit.contain,
                                          alignment: Alignment.center,
                                        ),
                                        SizedBox(
                                          width: mediaQuery.width / 30,
                                        ),
                                        Text(
                                          '${mathcInfoForAdmin['secondTeam']['name']}',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  37, 48, 106, 1),
                                              fontWeight: FontWeight.bold,
                                              fontSize: mediaQuery.height / 40),
                                        ),
                                        IconButton(
                                            onPressed: () =>
                                                _toggleContainer2(mediaQuery),
                                            icon: const Icon(
                                              Icons.arrow_drop_down,
                                              color: Colors.black,
                                            ))
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Did first team score first ?',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        width: mediaQuery.width / 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            firstTeamScoredFirst = !firstTeamScoredFirst;
                          });
                        },
                        child: Container(
                          height: mediaQuery.height / 20,
                          width: mediaQuery.width / 20,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: firstTeamScoredFirst
                                ? Colors.amber
                                : Colors.grey,
                          ),
                        ),
                      )
                    ],
                  ),
                  ElevatedButton(
                      onPressed: () {
                        print(MapPlayerResult.playerResult);
                        print(MapPlayerResult.playerResultName);
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: mediaQuery.height / 2,
                              child: Container(
                                margin: const EdgeInsets.all(10),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Result : ${teamOneScore.toString()} - ${teamTowScore.toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: mediaQuery.height / 40,
                                    ),
                                    SizedBox(
                                      height: mediaQuery.height / 3,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'First team goal : ${MapPlayerResult.playerResultName['firstTeamGoals']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Second team goal : ${MapPlayerResult.playerResultName['secondTeamGoals']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Assists: ${MapPlayerResult.playerResultName['assists']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Saves: ${MapPlayerResult.playerResultName['saves']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Defense: ${MapPlayerResult.playerResultName['defense']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Yellow cards: ${MapPlayerResult.playerResultName['yellowCards']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Red cards: ${MapPlayerResult.playerResultName['redCards']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Honors: ${MapPlayerResult.playerResultName['honor']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                            child: const Text('Cancel')),
                                        SizedBox(
                                          width: mediaQuery.width / 10,
                                        ),
                                        ElevatedButton(
                                            onPressed: () {
                                              declearMatch();

                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      AllMatchesScreen
                                                          .routName);
                                            },
                                            child: const Text('Submit')),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            color: AppColors.mainColor,
                            fontWeight: FontWeight.bold),
                      ))
                ],
              ),
            ),
    );
  }
}

class PlayerChangeDataCard extends StatefulWidget {
  PlayerChangeDataCard(
      {super.key,
      required this.mediaQuery,
      required this.mathcInfoForAdmin,
      required this.title,
      required this.trailing,
      required this.goalWidget,
      required this.playersGoals,
      required this.id,
      required this.teamNumber,
      required this.name});

  final Size mediaQuery;
  final Map<String, dynamic> mathcInfoForAdmin;
  final List<int> playersGoals;
  final int id;
  final String name;
  // final int firstTeamScore ;
  // final int secondTeamScore;
  final int teamNumber;
  final String title;
  final String trailing;
  final Widget goalWidget;
  final result = MapPlayerResult();

  @override
  State<PlayerChangeDataCard> createState() => PlayerChangeDataCardState();
}

class PlayerChangeDataCardState extends State<PlayerChangeDataCard> {
  bool _isExpanded = false;

  int goals = 0;

  int _assists = 0;

  int _saves = 0;

  int _defenses = 0;

  int _honor = 0;

  int _yellowCards = 0;

  int _redCards = 0;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _incrementValue(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            goals++;
            if (widget.teamNumber == 1) {
              MapPlayerResult.playerResult['firstTeamGoals']!.add(widget.id);
              MapPlayerResult.playerResultName['firstTeamGoals']!
                  .add(widget.name);
            } else {
              MapPlayerResult.playerResult['secondTeamGoals']!.add(widget.id);
              MapPlayerResult.playerResultName['secondTeamGoals']!
                  .add(widget.name);
            }
          }

          break;
        case 1:
          {
            _assists++;
            MapPlayerResult.playerResult['assists']!.add(widget.id);
            MapPlayerResult.playerResultName['assists']!.add(widget.name);
          }
          break;
        case 2:
          {
            _saves++;
            MapPlayerResult.playerResult['saves']!.add(widget.id);
            MapPlayerResult.playerResultName['saves']!.add(widget.name);
          }
          break;
        case 3:
          {
            _defenses++;
            MapPlayerResult.playerResult['defense']!.add(widget.id);
            MapPlayerResult.playerResultName['defense']!.add(widget.name);
          }
          break;
        case 4:
          {
            _honor++;
            MapPlayerResult.playerResult['honor']!.add(widget.id);
            MapPlayerResult.playerResultName['honor']!.add(widget.name);
          }
          break;
        case 5:
          {
            _yellowCards++;
            MapPlayerResult.playerResult['yellowCards']!.add(widget.id);
            MapPlayerResult.playerResultName['yellowCards']!.add(widget.name);
          }
          break;
        case 6:
          {
            _redCards++;
            MapPlayerResult.playerResult['redCards']!.add(widget.id);
            MapPlayerResult.playerResultName['redCards']!.add(widget.name);
          }
          break;
      }
    });
  }

  void _dencrementValue(int index) {
    setState(() {
      switch (index) {
        case 0:
          {
            if (goals != 0) {
              goals--;
              if (widget.teamNumber == 1) {
                MapPlayerResult.playerResult['firstTeamGoals']!
                    .remove(widget.id);
                MapPlayerResult.playerResultName['firstTeamGoals']!
                    .remove(widget.name);
              } else {
                MapPlayerResult.playerResult['secondTeamGoals']!
                    .remove(widget.id);
                MapPlayerResult.playerResultName['secondTeamGoals']!
                    .remove(widget.name);
              }
            }
          }
          break;
        case 1:
          {
            if (_assists != 0) {
              _assists--;
              MapPlayerResult.playerResult['assists']!.remove(widget.id);
              MapPlayerResult.playerResultName['assists']!.remove(widget.name);
            }
          }

          break;
        case 2:
          {
            if (_saves != 0) {
              _saves--;
              MapPlayerResult.playerResult['saves']!.remove(widget.id);
              MapPlayerResult.playerResultName['saves']!.remove(widget.name);
            }
          }

          break;
        case 3:
          {
            if (_defenses != 0) {
              _defenses--;
              MapPlayerResult.playerResult['defense']!.remove(widget.id);
              MapPlayerResult.playerResultName['defense']!.remove(widget.name);
            }
          }

          break;
        case 4:
          {
            if (_honor != 0) {
              _honor--;
              MapPlayerResult.playerResult['honor']!.remove(widget.id);
              MapPlayerResult.playerResultName['honor']!.remove(widget.name);
            }
          }

          break;
        case 5:
          {
            if (_yellowCards != 0) {
              _yellowCards--;
              MapPlayerResult.playerResult['yellowCards']!.remove(widget.id);
              MapPlayerResult.playerResultName['yellowCards']!
                  .remove(widget.name);
            }
          }
          break;
        case 6:
          {
            if (_redCards != 0) {
              _redCards--;
              MapPlayerResult.playerResult['redCards']!.remove(widget.id);
              MapPlayerResult.playerResultName['redCards']!.remove(widget.name);
            }
          }
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: _toggleContainer,
        child: Column(
          children: [
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  print(MapPlayerResult.playerResult);
                },
                child: Container(
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
              ),
              title: Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Text(widget.trailing),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: _isExpanded ? 200.0 : 0.0,
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    widget.goalWidget,
                    _buildStatTile('Assists', _assists, 1),
                    _buildStatTile('Saves', _saves, 2),
                    _buildStatTile('Defenses', _defenses, 3),
                    _buildStatTile('Honor', _honor, 4),
                    _buildStatTile('Yellow Cards', _yellowCards, 5),
                    _buildStatTile('Red Cards', _redCards, 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatTile(String title, int value, int index) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              _dencrementValue(index);
              setState(() {});
            },
            icon: const Icon(Icons.remove),
          ),
          Text(value.toString()),
          IconButton(
            onPressed: () {
              _incrementValue(index);
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class AdminMatchHeader extends StatelessWidget {
  const AdminMatchHeader({
    super.key,
    required this.mediaQuery,
    required this.mathcInfoForAdmin,
    required this.teamOneScore,
    required this.teamTowScore,
  });
  final Size mediaQuery;
  final Map<String, dynamic> mathcInfoForAdmin;
  final int teamOneScore;
  final int teamTowScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: mediaQuery.height / 3.5,
      color: Color.fromRGBO(37, 48, 106, 1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                image: NetworkImage(
                  '${imagesUrl.url}${mathcInfoForAdmin['firstTeam']['logo']}',
                ),
                height: mediaQuery.width / 5,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              SizedBox(
                width: mediaQuery.width / 15,
              ),
              Text(
                teamOneScore.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 10),
              ),
              SizedBox(
                width: mediaQuery.width / 20,
              ),
              Text(
                '-',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 10),
              ),
              SizedBox(
                width: mediaQuery.width / 20,
              ),
              Text(
                teamTowScore.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: mediaQuery.width / 10),
              ),
              SizedBox(
                width: mediaQuery.width / 15,
              ),
              Image(
                image: NetworkImage(
                  '${imagesUrl.url}${mathcInfoForAdmin['secondTeam']['logo']}',
                ),
                height: mediaQuery.width / 5,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
            ],
          ),
          Text(
            mathcInfoForAdmin['date'],
            style: const TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: mediaQuery.height / 150,
          ),
          Text(
            mathcInfoForAdmin['stage'],
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            'place : ${mathcInfoForAdmin['place']}',
            style: const TextStyle(color: Colors.white),
          ),
          mathcInfoForAdmin['league'] == 1
              ? const Text(
                  'League',
                  style: TextStyle(color: Colors.white),
                )
              : const Text(
                  'Friendly',
                  style: TextStyle(color: Colors.white),
                ),
        ],
      ),
    );
  }
}
