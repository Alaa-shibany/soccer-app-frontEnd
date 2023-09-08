import '/screens/admin_add_matches_screen.dart';
import '/screens/admin_create_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../server/auth_server.dart';

class AdminMatchesScreen extends StatefulWidget {
  const AdminMatchesScreen({super.key});
  static const String routName = '/admin-matches-screen';

  @override
  State<AdminMatchesScreen> createState() => _AdminMatchesScreenState();
}

class _AdminMatchesScreenState extends State<AdminMatchesScreen>
    with TickerProviderStateMixin {
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
        content: const Text('Are you sure you want to start auto mathcing ???'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<AuthServer>(context, listen: false).AutoMatching();
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
            child: const Text('Start'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancle'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Button Column'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Action for Button 1
                Navigator.of(context)
                    .pushNamed(AdminAddingMatchesScreen.routName);
              },
              child: Text('Part one matches'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => adminCreateMatchScreen()));
              },
              child: const Text('Create match'),
            ),
            ElevatedButton(
              onPressed: () {
                // Action for Button 3
                showDialogError();
              },
              child: const Text('Auto match making'),
            ),
          ],
        ),
      ),
    );
  }
}
