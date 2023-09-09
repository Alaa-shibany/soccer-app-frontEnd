import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

import '../screens/team_profile_screen.dart';

class SoccerTableLeague extends StatelessWidget {
  final String leagueName;
  final List<dynamic> teams;
  final Size mediaQuery;
  final int? id;

  SoccerTableLeague({
    required this.leagueName,
    required this.teams,
    required this.mediaQuery,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //this container for Class
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.center,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(87, 101, 187, 1),
                  Color.fromRGBO(37, 48, 106, 1),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                  spreadRadius: 0.5,
                  blurRadius: 3,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Text(
              leagueName,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          Table(
            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(6),
              2: FlexColumnWidth(3),
              3: FlexColumnWidth(3),
              4: FlexColumnWidth(3),
              5: FlexColumnWidth(3),
            },
            border: TableBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            children: [
              TableRow(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                children: const [
                  TableCell(child: Padding(padding: EdgeInsets.all(8.0))),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Team'),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('W'),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('T'),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('L'),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('P'),
                    ),
                  ),
                ],
              ),
              for (int i = 0; i < teams.length; i++)
                TableRow(
                  decoration: BoxDecoration(
                    color: id == -1
                        ? Colors.white
                        : teams[i]['id'] == id
                            ? Color.fromRGBO(138, 155, 236, 1)
                            : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color:
                            const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 3,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  children: [
                    TableCell(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            //container for avatar
                            height: mediaQuery.height / 18,
                            width: mediaQuery.width / 18,
                            padding: EdgeInsets.all(mediaQuery.height / 120),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 216, 216, 216),
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              child: Image(
                                image: NetworkImage(
                                  '${imagesUrl.url}/${teams[i]['logo']}',
                                ),
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                teams[i]['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${teams[i]['wins']}'),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${teams[i]['ties']}'),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${teams[i]['losses']}'),
                        ),
                      ),
                    ),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              TeamProfileScreen.routeName,
                              arguments: teams[i]['id']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('${teams[i]['points']}'),
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
