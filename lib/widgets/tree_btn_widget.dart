import 'package:flutter/material.dart';
import 'package:soccer_app_frontend/styles/app_colors.dart';

// ignore: must_be_immutable
class TreeButtonWidget extends StatelessWidget {
  TreeButtonWidget(
      {super.key,
      required this.mediaQuery,
      required this.btnText,
      required this.onTap});
  final Size mediaQuery;
  final String btnText;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 10),
        width: double.infinity,
        height: mediaQuery.height / 10,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: AppColors.mainColor,
              offset: const Offset(0, 3),
              blurRadius: 8,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            const ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              child: Image(
                image: AssetImage('assets/images/cup.png'),
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Text(
              btnText,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.width / 20),
            )
          ],
        ),
      ),
    );
  }
}
