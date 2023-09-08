class TeamTable {
  final Map<String, dynamic> teamTable;

  TeamTable(this.teamTable);

  TeamTable.fromJson(Map<String, dynamic> json) : teamTable = json;
}
