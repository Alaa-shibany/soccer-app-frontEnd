import 'dart:io';

import '/models/map_player_result.dart';
import '/models/team.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/best_striker.dart';
import '../models/league_status.dart';
import '../models/team_table.dart';
import '../models/user.dart';
import '../server/dio.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart' as Dio;

class AuthServer with ChangeNotifier {
  AuthServer({required this.context});

  BuildContext context;
  bool _isLoggedIn = false;
  static String? _token;
  static User? _user;
  static Team? _team;
  static LeagueStatus? _leagueStatus;
  static Map<String, dynamic> _autoMatching = {};
  static Map<String, dynamic> _veiwMatchInfo = {};
  static List<dynamic> _unDecleardMatches = [];
  static List<dynamic> _unFinishedMatches = [];
  static TeamTable? _teamTable;
  static BestStrikerModel? _bestStrikerModel;
  static var _userData;
  static String message = 'User name or password is wrong';
  Map<String, dynamic> userRespons = {};
  static Map<String, dynamic> _matchInfoForAdmin = {};
  static List<dynamic> _finishedMatches = [];
  static List<dynamic> topStriker = [];
  static List<dynamic> topGoalKeeper = [];
  static List<dynamic> topAssisstants = [];
  static List<dynamic> topPredictors = [];
  static List<dynamic> topDefenders = [];
  static List<dynamic> topHonor = [];
  static bool isAuth = false;

  bool get authenticated => _isLoggedIn;
  Map<String, dynamic> get autoMatching => _autoMatching;
  List<dynamic> get unDeclearedMatcheslist => _unDecleardMatches;
  List<dynamic> get unFinishedMatches => _unFinishedMatches;
  List<dynamic> get finishedMatches => _finishedMatches;
  Map<String, dynamic> get mathcInfoForAdmin => _matchInfoForAdmin;
  Map<String, dynamic> get viewMatchInfoMap => _veiwMatchInfo;
  User? user() => _user;
  TeamTable? teamTable() => _teamTable;
  BestStrikerModel? BestStrikerM() => _bestStrikerModel;
  Team? team() => _team;
  LeagueStatus? leagueStatue() => _leagueStatus;
  static String? get userData => _userData;
  static String? get getToken => _token;
  String? get token => _token;

  Future<void> login(String? userName, String? password) async {
    if (userName == null || password == null) {
      return;
    } else {
      var body = {
        'userName': userName,
        'password': password,
      };
      final SharedPreferences storage = await SharedPreferences.getInstance();
      try {
        Dio.Response response = await dio().post('/login', data: body);
        userRespons = response.data;
        String? token = response.data['token'];
        storToken(token: token);
        await storage.setString('tokenType', response.data['tokenType']);
        _token = token;
        _userData = await storage.getString('tokenType');
        notifyListeners();
        if (response.data['message'] == 'success') {
          message = response.data['message'];
          isAuth = true;
          notifyListeners();
        } else {
          message = response.data['message'];
          isAuth = false;
          notifyListeners();
        }
        notifyListeners();
        print('......................................login info');
        print('the token type from storage is ');
        print(response.data['tokenType']);
        print('status code');
        print(response.statusCode);
        print('tokenType');
        print('response data :');
        print(response.data);
        print('......................................');
        tryToken(token: token);
      } on DioError catch (e) {
        print(e.response);
        isAuth = false;
        notifyListeners();
        print(message);
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> tryToken({String? token}) async {
    if (token == null) {
      return;
    } else {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      _userData = await storage.getString('tokenType');
      try {
        Dio.Response response = await dio().get(
          '/player/-1',
          options: Dio.Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        _isLoggedIn = true;
        _user = User.fromJson(response.data);
        notifyListeners();
        print('......................................tryToken info');
        print('user info');
        print(response.data);
        print('the user name from the back end is');
        print(_user!.name);
        print('the token in the storage');
        print(
          storage.getString('token'),
        );
        print('......................................');
      } on DioError catch (e) {
        print(e.message);
        _isLoggedIn = true;
        notifyListeners();
      }
    }
  }

  Future<void> storToken({
    String? token,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    await storage.setString('token', token!);
  }

  void logout() {
    cleanUp();
    notifyListeners();
  }

  void cleanUp() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    _user = null;
    _isLoggedIn = false;
    _token = null;
    await storage.remove('token');
    await storage.remove('tokenType');
    notifyListeners();
  }

  Future<void> uploadData(File exclFile) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      // String fileName = exclFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        'excel_file': await MultipartFile.fromFile(exclFile.path),
      });
      Dio.Response response = await dio().post(
        "/excelInput",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      // Get the documents directory for the app
      // Directory appDocumentsDirectory =
      //     await getApplicationDocumentsDirectory();
      // String filePath = '${appDocumentsDirectory.path}/downloaded_excel.xlsx';

      // // Write the response content to a file
      // File downloadedFile = File(filePath);
      // await downloadedFile.writeAsBytes(response.data);

      // // Show a message or navigate to the downloaded file
      // // For example:
      // // ScaffoldMessenger.of(context).showSnackBar(
      // //   SnackBar(content: Text('Excel file downloaded')),
      // // );
      print('................................upload data info');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> teamData({int? id}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        '/team/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _team = Team.fromJson(response.data);
      print('.................................show team data');
      print(response.data);
      print('......................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> playerData({var id}) async {
    try {
      final SharedPreferences storage = await SharedPreferences.getInstance();
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        '/player/$id',
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _user = User.fromJson(response.data);
      notifyListeners();
      print('.................................show user data');
      print(response.data);
      print('......................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadTeamImage({var id, File? image}) async {
    // ignore: unused_local_variable
    var body = {
      'image': image,
    };
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      String fileName = image!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(image.path, filename: fileName),
      });
      Dio.Response response = await dio().post(
        "/team/$id",
        data: formData,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      notifyListeners();
      print('................................upload data info');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> TeamsTables() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/part1/teams",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _teamTable = TeamTable.fromJson(response.data);
      notifyListeners();
      print('................................TeamTables from server data info');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> TeamsTablesSuggestion() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/part1/teamsSearchSuggestions",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _teamTable = TeamTable.fromJson(response.data);
      notifyListeners();
      print('................................TeamTables from server data info');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> BestStriker() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topScorers",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _bestStrikerModel = BestStrikerModel.fromJson(response.data);
      notifyListeners();
      print(
          '................................best striker from server data info');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> AutoMatching() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/matchMaking",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _autoMatching = response.data;
      message = response.data['message'];
      notifyListeners();
      print('................................AutoMatchin server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      message = e.response!.data['message'];
      notifyListeners();
      print(e.response!.data['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> UnDeclearedMatchedForClass(String Grade, String Class) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/part1/unDeclaredMatches?grade=$Grade&class=$Class",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _unDecleardMatches = response.data;
      notifyListeners();
      print('................................AutoMatchin server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> DeclearedMatched(String date, String id) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/part1/declareMatch/$id",
        data: {'date': date},
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      print('................................declear match server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> UnFinishedMatches() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/unFinishedMatches",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _unFinishedMatches = response.data;
      notifyListeners();
      print('................................unFinishedMatches match server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> ViewMatchInfoForAdmin(int id) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();

    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/viewMatchInfo/$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _matchInfoForAdmin = response.data;
      notifyListeners();
      print('................................Match info for admin from server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> DeclearMatchResult(
      {required int matchId,
      required Map<String, List<int>> playerResult,
      required bool firstTeamScoredFirst}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    print(
        '...............................fdasfasdfasdfasdfdsfsdaadfsgfdghpiktrpwtp');
    Map<String, dynamic> strToDynamic = {
      'firstTeamScoredFirst': firstTeamScoredFirst,
    };
    playerResult.forEach((key, value) {
      value.isEmpty ? strToDynamic[key] = [0] : strToDynamic[key] = value;
    });
    notifyListeners();
    print(strToDynamic);
    print(MapPlayerResult.playerResult);
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/declareMatchResults/$matchId",
        data: strToDynamic,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      notifyListeners();
      print('................................Declear match result from server');
      print(response.data);
      print('................................');
      MapPlayerResult.playerResult.forEach((key, value) {
        value.clear();
      });
      MapPlayerResult.playerResultName.forEach((key, value) {
        value.clear();
      });
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> AdvanceToPartOne(
      {required String title,
      required String startDate,
      required String predictionQuestion1,
      required String predictionQuestion2}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    Map<String, dynamic> data = {
      'title': title,
      'startDate': startDate,
      'predictionQuestion1': predictionQuestion1,
      'predictionQuestion2': predictionQuestion2
    };
    notifyListeners();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/admin/advanceToPartOne",
        data: data,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      message = response.data['message'];
      notifyListeners();
      print(
          '................................advance part one result from server');
      print(response.data);
      print(response.statusMessage);
      print('................................');
    } on DioError catch (e) {
      message = e.response!.data['message'];
      notifyListeners();
      print(e.response!.data['message']);
    } catch (e) {
      print(e);
    }
  }

  Future<void> League() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/league",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _leagueStatus = LeagueStatus.fromJson(response.data);
      notifyListeners();
      print(
          '................................advance part one result from server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> FinishedMatches() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/finishedMatches",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _finishedMatches = response.data;
      notifyListeners();
      print(
          '................................finished matches result from server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> viewMatchInfo({required int matchId}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/viewMatchInfo/$matchId",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      _veiwMatchInfo = response.data;
      notifyListeners();
      print('................................view matche info from server');
      print(response.data);
      print('................................');
    } catch (e) {
      print(e);
    }
  }

  Future<void> Prediction({
    required int contest_id,
    required int winner,
    required int question1,
    required int question2,
    required int Double,
  }) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    final Map<String, int> body = {
      'contest_id': contest_id,
      'winner': winner,
      'question1': question1,
      'question2': question2,
      'double': Double,
    };
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/prediction",
        data: body,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      notifyListeners();
      print('................................view prediction info from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> newMatch(
      {required int firstTeam_id,
      required int secondTeam_id,
      required int playGround,
      required int friendlyMatch,
      required int stage,
      required String date}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    final Map<String, dynamic> body = {
      'firstTeam_id': firstTeam_id,
      'secondTeam_id': secondTeam_id,
      'playGround': playGround,
      'friendlyMatch': friendlyMatch,
      'stage': stage,
      'date': date,
    };
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().post(
        "/newMatch",
        data: body,
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      message = response.data['message'];
      notifyListeners();
      print('................................view new mathc info from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopStrikers() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topScorers",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topStriker = response.data;
      notifyListeners();
      print('................................view top strikers from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopGoalKeepers() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topKeepers",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topGoalKeeper = response.data;
      notifyListeners();
      print('................................view top Keepers from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopAssistants() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topAssistants",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topAssisstants = response.data;
      notifyListeners();
      print('................................view top Assistants from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopDefenders() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topDefenders",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topDefenders = response.data;
      notifyListeners();
      print('................................view  topDefenders from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopPredictors() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topPredictors",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topPredictors = response.data;
      notifyListeners();
      print('................................view  topPredictors from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> getTopHonor() async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().get(
        "/topHonor",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      topHonor = response.data;
      notifyListeners();
      print('................................view  topHonor from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }

  Future<void> deleteMatch({required String id}) async {
    final SharedPreferences storage = await SharedPreferences.getInstance();
    try {
      String? myToken = await storage.getString('token');
      Dio.Response response = await dio().delete(
        "/deleteMatch/$id",
        options: Dio.Options(
          headers: {'Authorization': 'Bearer $myToken'},
        ),
      );
      message = response.data['message'];
      notifyListeners();
      print(
          '................................delete match response from server');
      print(response.data);
      print('................................');
    } on DioError catch (e) {
      print(e.response!.data['message']);
      message = e.response!.data['message'];
      notifyListeners();
    }
  }
}
