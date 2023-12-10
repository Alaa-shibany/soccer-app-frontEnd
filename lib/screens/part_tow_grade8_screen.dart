import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

import '../common_widgets/BackgroundPaint.dart';
import '../server/auth_server.dart';
import '../widgets/app_bar_custom.dart';
import '../widgets/navigation_drawer.dart';

class PartTowGrade8Screen extends StatefulWidget {
  const PartTowGrade8Screen({super.key});
  static const String routeName = '/part-tow-grade-8-screen';

  @override
  State<PartTowGrade8Screen> createState() => _PartTowGrade8ScreenState();
}

class _PartTowGrade8ScreenState extends State<PartTowGrade8Screen> {
  bool _isLoading = false;
  File? _image;
  Map<String, dynamic> leagueData = {};

  Future<void> getData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).League();
      setState(() {
        leagueData = AuthServer.leagueResponse;
        print(leagueData);
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? imgPath = File(image.path);
      imgPath = await _cropImage(imageFile: imgPath);

      setState(() {
        _image = imgPath;
      });
    } on PlatformException catch (e) {
      print(e);
    }
    try {
      await Provider.of<AuthServer>(context, listen: false).uploadPartTowTree(
        image: _image,
        forGrade: 8,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(
        PartTowGrade8Screen.routeName,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<File?> _cropImage({required File imageFile}) async {
    CroppedFile? croppedImage =
        await ImageCropper().cropImage(sourcePath: imageFile.path);
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    return _isLoading
        ? Scaffold(
            extendBodyBehindAppBar: true,
            drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(this.context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Stack(
              children: [
                CustomPaint(
                  //this for the background
                  size: Size(
                    mediaQuery.width,
                    mediaQuery.height,
                    // (screenWidth * 2.1434668500180276)
                    //     .toDouble()
                  ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: Background(),
                ),
                const Positioned(
                  // top: 0,
                  child: AppBarCustom(),
                ),
                Center(
                  child: Lottie.asset(
                      width: mediaQuery.width / 3,
                      'assets/lotties/loading.json'),
                ),
              ],
            ),
          )
        : Scaffold(
            drawer: NavigationDrawerWidget(),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              actions: [
                AuthServer.userData == 'admin'
                    ? IconButton(
                        icon: const Icon(Icons.edit),
                        color: Colors.white,
                        onPressed: () {
                          print('change image');
                          _pickImage();
                        },
                      )
                    : const SizedBox(
                        width: 0,
                      ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ),
              ],
              leading: Builder(
                builder: (context) => IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.menu_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            body: Stack(
              children: [
                CustomPaint(
                  //this for the background
                  size: Size(
                    mediaQuery.width,
                    mediaQuery.height,
                    // (screenWidth * 2.1434668500180276)
                    //     .toDouble()
                  ), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
                  painter: Background(),
                ),
                Column(
                  children: [
                    const AppBarCustom(),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(
                          vertical: mediaQuery.height / 20,
                          horizontal: mediaQuery.width / 50),
                      height: mediaQuery.height / 1.5,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black45,
                            offset: Offset(0, 3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: leagueData.containsKey('treeUrileague(8)')
                          ? Image(
                              image: NetworkImage(
                                '${imagesUrl.url}${leagueData['treeUrileague(8)']}}',
                              ),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hmmmm..you still here',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text('No data for you'),
                              ],
                            ),
                    )
                  ],
                ),
              ],
            ),
          );
  }
}
