class Team {
  final int? id;
  final String? name;
  final String? grade;
  final String? Class;
  final String? logo;
  final int? point;
  final int? diff;
  final String stage;
  final int? wines;
  final int? ties;
  final int? losses;
  final List<dynamic> attackers;
  final Map<String, dynamic> captain;
  final Map<String, dynamic> goalKeeper;

  Team(
    this.id,
    this.attackers,
    this.captain,
    this.goalKeeper, {
    this.name = 'Guest',
    this.logo = '',
    this.grade = '0',
    this.Class = '0',
    this.point = 0,
    this.diff = 0,
    this.stage = '',
    this.wines = 0,
    this.ties = 0,
    this.losses = 0,
  });

  Team.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        id = json['id'],
        grade = json['grade'],
        Class = json['class'],
        point = json['points'],
        diff = json['diff'],
        stage = json['stage'],
        wines = json['wins'],
        ties = json['ties'],
        logo = json['logo'],
        losses = json['losses'],
        attackers = json['attackers'],
        captain = json['captain'],
        goalKeeper = json['goalKeeper'];
}
