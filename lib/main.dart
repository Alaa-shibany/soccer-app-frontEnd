import 'package:soccer_app_frontend/screens/transfare_admin_screen.dart';

import '../providers/Model_provider.dart';
import '../providers/base_provider.dart';
import '../providers/onboarding_proivder.dart';
import '../screens/admin_matches_screen.dart';
import '../screens/part_one_admin_screen.dart';
import '../screens/show_finished_match_scree.dart';
import '../screens/show_unfinshed_mathch_screen.dart';
import '../screens/start_match_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import './screens/home_screen.dart';
import './screens/auth_screen.dart';
import './screens/user_profile_screen.dart';
import './screens/upload_flie_screen.dart';
import './server/auth_server.dart';
import './models/league_part_settings.dart';
import './screens/admin_add_matches_screen.dart';
import './screens/all_matches_screen.dart';
import './screens/event_screen.dart';
import './screens/part_one_screen.dart';
import './screens/part_tow_screen.dart';
import './screens/team_profile_screen.dart';
import './screens/test.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthServer(context: context),
        ),
        ChangeNotifierProvider.value(
          value: LeaguePartSettings(),
        ),
        ChangeNotifierProvider<BaseProvider>(create: (_) => BaseProvider()),
        ChangeNotifierProvider<OnboardingProvider>(
            create: (_) => OnboardingProvider()),
        ChangeNotifierProvider<ModelProvider>(create: (_) => ModelProvider()),
      ],
      child: Consumer<AuthServer>(
        builder: (context, value, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            primarySwatch: Colors.blue,
            tabBarTheme: const TabBarTheme(
              labelColor: Color.fromRGBO(37, 48, 106, 1),
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(37, 48, 106, 1),
              ), // color for text
              // overlayColor: ,
              indicator: UnderlineTabIndicator(
                // color for indicator (underline)
                borderSide: BorderSide(
                  color: Color.fromRGBO(37, 48, 106, 1),
                ),
              ),
            ),
          ),
          home: value.authenticated ? const HomeScreen() : OnboardingScreen(),
          routes: {
            OnboardingScreen.routeName: (context) => OnboardingScreen(),
            TeamProfileScreen.routeName: (context) => const TeamProfileScreen(),
            UserProfileScreen.routName: (context) => const UserProfileScreen(),
            HomeScreen.routName: (context) => const HomeScreen(),
            UploadFildScreen.routName: (context) => UploadFildScreen(),
            Test.routName: (context) => Test(),
            PartOneScreen.routeName: (context) => const PartOneScreen(),
            EventScreen.routName: (context) => EventScreen(),
            PartTowScreen.routName: (context) => const PartTowScreen(),
            AllMatchesScreen.routName: (context) => const AllMatchesScreen(),
            AdminAddingMatchesScreen.routName: (context) =>
                const AdminAddingMatchesScreen(),
            AdminMatchesScreen.routName: (context) =>
                const AdminMatchesScreen(),
            StartMatchScreen.routName: (context) => StartMatchScreen(),
            PartOneAdminScreen.routeName: (context) => PartOneAdminScreen(),
            ShowFinishedMatchScreen.routName: (context) =>
                const ShowFinishedMatchScreen(),
            ShowUnFinishedMatchScreen.routName: (context) =>
                const ShowUnFinishedMatchScreen(),
            adminTransfareScreen.routeName: (context) =>
                const adminTransfareScreen(),
          },
        ),
      ),
    );
  }
}
