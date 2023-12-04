import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:soccer_app_frontend/models/images_url.dart';

import '../screens/team_profile_screen.dart';
import '../server/auth_server.dart';
import '../widgets/heder_user_profile.dart';
import '../widgets/image_info_profile.dart';
import '../widgets/navigation_drawer.dart';
import '../widgets/profile_info_widget.dart';

class UserProfileScreen extends StatefulWidget {
  static const routName = '/user-profile-screen';
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  File? _image;

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
    // ignore: use_build_context_synchronously
    final id = ModalRoute.of(context)!.settings.arguments as int;
    try {
      await Provider.of<AuthServer>(context, listen: false).changeUserImage(
        id: id,
        image: _image,
        onlyDelete: 0,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushReplacementNamed(UserProfileScreen.routName, arguments: id);
    } catch (e) {
      print(e);
    }
  }

  Future _deleteImage() async {
    // ignore: use_build_context_synchronously
    final id = ModalRoute.of(context)!.settings.arguments as int;
    try {
      await Provider.of<AuthServer>(context, listen: false).deleteUserImage(
        id: id,
        onlyDelete: 1,
      );
      // ignore: use_build_context_synchronously
      Navigator.of(context).pop();
      Navigator.of(context)
          .pushReplacementNamed(UserProfileScreen.routName, arguments: id);
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
  void initState() {
    super.initState();

    Future.delayed(Duration.zero).then((value) => playerInfo(context));
  }

  Future<void> playerInfo(BuildContext context) async {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).playerData(
        id: id,
      );
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
    print('...............................print id');
    print(id);
    print('...........................................');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final userData = Provider.of<AuthServer>(context).user();
    final data = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
      extendBodyBehindAppBar: true,
      drawer: NavigationDrawerWidget(),
      backgroundColor: const Color.fromARGB(255, 202, 202, 202),
      body: _isLoading == true
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : data != -2
              ? CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      leading: Builder(
                        builder: (context) => Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: const Icon(
                                Icons.menu_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content:
                                    const Text('Choose what do you want to do'),
                                title: Text('Image picker'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      _pickImage();
                                    },
                                    child: const Text(
                                      'Change image',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _deleteImage();
                                    },
                                    child: const Text(
                                      'Delete image',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
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
                      flexibleSpace: LayoutBuilder(
                        builder: (p0, p1) {
                          final height = p1.biggest.height;
                          return FlexibleSpaceBar(
                            centerTitle: true,
                            background: HederUserProfile(
                              mediaQuery: mediaQuery,
                              // ignore: unnecessary_null_comparison
                              userData!.profilePicture == null
                                  ? Icon(
                                      CupertinoIcons.person,
                                      color:
                                          const Color.fromRGBO(37, 48, 106, 1),
                                      size: mediaQuery.height / 20,
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(360),
                                      child: Image(
                                        image: NetworkImage(
                                          '${imagesUrl.url}${userData.profilePicture}',
                                        ),
                                        fit: BoxFit.contain,
                                        alignment: Alignment.topCenter,
                                      ),
                                    ),
                              name: userData.name!,
                              subtitle: userData.position!,
                            ),
                            title: height < 100
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        //container for avatar
                                        padding: EdgeInsets.all(
                                            mediaQuery.height / 120),
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
                                        child: const Icon(
                                          CupertinoIcons.person,
                                          color: Color.fromRGBO(37, 48, 106, 1),
                                        ),
                                      ),
                                      SizedBox(
                                        width: mediaQuery.width / 30,
                                      ),
                                      Text(
                                        userData.name!,
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ],
                                  )
                                : null,
                          );
                        },
                      ),
                      pinned: true,
                      backgroundColor: const Color.fromRGBO(37, 48, 106, 1),
                      expandedHeight: mediaQuery.height / 3.2,
                      floating: false,
                    ),
                    SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          ImageInfoProfile(
                            title1: 'Goals',
                            mediaQuery: mediaQuery,
                            widget1: Container(
                              width: mediaQuery.width / 6,
                              height: mediaQuery.height / 9.5,
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/Goals.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            value1: userData!.goals.toString(),
                            title2: 'Assists',
                            widget2: Container(
                              width: mediaQuery.width / 6,
                              height: mediaQuery.height / 9.5,
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/Assists.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            value2: userData.assists.toString(),
                            title3: 'Saves',
                            widget3: Container(
                              width: mediaQuery.width / 6,
                              height: mediaQuery.height / 9.5,
                              child: const Image(
                                image: AssetImage(
                                  'assets/images/Saves.png',
                                ),
                                fit: BoxFit.contain,
                              ),
                            ),
                            value3: userData.saves.toString(),
                          ),
                          ProfileInfoWidget(
                              mediaQuery: mediaQuery, userData: userData),
                          //Tab on team to show info
                          GestureDetector(
                            onTap: () {
                              print(
                                  '...................................Tapping on team');
                              print(userData.team['id']);
                              print(
                                  '............................................');
                              Navigator.of(context).pushNamed(
                                TeamProfileScreen.routeName,
                                arguments: userData.team['id'],
                              );
                            },
                            child: Container(
                              // this container for team
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 10),
                              margin: const EdgeInsets.only(
                                  right: 15, left: 15, bottom: 10),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: ListTile(
                                leading: Container(
                                  //container for avatar
                                  height: mediaQuery.height / 9,
                                  width: mediaQuery.width / 9,
                                  padding:
                                      EdgeInsets.all(mediaQuery.height / 120),
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
                                  child: Container(
                                    child: Image(
                                      // height: mediaQuery.height / 30,
                                      image: NetworkImage(
                                        '${imagesUrl.url}${userData.team['logo']}',
                                      ),
                                      fit: BoxFit.contain,
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  userData.team['name'],
                                ),
                                trailing: Text(
                                  'See details',
                                  style: TextStyle(
                                      fontSize: mediaQuery.height / 70,
                                      color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          Container(height: mediaQuery.height / 35)
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Center(
                      child: Text('the profile just for player'),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('go back'))
                  ],
                ),
    );
  }
}
