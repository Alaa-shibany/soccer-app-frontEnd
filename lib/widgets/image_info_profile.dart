import 'package:flutter/material.dart';

class ImageInfoProfile extends StatelessWidget {
  const ImageInfoProfile({
    super.key,
    required this.mediaQuery,
    required this.widget1,
    required this.value1,
    required this.widget2,
    required this.value2,
    required this.widget3,
    required this.value3,
    required this.title1,
    required this.title2,
    required this.title3,
  });
  final String title1;
  final String title2;
  final String title3;
  final Size mediaQuery;
  final Widget widget1;
  final String value1;
  final Widget widget2;
  final String value2;
  final Widget widget3;
  final String value3;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(top: 10, right: 15, left: 15, bottom: 10),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          InfoCardForProfile(
            title: title1,
            mediaQuery: mediaQuery,
            widget: widget1,
            number: value1,
          ),
          InfoCardForProfile(
            title: title2,
            mediaQuery: mediaQuery,
            widget: widget2,
            number: value2,
          ),
          InfoCardForProfile(
            title: title3,
            mediaQuery: mediaQuery,
            widget: widget3,
            number: value3,
          ),
        ],
      ),
    );
  }
}

class InfoCardForProfile extends StatefulWidget {
  const InfoCardForProfile({
    super.key,
    required this.mediaQuery,
    required this.widget,
    required this.number,
    required this.title,
  });

  final Size mediaQuery;
  final Widget widget;
  final String number;
  final String title;

  @override
  State<InfoCardForProfile> createState() => _InfoCardForProfileState();
}

class _InfoCardForProfileState extends State<InfoCardForProfile>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    _fadeAnimation =
        Tween<double>(begin: 0, end: 1).animate(_animationController);

    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        width: widget.mediaQuery.width / 4.5,
        height: widget.mediaQuery.height / 6.5,
        // padding: const EdgeInsets.all(10),
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
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(
                    color: Color.fromARGB(255, 179, 134, 1),
                    fontWeight: FontWeight.bold,
                    fontSize: widget.mediaQuery.height / 90),
              ),
              SizedBox(
                height: widget.mediaQuery.height / 400,
              ),
              widget.widget,
              SizedBox(
                height: widget.mediaQuery.height / 400,
              ),
              Text(
                widget.number,
                style: TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                    fontSize: widget.mediaQuery.height / 50),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
