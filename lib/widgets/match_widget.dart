import 'package:flutter/material.dart';

class MatchWidget extends StatelessWidget {
  const MatchWidget({
    super.key,
    required this.teamLogoUrl1,
    required this.teamName1,
    required this.teamLogoUrl2,
    required this.teamName2,
    required this.center,
    required this.customWidget,
    required this.user,
    required this.mediaQuery,
    required this.matchType,
  });
  final String teamLogoUrl1;
  final String teamName1;
  final String teamLogoUrl2;
  final String teamName2;
  final Widget center;
  final Widget customWidget;
  final String user;
  final Size mediaQuery;
  final int matchType;

  @override
  Widget build(BuildContext context) {
    final textSize = mediaQuery.height / 60;
    final imageSize = mediaQuery.height / 30;
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: matchType == 1 ? Colors.white : Colors.amber,
      ),
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              child: Text(
                teamName1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textSize,
                ),
              ),
            ),
            SizedBox(
              width: mediaQuery.width / 30,
            ),
            Image(
              image: NetworkImage(
                'https://bdh.point-dev.nl/${teamLogoUrl1}',
              ),
              height: imageSize,
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            SizedBox(
              width: mediaQuery.width / 30,
            ),
            center,
            SizedBox(
              width: mediaQuery.width / 30,
            ),
            Image(
              image: NetworkImage(
                'https://bdh.point-dev.nl/${teamLogoUrl2}',
              ),
              fit: BoxFit.contain,
              height: imageSize,
              alignment: Alignment.center,
            ),
            SizedBox(
              width: mediaQuery.width / 30,
            ),
            SizedBox(
              width: mediaQuery.width / 8,
              child: Text(
                teamName2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
              ),
            ),
            user == 'admin'
                ? Container(
                    margin: EdgeInsets.only(left: mediaQuery.width / 30),
                    child: customWidget)
                : const SizedBox(
                    width: 0,
                  ),
          ],
        ),
      ),
    );
  }
}
