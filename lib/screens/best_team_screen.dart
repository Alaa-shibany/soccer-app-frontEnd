import 'package:flutter/material.dart';

class BestTeamScreen extends StatelessWidget {
  const BestTeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Best Team will show here soon'),
      ),
    );
  }
}
