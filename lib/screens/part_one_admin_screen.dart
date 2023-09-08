import '/server/auth_server.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PartOneAdminScreen extends StatefulWidget {
  static const String routeName = '/part-one-admin-screen';
  @override
  _PartOneAdminScreenState createState() => _PartOneAdminScreenState();
}

class _PartOneAdminScreenState extends State<PartOneAdminScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _question1Controller = TextEditingController();
  TextEditingController _question2Controller = TextEditingController();
  String _dateTime = '';
  String _title = '';
  String _question1 = '';
  String _question2 = '';
  bool _isLoading = false;

  void _showDatePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020),
            lastDate: DateTime(3000))
        .then((value) {
      setState(() {
        _dateTime = '${value!.day}-${value.month}-${value.year}';
        print('..............................................');
        print(_dateTime);
        print('..............................................');
      });
    });
  }

  Future<void> _saveData() async {
    print('welcome');
    setState(() {
      _title = _titleController.text;
      _question1 = _question1Controller.text;
      _question2 = _question2Controller.text;
    });

    // You can perform further actions with the saved data
    print('dateTime --> $_dateTime');
    print('title --> $_title');
    print('question1 --> $_question1');
    print('question2 --> $_question2');
    // sendData();
  }

  Future<void> sendData() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthServer>(context, listen: false).AdvanceToPartOne(
          title: _title,
          startDate: _dateTime,
          predictionQuestion1: _question1,
          predictionQuestion2: _question2);
      setState(() {
        _isLoading = false;
      });
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
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Information'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _question1Controller,
                          decoration: InputDecoration(labelText: 'Question 1'),
                        ),
                        TextField(
                          controller: _question2Controller,
                          decoration: InputDecoration(labelText: 'Question 2'),
                        ),
                        SizedBox(height: 16.0),
                        Row(
                          children: [
                            const Text('Selected Date to start:'),
                            const SizedBox(width: 8.0),
                            GestureDetector(
                              onTap: () => _showDatePicker(),
                              child: Text(
                                _dateTime != '' ? _dateTime : 'Pick a date',
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            print('hello');
                            setState(() {
                              _title = _titleController.text;
                              _question1 = _question1Controller.text;
                              _question2 = _question2Controller.text;
                            });

                            // You can perform further actions with the saved data
                            print('dateTime --> $_dateTime');
                            print('title --> $_title');
                            print('question1 --> $_question1');
                            print('question2 --> $_question2');
                            sendData();
                            // _saveData;
                          },
                          child: Text('Save'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
