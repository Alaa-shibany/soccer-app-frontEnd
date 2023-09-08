class UserData {
  String? tokenType;

  UserData({this.tokenType});

  UserData.fromJson(Map<String, dynamic> json) : tokenType = json['tokenType'];
}
