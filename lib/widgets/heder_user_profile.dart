import 'package:flutter/material.dart';

class HederUserProfile extends StatelessWidget {
  const HederUserProfile(
    this._image, {
    super.key,
    required this.mediaQuery,
    required this.name,
    required this.subtitle,
  });

  final Size mediaQuery;
  final String name;
  final String subtitle;
  final Widget _image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          //this container for background header
          // margin: const EdgeInsets.only(left: 15, right: 15),
          width: double.infinity,
          height: mediaQuery.height / 3,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color.fromRGBO(87, 101, 187, 1),
                Color.fromRGBO(37, 48, 106, 1),
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Image(
                image: AssetImage(
                  'assets/images/userHader.png',
                ),
                opacity: AlwaysStoppedAnimation(.08),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              ListView(
                //this list for row , avatar , name
                children: <Widget>[
                  Container(
                    //container for avatar
                    margin: EdgeInsets.only(top: mediaQuery.height / 20),
                    height: mediaQuery.height / 7,
                    width: mediaQuery.width / 7,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color.fromRGBO(37, 48, 106, 1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 3),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Container(
                      height: mediaQuery.height / 3.5,
                      width: mediaQuery.width / 3.5,
                      alignment: Alignment.center,
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
                      child: _image,
                    ),
                  ),
                  SizedBox(
                    height: mediaQuery.height / 90,
                  ),
                  Container(
                    //container for name
                    // margin: const EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: mediaQuery.height / 50,
                          ),
                        ),
                        SizedBox(
                          height: mediaQuery.height / 150,
                        ),
                        // SizedBox(
                        //   height: mediaQuery.height / 150,
                        // ),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: mediaQuery.height / 60,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
