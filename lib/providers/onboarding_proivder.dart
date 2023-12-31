import 'dart:async';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../styles/app_text_styles.dart';
import 'package:flutter/material.dart';

import '../services/base_services.dart';

class OnboardingProvider extends BaseProvider {
  int _currentImageIndex = 0;

  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;

  PageController _controller = PageController(initialPage: 0);
  PageController get controller => this._controller;

  void setcontroller(PageController value) {
    this._controller = value;
    // notifyListeners();
  }

  AutovalidateMode get autovalidateMode => _autovalidateMode;
  void autovalidateModetrue() {
    this._autovalidateMode = AutovalidateMode.always;
    notifyListeners();
  }

  final List<String> _imagePaths = [
    'images/onboardingScreen/1.jpg',
    'images/onboardingScreen/2.jpg',
    'images/onboardingScreen/3.jpg',
  ];

  List<String> _textsList = [
    "Fans vote",
    "Best player",
    "Champions",
  ];
  List<String> get TextsList => _textsList;

  List<String> _subTextsList = [
    "vote for team you like",
    "Be the best in match",
    "Win the tournament",
  ];
  List<String> get SubTextsList => _subTextsList;

  // ignore: unused_field
  late TypewriterAnimatedText _textsWidgets;
  // ignore: unused_field
  late TypewriterAnimatedText _subtextsWidgets;
  late Timer timer;
  void stSize(Size ssize) {
    size = ssize;
    notifyListeners();
  }

  getSubTextsList() {
    // _subTextsList = [];
    _subTextsList = [
      "Sub Title 1",
      "Sub Title 2",
      "Sub Title 3",
    ];
    notifyListeners();
  }

  getTextsList() {
    _textsList = [
      "Page Title 1",
      "Page Title 2",
      "Page Title 3",
    ];
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.dispose();
    timer.cancel();
    super.dispose();
  }

  int getCurrentPageIndex(PageController controller) {
    if (controller.positions.isNotEmpty) {
      final int? currentPage = controller.page?.toInt();

      return currentPage!;
    }
    return -1;
  }

  void changeController() {
    if (getCurrentPageIndex(_controller) == 2) {
      // _controller.jumpToPage(0);
      _controller.animateToPage(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      if (_controller.positions.isNotEmpty) {
        _controller.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    }
  }

  OnboardingProvider() {
    timer = Timer.periodic(Duration(seconds: 4), (timer) {
      _currentImageIndex = (_currentImageIndex + 1) % _imagePaths.length;
      changeController();

      // currentPage = nextPage();
      // _controller = PageController(initialPage: currentPage);

      notifyListeners();
    });
  }
  TypewriterAnimatedText get textWidgets =>
      _textsWidgets = TypewriterAnimatedText(
        TextsList[_currentImageIndex],
        textStyle: AppTextStyles.textTitleStyle,
        //duration: Duration(seconds: 2),
        // scalingFactor: 4,
        speed: Duration(milliseconds: 100),
      );
  TypewriterAnimatedText get subtextsWidgets =>
      _subtextsWidgets = TypewriterAnimatedText(
        SubTextsList[_currentImageIndex],
        textStyle: AppTextStyles.textSubTitleStyle,
        //duration: Duration(seconds: 2),
        // scalingFactor: 4,
        speed: Duration(milliseconds: 100),
      );
  // PageController get controller => _controller;
  int get index => _currentImageIndex;
  // IndicatorEffect get effect => _effect;
  // PageController get controller => _controller;
  String get currentImagePath => _imagePaths[_currentImageIndex];
}
