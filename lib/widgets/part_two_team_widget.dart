import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

class PartTwoTeamWidget extends StatelessWidget {
  const PartTwoTeamWidget(
      {super.key,
      required this.mediaQuery,
      required this.logo,
      required this.teamName,
      required this.teamPoints});
  final Size mediaQuery;
  final String logo;
  final String teamName;
  final String teamPoints;

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: mediaQuery.height / 20,
      width: double.infinity,
      margin: EdgeInsets.symmetric(
          horizontal: mediaQuery.width / 30, vertical: mediaQuery.height / 90),
      padding: EdgeInsets.symmetric(
          vertical: mediaQuery.height / 40, horizontal: mediaQuery.width / 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: NetworkImage(
              '${imagesUrl.url}$logo',
            ),
            fit: BoxFit.contain,
            alignment: Alignment.center,
            height: mediaQuery.height / 30,
          ),
          SizedBox(
            width: mediaQuery.width / 30,
          ),
          Text(
            teamName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
