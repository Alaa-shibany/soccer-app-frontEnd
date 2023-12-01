import 'package:flutter/cupertino.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soccer_app_frontend/styles/app_colors.dart';

import '../server/auth_server.dart';
import '../server/dio.dart';
import '../widgets/heder_user_profile.dart';

// ignore: camel_case_types
class adminTransfareScreen extends StatefulWidget {
  static const String routeName = '/admin-transfare';
  const adminTransfareScreen({super.key});

  @override
  State<adminTransfareScreen> createState() => _adminTransfareScreenState();
}

// ignore: camel_case_types
class _adminTransfareScreenState extends State<adminTransfareScreen> {
  String? value;
  String? value3;
  Map<String, dynamic>? value4;

  List<dynamic> team1 = [];

  int firstTeam_id = 0;
  int position = 0;

  // ignore: unused_field
  bool _isLoading = false;

  List<String> _dropDownItems = [];
  List<String> _dropDownItemsPosition = ['Captain', 'Goalkeeper', 'Attacker'];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero).then((value) => getDate(context));
    team1 = [
      {
        'name': 'team1',
        'logo': null,
      }
    ];
  }

  Map<String, dynamic> tabelInfo = {};

  getDate(BuildContext context) async {
    List<dynamic> responseList;
    final id = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      _isLoading = true;
    });
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/part1/teamsSearchSuggestions",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................TeamTablesSuggestion');
      print(response.data);
      print('................................');

      await Provider.of<AuthServer>(context, listen: false).TeamsTables();
      await Provider.of<AuthServer>(context, listen: false).playerData(
        id: id,
      );
      setState(() {
        _isLoading = false;
        tabelInfo = Provider.of<AuthServer>(context, listen: false)
            .teamTable()!
            .teamTable;
      });
      setState(() {
        responseList = response.data;
        _dropDownItems = responseList.map((e) => e.toString()).toList();
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      _isLoading = false;
    });
    print('...............................print id');
    print(id);
    print('...........................................');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userData = Provider.of<AuthServer>(context).user();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfare player'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                HederUserProfile(
                  mediaQuery: mediaQuery,
                  Icon(
                    CupertinoIcons.person,
                    color: const Color.fromRGBO(37, 48, 106, 1),
                    size: mediaQuery.height / 20,
                  ),
                  name: userData!.name!,
                  subtitle: '${userData.team['name']}/${userData.position!}',
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Select new class',
                  textAlign: TextAlign.left,
                ),
                //first tow drop menu to select class
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.white,
                      value: value,
                      items: _dropDownItems.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          this.value = value;
                          team1 = tabelInfo[value];
                        });
                        print(value);
                        final listS = value!.split(' ').toList();
                        print(listS);
                        print('$team1 team 1');
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                const Text(
                  'Select new team',
                  textAlign: TextAlign.left,
                ),
                //second tow drop menu to select teams
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.white,
                      value: value4,
                      items: team1.map(buildMenuItem2).toList(),
                      onChanged: (value) {
                        setState(() {
                          value4 = value;
                          firstTeam_id = value['id'];
                        });
                        print(value4);
                        print(firstTeam_id);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 30,
                ),
                const Text(
                  'Select new postion',
                  textAlign: TextAlign.left,
                ),
                //second tow drop menu to select teams
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.blueGrey.shade300,
                      value: value3,
                      items: _dropDownItemsPosition.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          value3 = value;
                          if (value == 'Captain') {
                            position = 3;
                          } else if (value == 'Goalkeeper') {
                            position = 2;
                          } else {
                            position = 1;
                          }
                        });
                        print(value);
                        print(position);
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: mediaQuery.height / 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print(firstTeam_id);
                    print(position);
                  },
                  style: ElevatedButton.styleFrom(
                    primary: AppColors.mainColor,
                  ),
                  label: const Text(
                    'Transfare',
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(
                    Icons.swap_horiz_outlined,
                    color: Colors.white,
                  ),
                )
              ],
            ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        // ignore: sort_child_properties_last
        child: Text(
          item,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        value: item,
      );

  DropdownMenuItem<dynamic> buildMenuItem2(dynamic item) => DropdownMenuItem(
        // ignore: sort_child_properties_last
        child: Row(
          children: [
            item['logo'] == null
                ? const SizedBox(
                    height: 0,
                  )
                : Image(
                    image: NetworkImage(
                      '${imagesUrl.url}${item['logo']}',
                    ),
                    height: 25,
                  ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 40,
            ),
            Text(item['name']),
          ],
        ),
        value: item,
      );
}
