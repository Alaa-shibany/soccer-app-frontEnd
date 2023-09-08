// import 'dart:js';

import 'dart:io';

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
      File _exclFile;

      FilePickerResult? resultFile = await FilePicker.platform.pickFiles();
      if (resultFile != null) {
        if (resultFile.files.first.extension != 'xlsx') {
          showToastMassage('You must select an excl file');
          return;
        }

        _exclFile = File(resultFile.files.single.path!);
        setState(() {
          widget._isLoading = true;
        });
        try {
          await Provider.of<AuthServer>(context, listen: false)
              .uploadData(_exclFile);
          print(_exclFile.uri);
          // showToastMassage('Success');
        } catch (e) {
          print(e);
        }
        setState(() {
          widget._isLoading = false;
        });
      } else {
        showToastMassage('You have to select an excl file');
      }
    }

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: TextButton(
          child: const Text('upload excl flile'),
          onPressed: () {
            openFilePicker();
          },
        ),
      ),
    );
  }
}
