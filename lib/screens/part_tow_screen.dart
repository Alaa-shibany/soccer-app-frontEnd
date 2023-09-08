import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class PartTowScreen extends StatelessWidget {
  static const String routName = '/part-tow';
  const PartTowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('We will show the part tow here soon'),
      ),
    );
  }
}
