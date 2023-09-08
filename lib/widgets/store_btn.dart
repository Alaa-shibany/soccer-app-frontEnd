import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../server/auth_server.dart';

class StoreBtn extends StatelessWidget {
  StoreBtn({
    super.key,
    required this.mediaQuery,
  });

  showToastMassage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black54,
        fontSize: 15);
  }

  final Size mediaQuery;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (Provider.of<AuthServer>(context, listen: false)
                .leagueStatue()!
                .currentStage !=
            'PART TOW') {
          showToastMassage('Store open on part tow');
        } else {
          print('hi');
        }
      },
      child: Container(
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
          Icons.store_mall_directory_rounded,
          color: const Color.fromRGBO(37, 48, 106, 1),
          size: mediaQuery.height / 30,
        ),
      ),
    );
  }
}
