import '/server/auth_server.dart';
import 'package:dio/dio.dart' as Dio;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../server/dio.dart';
import '../widgets/match_widget.dart';

class AdminAddingMatchesScreen extends StatefulWidget {
  static const String routName = '/admin-add-matches-screen';
  const AdminAddingMatchesScreen({super.key});

  @override
  State<AdminAddingMatchesScreen> createState() =>
      _AdminAddingMatchesScreenState();
}

class _AdminAddingMatchesScreenState extends State<AdminAddingMatchesScreen> {
  String? value; // initial dropdown selection

  bool _isLoading = false;

  String _dateTime = '';

  List<String> _dropDownItems = [];
  @override
  void initState() {
    super.initState();
    getDate();
  }

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

  void _showDatePicker(String id) {
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
        Provider.of<AuthServer>(context, listen: false)
            .DeclearedMatched(_dateTime, id);

        Navigator.of(context)
            .pushReplacementNamed(AdminAddingMatchesScreen.routName);
      });
    });
  }

  void _onDropDownItemSelected(String newValue) {
    setState(() {
      value = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('My Page'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: 300,
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
                          });
                          final listS = value!.split(' ').toList();
                          print(listS);
                          Provider.of<AuthServer>(context, listen: false)
                              .UnDeclearedMatchedForClass(
                                  listS[1].trim(), listS[3].trim());
                        }),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist
                          .length
                          .toString(),
                      style: TextStyle(fontSize: 18),
                    ),
              Container(
                width: double.infinity,
                height: mediaQuery.height / 1.4,
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: Provider.of<AuthServer>(context)
                      .unDeclearedMatcheslist
                      .length,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {},
                    child: MatchWidget(
                      matchType: Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist[index]['league'],
                      teamLogoUrl1: Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist[index]['first_team']['logo'],
                      teamLogoUrl2: Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist[index]['second_team']['logo'],
                      teamName1: Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist[index]['first_team']['name'],
                      teamName2: Provider.of<AuthServer>(context)
                          .unDeclearedMatcheslist[index]['second_team']['name'],
                      center: Text('-'),
                      user: 'admin',
                      customWidget: ElevatedButton(
                          onPressed: () {
                            _showDatePicker(
                              Provider.of<AuthServer>(context, listen: false)
                                  .unDeclearedMatcheslist[index]['id']
                                  .toString(),
                            );
                          },
                          child: Container(
                              width: mediaQuery.width / 10,
                              height: mediaQuery.height / 35,
                              child: const Text(
                                'date',
                                textAlign: TextAlign.center,
                              ))),
                      mediaQuery: mediaQuery,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
        child: Text(
          item,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        value: item,
      );
}
