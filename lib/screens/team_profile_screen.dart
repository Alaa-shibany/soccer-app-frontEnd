import 'dart:io';

import 'package:soccer_app_frontend/models/images_url.dart';

import '/models/team.dart';
import '/screens/user_profile_screen.dart';
import '/widgets/image_info_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../server/auth_server.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/soccer_table_league.dart';
import '../widgets/heder_user_profile.dart';

class TeamProfileScreen extends StatefulWidget {
  static const routeName = '/team-profile';
  const TeamProfileScreen({super.key});

  @override
  State<TeamProfileScreen> createState() => _TeamProfileScreenState();
}

class _TeamProfileScreenState extends State<TeamProfileScreen>
    with TickerProviderStateMixin {
  File? _image;
  bool _isLoading = false;
  late TabController? controller;

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? imgPath = File(image.path);
      imgPath = await _cropImage(imageFile: imgPath);
      setState(() {
        _image = imgPath;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    // ignore: use_build_context_synchronously
    var id = Provider.of<AuthServer>(context, listen: false).team()!.id;

    try {
      // ignore: use_build_context_synchronously
      if (await Provider.of<AuthServer>(context, listen: false).uploadTeamImage(
        id: id,
        image: _image,
      )) {
        print('Yes');
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (context) => const AlertDialog(
            content: Text('Done you can move on with your life'),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    getDate();
  }

  Map<String, dynamic> tabelInfo = {};
  int? id = 0;

  getDate() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<AuthServer>(context, listen: false).TeamsTables();
      setState(() {
        tabelInfo = Provider.of<AuthServer>(context, listen: false)
            .teamTable()!
            .teamTable;
      });
      setState(() {
        id = ModalRoute.of(context)!.settings.arguments as int;
      });
      await Provider.of<AuthServer>(context, listen: false).teamData(
        id: id,
      );
      print('...............................print id');
      print(id);
      print('...........................................');
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    var teamData = Provider.of<AuthServer>(context).team();
    late String myKeyForTable =
        'Grade ${teamData!.grade} Class ${teamData.Class}';
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color.fromARGB(255, 202, 202, 202),
      drawer: NavigationDrawerWidget(),
      body: _isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
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
                  title:
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    AuthServer.userData == 'admin'
                        ? GestureDetector(
                            onTap: () {
                              _pickImage();
                            },
                            child: Container(
                              child: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          )
                        : const SizedBox(
                            width: 0,
                            height: 0,
                          ),
                  ]),
                  flexibleSpace: LayoutBuilder(
                    builder: (p0, p1) {
                      final height = p1.biggest.height;
                      return FlexibleSpaceBar(
                        centerTitle: true,
                        background: GestureDetector(
                          onTap: () {
                            print(myKeyForTable);
                            print(tabelInfo);
                          },
                          child: HederUserProfile(
                            mediaQuery: mediaQuery,
                            Container(
                              alignment: Alignment.center,
                              height: mediaQuery.height / 4.5,
                              width: mediaQuery.width / 4.5,
                              child: Image(
                                image: NetworkImage(
                                  '${imagesUrl.url}/${teamData!.logo}',
                                ),
                                fit: BoxFit.contain,
                                alignment: Alignment.topCenter,
                              ),
                            ),
                            name: teamData.name!,
                            subtitle: 'Grade ${teamData.grade!}',
                          ),
                        ),
                        title: height < 100
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    //container for avatar
                                    height: mediaQuery.height / 8,
                                    width: mediaQuery.width / 8,
                                    margin: EdgeInsets.only(
                                        top: mediaQuery.height / 35),
                                    padding:
                                        EdgeInsets.all(mediaQuery.height / 400),
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
                                    child: Image(
                                      image: NetworkImage(
                                        '${imagesUrl.url}/${teamData.logo}',
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: mediaQuery.width / 30,
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        top: mediaQuery.height / 35),
                                    child: Text(
                                      teamData.name!,
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            : null,
                      );
                    },
                  ),
                  pinned: true,
                  backgroundColor: const Color.fromRGBO(37, 48, 106, 1),
                  expandedHeight: mediaQuery.height / 3.2,
                ),
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      ImageInfoProfile(
                          mediaQuery: mediaQuery,
                          widget1: Container(
                            width: mediaQuery.width / 6,
                            height: mediaQuery.height / 9.5,
                            child: const Image(
                              image: AssetImage(
                                'assets/images/wins.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          value1: teamData!.wines.toString(),
                          widget2: Container(
                            width: mediaQuery.width / 6,
                            height: mediaQuery.height / 9.5,
                            child: const Image(
                              image: AssetImage(
                                'assets/images/ties.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          value2: teamData.ties.toString(),
                          widget3: Container(
                            width: mediaQuery.width / 6,
                            height: mediaQuery.height / 9.5,
                            child: const Image(
                              image: AssetImage(
                                'assets/images/losses.png',
                              ),
                              fit: BoxFit.contain,
                            ),
                          ),
                          value3: teamData.losses.toString(),
                          title1: 'Wins',
                          title2: 'Ties',
                          title3: 'Losses'),
                      TabsTeamInfo(
                          controller: controller, mediaQuery: mediaQuery),
                      SlidesForTabs(
                          tabelInfo: tabelInfo[myKeyForTable],
                          tableKey: myKeyForTable,
                          mediaQuery: mediaQuery,
                          controller: controller,
                          teamData: teamData,
                          teamID: id),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class SlidesForTabs extends StatelessWidget {
  const SlidesForTabs({
    super.key,
    required this.mediaQuery,
    required this.controller,
    required this.teamData,
    required this.tabelInfo,
    required this.tableKey,
    required this.teamID,
  });

  final Size mediaQuery;
  final TabController? controller;
  final Team? teamData;
  final List<dynamic> tabelInfo;
  final String tableKey;
  final int? teamID;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: mediaQuery.height / 1.5,
      child: TabBarView(
        controller: controller,
        children: [
          SoccerTableLeague(
            leagueName: tableKey,
            teams: tabelInfo,
            mediaQuery: mediaQuery,
            id: teamID,
          ),
          PlayerInTheTeam(
            mediaQuery: mediaQuery,
            teamData: teamData,
          )
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
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(3),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: TabBar(
        controller: widget.controller,
        tabs: [
          Tab(
            icon: Image(
              image: AssetImage('assets/icons/tableLeagueIcon.png'),
              height: widget.mediaQuery.height / 24,
              fit: BoxFit.contain,
            ),
            iconMargin: EdgeInsets.only(
              bottom: widget.mediaQuery.height / 130,
            ),
            text: 'Table',
          ),
          Tab(
            icon: Image(
              image: AssetImage('assets/icons/playersIcon.png'),
              height: widget.mediaQuery.height / 19,
              fit: BoxFit.contain,
            ),
            iconMargin: EdgeInsets.zero,
            text: 'Players',
          ),
        ],
      ),
    );
  }
}

class PlayerInTheTeam extends StatelessWidget {
  const PlayerInTheTeam({
    super.key,
    required this.mediaQuery,
    required this.teamData,
  });
  final Team? teamData;
  final Size mediaQuery;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                Provider.of<AuthServer>(context, listen: false)
                    .playerData(id: teamData!.captain['id']);
                Navigator.of(context).pushNamed(UserProfileScreen.routName,
                    arguments: teamData!.captain['id']);
              },
              child: PlayerForTeam(
                mediaQuery: mediaQuery,
                name: teamData!.captain['name'],
                position: 'captain',
                number: '1',
              ),
            ),
            GestureDetector(
              onTap: () {
                Provider.of<AuthServer>(context, listen: false)
                    .playerData(id: teamData!.goalKeeper['id']);
                Navigator.of(context).pushNamed(UserProfileScreen.routName,
                    arguments: teamData!.goalKeeper['id']);
              },
              child: PlayerForTeam(
                mediaQuery: mediaQuery,
                name: teamData!.goalKeeper['name'],
                position: 'goalKeeper',
                number: '2',
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              primary: false,
              shrinkWrap: true,
              itemCount: teamData!.attackers.length,
              itemBuilder: (context, index) => GestureDetector(
                onTap: () {
                  Provider.of<AuthServer>(context, listen: false)
                      .playerData(id: teamData!.attackers[index]['id']);
                  Navigator.of(context).pushNamed(UserProfileScreen.routName,
                      arguments: teamData!.attackers[index]['id']);
                },
                child: PlayerForTeam(
                  mediaQuery: mediaQuery,
                  name: teamData!.attackers[index]['name'],
                  position: 'attacker',
                  number: (index + 3).toString(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class PlayerForTeam extends StatelessWidget with ChangeNotifier {
  PlayerForTeam({
    super.key,
    required this.mediaQuery,
    required this.name,
    required this.position,
    required this.number,
  });

  final Size mediaQuery;
  final String name;
  final String position;
  final String number;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin: const EdgeInsets.only(right: 15, left: 15, top: 12),
          width: double.infinity,
          height: mediaQuery.height / 12,
          decoration: BoxDecoration(
            color: Color.fromRGBO(37, 48, 106, 1),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            height: mediaQuery.height,
            margin: EdgeInsets.only(left: mediaQuery.width / 14),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/images/userHader.png'))),
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: mediaQuery.height / 30,
              ),
            ),
          ),
        ),
        Container(
          // this container for team
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          margin:
              EdgeInsets.only(right: 15, left: mediaQuery.width / 5, top: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ListTile(
            leading: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CircleAvatar(
                backgroundColor: const Color.fromRGBO(37, 48, 106, 1),
                child: Container(
                  padding: const EdgeInsets.all(1),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      CupertinoIcons.person,
                      color: Color.fromRGBO(37, 48, 106, 1),
                    ),
                  ),
                ),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(
                  color: Color.fromRGBO(37, 48, 106, 1),
                  fontWeight: FontWeight.bold),
            ),
            trailing: Text(
              position,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
