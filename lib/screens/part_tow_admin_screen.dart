import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soccer_app_frontend/server/auth_server.dart';
import 'package:soccer_app_frontend/styles/app_colors.dart';

class PartTwoScreen extends StatefulWidget {
  @override
  _PartTwoScreenState createState() => _PartTwoScreenState();
}

class _PartTwoScreenState extends State<PartTwoScreen> {
  int grade7Advanced = 0;
  int grade8Advanced = 0;
  int grade9Advanced = 0;
  Future<void> submit(String grade7, String grade8, String grade9) async {
    try {
      await Provider.of<AuthServer>(context, listen: false)
          .startPartTow(grade7, grade8, grade9);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Start part tow',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.mainColor,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: MediaQuery.of(context).size.width / 40),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 40),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ListTile(
                title: const Text('Grade 7 qualifying'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade7Advanced < 1 ? null : grade7Advanced--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(grade7Advanced.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade7Advanced++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 40),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ListTile(
                title: const Text('Grade 8 qualifying'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade8Advanced < 1 ? null : grade8Advanced--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(grade8Advanced.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade8Advanced++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 80,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 40),
              decoration: const BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: ListTile(
                title: const Text('Grade 9 qualifying'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade9Advanced < 1 ? null : grade9Advanced--;
                        });
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(grade9Advanced.toString()),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          grade9Advanced++;
                        });
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  print('grad 7 => $grade7Advanced');
                  print('grad 8 => $grade8Advanced');
                  print('grad 9 => $grade9Advanced');
                  submit(
                    grade7Advanced.toString(),
                    grade8Advanced.toString(),
                    grade9Advanced.toString(),
                  );
                },
                child: const Text('Submit'))
          ],
        ),
      ),
    );
  }
}
