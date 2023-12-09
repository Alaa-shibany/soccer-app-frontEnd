import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

class MatchPartTowWidget extends StatelessWidget {
  const MatchPartTowWidget({
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
      margin: EdgeInsets.symmetric(vertical: mediaQuery.height / 100),
      width: double.infinity,
      alignment: Alignment.center,
      height: mediaQuery.height / 10,
      decoration: BoxDecoration(
        color: matchType == 1 ? Colors.white : Colors.amber,
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        boxShadow: const [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      // padding: const EdgeInsets.all(16.0),
      child: Stack(
        children: [
          const Opacity(
            opacity: 0.4,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Image(
                image: AssetImage('assets/images/partTowMatch.png'),
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Text(
                      teamName1,
                      maxLines: 2,
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
                      '${imagesUrl.url}${teamLogoUrl1}',
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
                      '${imagesUrl.url}${teamLogoUrl2}',
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
                      maxLines: 2,
                      // overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: textSize),
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
          ),
        ],
      ),
    );
  }
}
