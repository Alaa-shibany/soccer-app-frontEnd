// import 'dart:js';

import 'dart:io';

import 'package:soccer_app_frontend/styles/app_colors.dart';

import '/server/auth_server.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class UploadFildScreen extends StatefulWidget {
  static const routName = '/upload-file-screen';
  // ignore: unused_field
  bool _isLoading = false;

  @override
  State<UploadFildScreen> createState() => _UploadFildScreenState();
}

class _UploadFildScreenState extends State<UploadFildScreen> {
  showToastMassage(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.black54,
        fontSize: 15);
  }

  // bool downloading = false;
  // String progressString = '';
  // String downloadedPath = '';

  // Future<bool> getStoragePermission() async {
  //   return await Permission.storage.request().isGranted;
  // }

  // Future<String> getDownloadedFilePath() async {
  //   return await ExternalPath.getExternalStoragePublicDirectory(
  //       ExternalPath.DIRECTORY_DOWNLOADS);
  // }

  // Future downloadFile(String downloadDirectory) async {
  //   Dio dio = Dio();
  //   var downloadedFilePath = '$downloadedPath/response.xlsx';
  //   try {
  //     await dio.download(
  //       "/excelInput",
  //       downloadedFilePath,
  //       onReceiveProgress: (count, total) {
  //         print('REC: $count , TOTAL: $total');
  //         setState(() {
  //           downloading = true;
  //           progressString = ((count / total) * 100).toStringAsFixed(0) + '%';
  //         });
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  //   await Future.delayed(const Duration(seconds: 3));

  //   return downloadedFilePath;
  // }

  // Future<void> doDownloadedFile() async {
  //   if (await getStoragePermission()) {
  //     String downloadDirectory = await getDownloadedFilePath();
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    Future<void> openFilePicker() async {
      File? _exclFile;
      //  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image == null) return;
      // File? imgPath = File(image.path);
      // imgPath = await _cropImage(imageFile: imgPath);
      // setState(() {
      //   _image = imgPath;
      // });

      FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
      if (resultFile != null) {
        setState(() {
          _exclFile = File(resultFile.files.single.path!);
        });
        setState(() {
          widget._isLoading = true;
        });
        try {
          // ignore: use_build_context_synchronously
          await Provider.of<AuthServer>(context, listen: false)
              .uploadData(_exclFile!);
          showToastMassage('Success');
          setState(() {
            widget._isLoading = false;
          });
        } catch (e) {
          print(e);
        }
      } else {
        showToastMassage('You have to select an excl file');
      }
    }

    void showDialogError() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Text(
                'Admin things',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.admin_panel_settings,
                color: Colors.amber,
              )
            ],
          ),
          content:
              const Text('Are you sure you want to RESTART the league ???'),
          actions: [
            TextButton(
              onPressed: () {
                Provider.of<AuthServer>(context, listen: false).restartLeague();
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Center(
                        child: Icon(
                      Icons.info,
                      color: Colors.amber,
                      size: 45,
                    )),
                    content: Text(AuthServer.message),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cancle'))
                    ],
                  ),
                );
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancle'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(),
      body: widget._isLoading
          ? const Center(
              child: SingleChildScrollView(),
            )
          : Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: Text(
                      'Pick excel file',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          AppColors.ProfileColor),
                    ),
                    onPressed: () {
                      openFilePicker();
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 20,
                  ),
                  ElevatedButton(
                    child: Text(
                      'Restart league',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {
                      showDialogError();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
