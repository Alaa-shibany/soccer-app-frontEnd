import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBtn extends StatelessWidget {
  SearchBtn({
    super.key,
    required this.mediaQuery,
  });

  final Size mediaQuery;
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(
      //     top: mediaQuery.height / 40, left: mediaQuery.height / 40),
      height: mediaQuery.height / 9,
      width: mediaQuery.width / 9,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black45,
            offset: Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        CupertinoIcons.search,
        color: const Color.fromRGBO(37, 48, 106, 1),
        size: mediaQuery.height / 30,
      ),
    );
  }
}
