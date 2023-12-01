import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

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
    final textSize = mediaQuery.height / 70;
    final imageSize = mediaQuery.height / 18;
    return Container(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(
                    '${imagesUrl.url}${teamLogoUrl1}',
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
              width: mediaQuery.width / 20,
            ),
            center,
            SizedBox(
              width: mediaQuery.width / 20,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: NetworkImage(
                    '${imagesUrl.url}${teamLogoUrl2}',
                  ),
                  fit: BoxFit.contain,
                  height: imageSize,
                  alignment: Alignment.center,
                ),
                Text(
                  teamName2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: textSize),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
