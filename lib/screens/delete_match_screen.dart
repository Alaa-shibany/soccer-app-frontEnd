import 'package:soccer_app_frontend/models/images_url.dart';

import '/models/map_player_result.dart';
import '/screens/all_matches_screen.dart';
import '/server/auth_server.dart';
import '/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DeleteMatchScreen extends StatefulWidget {
  static const String routName = '/start-match-screen';
  DeleteMatchScreen(
      {super.key,
      required this.teamOneScore,
      required this.teamTowScore,
      required this.id});
  int teamOneScore;
  int teamTowScore;
  int id;

  @override
  State<DeleteMatchScreen> createState() => _DeleteMatchScreenState();
}

class _DeleteMatchScreenState extends State<DeleteMatchScreen>
    with TickerProviderStateMixin {
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
  }

  Future<void> getMatchInfo() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false)
          .ViewMatchInfoForAdmin(widget.id);
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

  Future<void> deleteMatch() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<AuthServer>(context, listen: false).DeleteMatchResult(
        matchId: widget.id,
        playerResult: MapPlayerResult.DeleteResult,
      );
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      MapPlayerResult.DeleteResult['assists']!.clear();
      MapPlayerResult.DeleteResult['honor']!.clear();
      MapPlayerResult.DeleteResult['saves']!.clear();
      MapPlayerResult.DeleteResult['defense']!.clear();
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
                      teamOneScore: widget.teamOneScore,
                      teamTowScore: widget.teamTowScore),
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
                                                mediaQuery: mediaQuery,
                                                mathcInfoForAdmin:
                                                    mathcInfoForAdmin,
                                                title: mathcInfoForAdmin[
                                                            'firstTeam']
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
                                                mediaQuery: mediaQuery,
                                                mathcInfoForAdmin:
                                                    mathcInfoForAdmin,
                                                title: mathcInfoForAdmin[
                                                            'secondTeam']
                                                        ['attackers'][index]
                                                    ['name'],
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
                                              color: const Color.fromRGBO(
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
                  ElevatedButton(
                      onPressed: () {
                        print(MapPlayerResult.DeleteResult);
                        print(MapPlayerResult.DeleteResultName);
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
                                    const Text(
                                      'Delete mathc result',
                                      style: TextStyle(
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
                                              'Assists: ${MapPlayerResult.DeleteResultName['assists']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Saves: ${MapPlayerResult.DeleteResultName['saves']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Defense: ${MapPlayerResult.DeleteResultName['defense']} ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15),
                                            ),
                                            SizedBox(
                                              height: mediaQuery.height / 80,
                                            ),
                                            Text(
                                              'Honors: ${MapPlayerResult.DeleteResultName['honor']} ',
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
                                              deleteMatch();
                                              Navigator.of(context)
                                                  .pushReplacementNamed(
                                                      AllMatchesScreen
                                                          .routName);
                                            },
                                            child: const Text('Delete')),
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
                        'Delete',
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
      required this.id,
      required this.teamNumber,
      required this.name});

  final Size mediaQuery;
  final Map<String, dynamic> mathcInfoForAdmin;
  final int id;
  final String name;
  // final int firstTeamScore ;
  // final int secondTeamScore;
  final int teamNumber;
  final String title;
  final String trailing;
  final result = MapPlayerResult();

  @override
  State<PlayerChangeDataCard> createState() => PlayerChangeDataCardState();
}

class PlayerChangeDataCardState extends State<PlayerChangeDataCard> {
  bool _isExpanded = false;

  int _assists = 0;

  int _saves = 0;

  int _defenses = 0;

  int _honor = 0;

  void _toggleContainer() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _incrementValue(int index) {
    setState(() {
      switch (index) {
        case 1:
          {
            _assists++;
            MapPlayerResult.DeleteResult['assists']!.add(widget.id);
            MapPlayerResult.DeleteResultName['assists']!.add(widget.name);
          }
          break;
        case 2:
          {
            _saves++;
            MapPlayerResult.DeleteResult['saves']!.add(widget.id);
            MapPlayerResult.DeleteResultName['saves']!.add(widget.name);
          }
          break;
        case 3:
          {
            _defenses++;
            MapPlayerResult.DeleteResult['defense']!.add(widget.id);
            MapPlayerResult.DeleteResultName['defense']!.add(widget.name);
          }
          break;
        case 4:
          {
            _honor++;
            MapPlayerResult.DeleteResult['honor']!.add(widget.id);
            MapPlayerResult.DeleteResultName['honor']!.add(widget.name);
          }
          break;
      }
    });
  }

  void _dencrementValue(int index) {
    setState(() {
      switch (index) {
        case 1:
          {
            if (_assists != 0) {
              _assists--;
              MapPlayerResult.DeleteResult['assists']!.remove(widget.id);
              MapPlayerResult.DeleteResultName['assists']!.remove(widget.name);
            }
          }

          break;
        case 2:
          {
            if (_saves != 0) {
              _saves--;
              MapPlayerResult.DeleteResult['saves']!.remove(widget.id);
              MapPlayerResult.DeleteResultName['saves']!.remove(widget.name);
            }
          }

          break;
        case 3:
          {
            if (_defenses != 0) {
              _defenses--;
              MapPlayerResult.DeleteResult['defense']!.remove(widget.id);
              MapPlayerResult.DeleteResultName['defense']!.remove(widget.name);
            }
          }

          break;
        case 4:
          {
            if (_honor != 0) {
              _honor--;
              MapPlayerResult.DeleteResult['honor']!.remove(widget.id);
              MapPlayerResult.DeleteResultName['honor']!.remove(widget.name);
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
                    _buildStatTile('Assists', _assists, 1),
                    _buildStatTile('Saves', _saves, 2),
                    _buildStatTile('Defenses', _defenses, 3),
                    _buildStatTile('Honor', _honor, 4),
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
