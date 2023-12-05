import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

import '../styles/app_colors.dart';
import '../styles/app_text_styles.dart';

// ignore: camel_case_types
class headProfileWidget extends StatelessWidget {
  const headProfileWidget(
      {super.key,
      required this.screenHight,
      required this.screenWidth,
      required this.icon,
      required this.nameColor,
      required this.circleColor,
      required this.name,
      required this.subTitle,
      required this.profilePicture});

  final double screenHight;
  final double screenWidth;
  final Icon icon;
  final String name;
  final String subTitle;
  final String? profilePicture;
  final Color nameColor;
  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //this container for user image
        Container(
          //first layer light blue
          padding: const EdgeInsets.all(3),
          height: MediaQuery.of(context).size.height / 15,
          width: MediaQuery.of(context).size.width / 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.lightBlue,
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 0.11,
                blurRadius: 3,
                offset: const Offset(0, 1), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            //second layer white
            // height: MediaQuery.of(context).size.height / 20,
            // width: MediaQuery.of(context).size.height / 20,
            // padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: circleColor,
            ),
            child: profilePicture == null
                ? Center(
                    child: icon,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: Image(
                      image: NetworkImage(
                        '${imagesUrl.url}$profilePicture',
                      ),
                      fit: BoxFit.contain,
                      alignment: Alignment.topCenter,
                    ),
                  ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        //this column for student name&grade
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              name,
              style: TextStyle(
                  color: nameColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Euclid Circular A'),
            ),
            Text(
              subTitle,
              style: AppTextStyles.profile2,
            )
          ],
        )
      ],
    );
  }
}
