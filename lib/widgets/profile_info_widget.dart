import '/models/user.dart';
import 'package:flutter/material.dart';

class ProfileInfoWidget extends StatelessWidget {
  const ProfileInfoWidget({
    super.key,
    required this.mediaQuery,
    required this.userData,
  });

  final Size mediaQuery;
  final User? userData;
  @override
  Widget build(BuildContext context) {
    return Container(
      // this container for info
      margin: const EdgeInsets.only(right: 15, left: 15, bottom: 10),
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

      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ForDitails(
              title: 'Score',
              imageUrl: '',
              value: userData!.score.toString(),
            ),
            ForDitails(
              title: 'Honor',
              imageUrl: '',
              value: userData!.honor.toString(),
            ),
            ForDitails(
              title: 'Prediction',
              imageUrl: '',
              value: userData!.prediction.toString(),
            ),
            ForDitails(
              title: 'Goals',
              imageUrl: '',
              value: userData!.goals.toString(),
            ),
            ForDitails(
              title: 'Saves',
              imageUrl: '',
              value: userData!.saves.toString(),
            ),
            ForDitails(
              title: 'Assists',
              imageUrl: '',
              value: userData!.assists.toString(),
            ),
            ForDitails(
              title: 'Defences',
              imageUrl: '',
              value: userData!.defences.toString(),
            ),
            ForDitails(
              title: 'Cards',
              imageUrl: '',
              value: userData!.cards.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class ForDitails extends StatefulWidget {
  final String title;
  final String value;
  final String imageUrl;

  ForDitails(
      {required this.title, required this.value, required this.imageUrl});

  @override
  _TitleValueWidgetState createState() => _TitleValueWidgetState();
}

class _TitleValueWidgetState extends State<ForDitails>
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
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                color: Color.fromRGBO(37, 48, 106, 1),
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'RobotoSlab',
              ),
            ),
            Row(
              children: [
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: const Image(
                      image: AssetImage('assets/images/score.png'),
                      fit: BoxFit.contain),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.value,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color.fromRGBO(37, 48, 106, 1),
                    fontWeight: FontWeight.bold,
                    fontFamily: 'RobotoSlab',
                  ),
                ),
              ],
            ),
          ],
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
