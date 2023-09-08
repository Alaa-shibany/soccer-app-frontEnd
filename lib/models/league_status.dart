class LeagueStatus {
  final String currentStage;
  final String? title;
  final String? startDate;
  final String? schoolName;
  final String? predictionQuestion1;
  final String? predictionQuestion2;
  final bool? autoMatchMakingDone;

  LeagueStatus(
    this.currentStage,
    this.title,
    this.startDate,
    this.schoolName,
    this.predictionQuestion1,
    this.predictionQuestion2,
    this.autoMatchMakingDone,
  );

  LeagueStatus.fromJson(Map<String, dynamic> json)
      : currentStage = json['currentStage'],
        title = json['title'],
        startDate = json['startDate'],
        schoolName = json['schoolName'],
        predictionQuestion1 = json['predictionQuestion1'],
        predictionQuestion2 = json['predictionQuestion2'],
        autoMatchMakingDone = json['autoMatchMakingDone'];
}
