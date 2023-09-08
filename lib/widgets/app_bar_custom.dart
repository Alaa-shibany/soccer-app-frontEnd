import 'package:flutter/material.dart';

class AppBarCustom extends StatelessWidget {
  const AppBarCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 75,
          decoration: const BoxDecoration(
            color: Color.fromRGBO(37, 48, 106, 1),
          ),
        ),
        Opacity(
          opacity: 0.5,
          child: ClipPath(
            clipper: MyClipper1(),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(87, 101, 187, 1),
                    Color.fromRGBO(37, 48, 106, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.6,
          child: ClipPath(
            clipper: MyClipper2(),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(87, 101, 187, 1),
                    Color.fromRGBO(37, 48, 106, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.9,
          child: ClipPath(
            clipper: MyClipper3(),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(87, 101, 187, 1),
                    Color.fromRGBO(37, 48, 106, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
        Opacity(
          opacity: 0.3,
          child: ClipPath(
            clipper: MyClipper4(),
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(87, 101, 187, 1),
                    Color.fromRGBO(37, 48, 106, 1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, 0);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper3 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 1.3);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper4 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MyClipper5 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
