import 'package:collabhub/firebase_options.dart' show DefaultFirebaseOptions;
import 'package:collabhub/views/auth/login_page.dart';
import 'package:collabhub/views/project_listings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CollabHub',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.white,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.data == null) {
              return LoginScreen();
            } else {
              return ProjectListingsScreen();
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
