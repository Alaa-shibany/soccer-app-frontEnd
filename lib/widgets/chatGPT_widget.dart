import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../styles/app_colors.dart';

class FadeImageAnimation extends StatefulWidget {
  final List<String> imagePaths;
  final double screenHight;

  final int durationInMilliseconds;

  FadeImageAnimation({
    required this.imagePaths,
    this.durationInMilliseconds = 2000,
    required this.screenHight,
  });

  @override
  _FadeImageAnimationState createState() => _FadeImageAnimationState();
}

class _FadeImageAnimationState extends State<FadeImageAnimation>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(left: 10, right: 10),
      width: double.infinity,
      height: widget.screenHight / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.titleTextColor,
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
            spreadRadius: 0.01,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: FadeImageAnimation1(
        imagePaths: widget.imagePaths,
      ),
    );
  }
}

class FadeImageAnimation1 extends StatefulWidget {
  final List<String> imagePaths;
  final int durationInMilliseconds;

  const FadeImageAnimation1({
    super.key,
    required this.imagePaths,
    this.durationInMilliseconds = 2000,
  });

  @override
  // ignore: library_private_types_in_public_api
  _FadeImageAnimation1State createState() => _FadeImageAnimation1State();
}

class _FadeImageAnimation1State extends State<FadeImageAnimation1>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<double> _fadeOutAnimation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    print(
        "init state----------------------------------------------------------------");
    _fadeInAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _fadeOutAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );

    _controller.addStatusListener((status) {
      Future.delayed(const Duration(seconds: 4)).then((value) {
        if (status == AnimationStatus.completed) {
          _controller.reset();
          _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    print(
        "dispose---------------------------------------------------------------");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            Opacity(
              opacity: _fadeOutAnimation.value,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                child: SvgPicture.asset(widget.imagePaths[_currentIndex],
                    fit: BoxFit.fill),
              ),
            ),
            Opacity(
              opacity: _fadeInAnimation.value,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(15),
                ),
                child: SvgPicture.asset(
                    widget.imagePaths[
                        (_currentIndex + 1) % widget.imagePaths.length],
                    fit: BoxFit.fill),
              ),
            ),
          ],
        );
      },
    );
  }
}



// class FadeImageAnimation extends StatefulWidget {
//   final List<String> imagePaths;
//   final int duration;

//   FadeImageAnimation({required this.imagePaths, this.duration = 5});

//   @override
//   _FadeImageAnimationState createState() => _FadeImageAnimationState();
// }

// class _FadeImageAnimationState extends State<FadeImageAnimation>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   int _currentImageIndex = 0;

//   @override
//   void initState() {
//     super.initState();

//     _controller =
//         AnimationController(vsync: this, duration: Duration(seconds: 2));

//     _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

//     _controller.forward();

//     _controller.addStatusListener((status) {
//       if (status == AnimationStatus.completed) {
//         setState(() {
//           _currentImageIndex =
//               (_currentImageIndex + 1) % widget.imagePaths.length;
//         });
//         _controller.reset();
//         _controller.forward();
//       }
//     });

//     Timer.periodic(Duration(seconds: 3), (timer) {
//       _controller.forward();
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Stack(
//         children: [
//           FadeTransition(
//             opacity: _animation,
//             child: Image.asset(
//               widget.imagePaths[_currentImageIndex],
//               fit: BoxFit.cover,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }





// class ImageCycleWidget extends StatefulWidget {
//   @override
//   _ImageCycleWidgetState createState() => _ImageCycleWidgetState();
// }

// class _ImageCycleWidgetState extends State<ImageCycleWidget>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   int _currentIndex = 0;
//   List<String> _imagePaths = [
//     'assets/images/show1.png',
//     'assets/images/show2.png',
//     'assets/images/show3.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 500),
//     );
//     _animation = FadeTransition().animate(_controller);
//     _controller.repeat(reverse: false);
//     Timer.periodic(Duration(seconds: 2), (Timer timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % _imagePaths.length;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _animation,
//       child: Image.asset(
//         _imagePaths[_currentIndex],
//         fit: BoxFit.cover,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }



// import 'dart:async';

// import 'package:flutter/material.dart';

// class ImageLoopWidget extends StatefulWidget {
//   @override
//   _ImageLoopWidgetState createState() => _ImageLoopWidgetState();
// }

// class _ImageLoopWidgetState extends State<ImageLoopWidget> {
//   int _currentIndex = 0;
//   List<String> _imageUrls = [
//     'assets/images/show1.png',
//     'assets/images/show2.png',
//     'assets/images/show3.png',
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _startTimer();
//   }

//   void _startTimer() {
//     Timer.periodic(Duration(seconds: 2), (timer) {
//       setState(() {
//         _currentIndex = (_currentIndex + 1) % _imageUrls.length;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         height: 200,
//         width: double.infinity,
//         child: Image(
//           image: AssetImage(
//             _imageUrls[_currentIndex],
//           ),
//           fit: BoxFit.fill,
//         ));
//   }
// }
