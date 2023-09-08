import 'package:flutter/material.dart';

class LeaguePartSettings with ChangeNotifier {
  static bool isPartOneLocked = true;
  static bool isPartTowLocked = true;

  bool get isPartOneLockedMethod => isPartOneLocked;
  bool get isPartTowLockedMethod => isPartTowLocked;
}
