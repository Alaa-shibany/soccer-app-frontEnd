import 'package:soccer_app_frontend/models/images_url.dart';

import '/styles/app_colors.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../server/auth_server.dart';
import '../server/dio.dart';

class adminCreateMatchScreen extends StatefulWidget {
  const adminCreateMatchScreen({super.key});

  @override
  State<adminCreateMatchScreen> createState() => _adminCreateMatchScreenState();
}

class _adminCreateMatchScreenState extends State<adminCreateMatchScreen> {
  String? value; // initial dropdown selection
  String? value1;
  Map<String, dynamic>? value3;
  Map<String, dynamic>? value4;

  List<dynamic> team1 = [];
  List<dynamic> team2 = [];

  int firstTeam_id = 0;
  int secondTeam_id = 0;
  int playGround = 0;
  int friendlyMatch = 0;
  int stage = 1;

  // ignore: unused_field
  bool _isLoading = false;

  String? answer;
  String? answer1;
  String? answer2;
  String? answer3;

  String _dateTime = '';

  List<String> _dropDownItems = [];
  @override
  void initState() {
    super.initState();
    getDate();
    team1 = team2 = [
      {
        'name': 'team1',
        'logo': null,
      }
    ];
  }

  Map<String, dynamic> tabelInfo = {};

  getDate() async {
    List<dynamic> responseList;
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
  }

  Future<void> sendData() async {
    try {
      await Provider.of<AuthServer>(context, listen: false).newMatch(
          firstTeam_id: firstTeam_id,
          secondTeam_id: secondTeam_id,
          playGround: playGround,
          friendlyMatch: friendlyMatch,
          stage: stage,
          date: _dateTime);
      // ignore: use_build_context_synchronously
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
          content: Text(AuthServer.message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Cancle'),
            ),
          ],
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        _dateTime = '${value!.year}-${value.month}-${value.day}';
        print('..............................................');
        print(_dateTime);
        print('..............................................');
      });
    });
  }

  // void _onDropDownItemSelected(String newValue) {
  //   setState(() {
  //     value = newValue;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create match'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          //first tow drop menu to select class
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.blueGrey.shade300,
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
                        print('$team1   team 1');
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                        borderRadius: BorderRadius.circular(12),
                        dropdownColor: Colors.blueGrey.shade300,
                        value: value1,
                        items: _dropDownItems.map(buildMenuItem).toList(),
                        onChanged: (value) {
                          setState(() {
                            value1 = value;

                            team2 = tabelInfo[value];
                          });
                          print(value1);
                          final listS1 = value1!.split(' ').toList();
                          print(listS1);
                          print('$team2   team 2');
                        }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 50,
          ),
          //second tow drop menu to select teams
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: Colors.blueGrey.shade300,
                      value: value3,
                      items: team1.map(buildMenuItem2).toList(),
                      onChanged: (value) {
                        setState(() {
                          value3 = value;
                          firstTeam_id = value['id'];
                        });
                        print(value3);
                        print(firstTeam_id);
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.amber, width: 4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<dynamic>(
                        borderRadius: BorderRadius.circular(12),
                        dropdownColor: Colors.blueGrey.shade300,
                        value: value4,
                        items: team2.map(buildMenuItem2).toList(),
                        onChanged: (value) {
                          setState(() {
                            value4 = value;
                            secondTeam_id = value['id'];
                          });
                          print(value4);
                          print(secondTeam_id);
                        }),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          //first question
          const Text(
            'Will the match play in the playground?',
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                  value: 'Yes',
                  groupValue: answer,
                  onChanged: (String? value) {
                    setState(() {
                      answer = value;
                      playGround = 1;
                    });
                    print(playGround);
                  },
                ),
                const Text(
                  'Yes',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                Radio<String>(
                  value: 'No',
                  groupValue: answer,
                  onChanged: (String? value) {
                    setState(() {
                      answer = value;
                      playGround = 0;
                    });
                    print(playGround);
                  },
                ),
                const Text(
                  'No',
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          //second question
          const Text(
            'What is the type of mathc?',
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                  value: 'Friendly',
                  groupValue: answer1,
                  onChanged: (String? value) {
                    setState(() {
                      answer1 = value;
                      friendlyMatch = 1;
                    });
                    print(friendlyMatch);
                  },
                ),
                const Text(
                  'Friendly',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                Radio<String>(
                  value: 'League',
                  groupValue: answer1,
                  onChanged: (String? value) {
                    setState(() {
                      answer1 = value;
                      friendlyMatch = 0;
                    });
                    print(friendlyMatch);
                  },
                ),
                const Text(
                  'League',
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          //third question
          const Text(
            'What is the match stage?',
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                  value: 'part one',
                  groupValue: answer2,
                  onChanged: (String? value) {
                    setState(() {
                      answer2 = value;
                      stage = 1;
                    });
                    print(friendlyMatch);
                  },
                ),
                const Text(
                  'Part one',
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 20,
                ),
                Radio<String>(
                  value: 'part tow',
                  groupValue: answer2,
                  onChanged: (String? value) {
                    setState(() {
                      answer2 = value;
                      stage = 2;
                    });
                    print(friendlyMatch);
                  },
                ),
                const Text(
                  'Part tow',
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 40,
          ),
          //pick a date
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Pick a date'),
              SizedBox(
                width: MediaQuery.of(context).size.width / 40,
              ),
              ElevatedButton(
                  onPressed: () {
                    _showDatePicker();
                  },
                  child: Container(
                      width: MediaQuery.of(context).size.width / 10,
                      height: MediaQuery.of(context).size.height / 35,
                      child: const Text(
                        'date',
                        textAlign: TextAlign.center,
                      ))),
              SizedBox(
                width: MediaQuery.of(context).size.width / 20,
              ),
              Text(_dateTime),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          ElevatedButton(
            onPressed: () {
              print('$firstTeam_id firstTeam_id');
              print('$secondTeam_id secondTeam_id');
              print('$playGround playGround');
              print('$friendlyMatch friendlyMatch');
              print('$stage stage');
              print('$_dateTime _dateTime');
              sendData();
            },
            child: Text(
              'Submit',
              style: TextStyle(color: AppColors.mainColor),
            ),
          )
        ],
      ),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
                      '${imagesUrl.url}/${item['logo']}',
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
