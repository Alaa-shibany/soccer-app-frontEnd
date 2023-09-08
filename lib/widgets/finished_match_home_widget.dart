import 'package:flutter/material.dart';

class FinishedMatchWidget extends StatelessWidget {
  const FinishedMatchWidget({
    super.key,
    required this.teamLogoUrl1,
    required this.teamName1,
    required this.teamLogoUrl2,
    required this.teamName2,
    required this.center,
    required this.mediaQuery,
    required this.matchType,
  });
  final String teamLogoUrl1;
  final String teamName1;
  final String teamLogoUrl2;
  final String teamName2;
  final Widget center;
  final Size mediaQuery;
  final int matchType;

  @override
  Widget build(BuildContext context) {
    final textSize = mediaQuery.height / 50;
    final imageSize = mediaQuery.height / 15;
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: NetworkImage(
                  'https://bdh.point-dev.nl/${teamLogoUrl1}',
                ),
                height: imageSize,
                fit: BoxFit.contain,
                alignment: Alignment.center,
              ),
              Text(
                teamName1,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: textSize,
                ),
              ),
            ],
          ),
          SizedBox(
            width: mediaQuery.width / 10,
          ),
          center,
          SizedBox(
            width: mediaQuery.width / 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(
                image: NetworkImage(
                  'https://bdh.point-dev.nl/${teamLogoUrl2}',
                ),
                fit: BoxFit.contain,
                height: imageSize,
                alignment: Alignment.center,
              ),
              Text(
                teamName2,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: textSize),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
