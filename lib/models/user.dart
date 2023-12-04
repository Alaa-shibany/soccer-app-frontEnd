class User {
  final int? id;
  final String? name;
  final int? score;
  final int? honor;
  final int? prediction;
  final int? goals;
  final int? saves;
  final int? assists;
  final int? defences;
  final String? position;
  final int? cards;
  final Map<String, dynamic> team;
  final String? profilePicture;

  User(this.team, this.id, this.profilePicture,
      {this.score = 0,
      this.honor = 0,
      this.prediction = 0,
      this.goals = 0,
      this.saves = 0,
      this.assists = 0,
      this.defences = 0,
      this.position = 'no position',
      this.cards = 0,
      this.name = 'Guest'});

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        score = json['score'],
        honor = json['honor'],
        prediction = json['prediction'],
        goals = json['goals'],
        saves = json['saves'],
        assists = json['assists'],
        defences = json['defences'],
        position = json['position'],
        cards = json['cards'],
        team = json['team'],
        profilePicture = json['profilePicture'];
}
