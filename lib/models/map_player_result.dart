import 'package:flutter/material.dart';

class MapPlayerResult with ChangeNotifier {
  static Map<String, List<int>> playerResult = {
    'firstTeamGoals': [],
    'secondTeamGoals': [],
    'yellowCards': [],
    'assists': [],
    'redCards': [],
    'honor': [],
    'saves': [],
    'defense': [],
  };
  // static Map<String, List<int>> playerResult = {
  //   'firstTeamGoals': [],
  //   'secondTeamGoals': [],
  //   'yellowCards': [],
  //   'redCards': [],
  //   'honor': [],
  // };
  static Map<String, List<String>> playerResultName = {
    'firstTeamGoals': [],
    'secondTeamGoals': [],
    'yellowCards': [],
    'assists': [],
    'redCards': [],
    'honor': [],
    'saves': [],
    'defense': [],
  };
}
