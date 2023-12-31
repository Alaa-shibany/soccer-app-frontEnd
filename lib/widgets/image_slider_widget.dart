import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../models/images.dart';
import '../styles/app_colors.dart';

class ImageSliderWidget extends StatefulWidget {
  const ImageSliderWidget({super.key, required this.mediaQuery});
  final Size mediaQuery;

  @override
  State<ImageSliderWidget> createState() => _ImageSliderWidgetState();
}

class _ImageSliderWidgetState extends State<ImageSliderWidget> {
  int activeIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          options: CarouselOptions(
            height: widget.mediaQuery.height / 5,
            autoPlay: true,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) => setState(() {
              activeIndex = index;
            }),
          ),
          itemCount: Images().imagesList.length,
          itemBuilder: (context, index, realIndex) {
            final urlImage = Images().imagesList[index];
            return buildImage(urlImage, index, widget.mediaQuery);
          },
        ),
        SizedBox(
          height: widget.mediaQuery.height / 90,
        ),
        buildIndicator(widget.mediaQuery),
      ],
    );
  }

  Widget buildImage(String urlImage, int index, Size mediaQuery) => Container(
        // margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 50),
        height: mediaQuery.height / 7,
        margin: EdgeInsets.symmetric(horizontal: mediaQuery.width / 30),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          child: SvgPicture.asset(urlImage, fit: BoxFit.fill),
        ),
      );

  Widget buildIndicator(Size mediaQuery) => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: Images().imagesList.length,
        effect: JumpingDotEffect(
          dotWidth: mediaQuery.width / 30,
          dotHeight: mediaQuery.height / 80,
          activeDotColor: AppColors.mainColor,
        ),
      );
}
