import 'package:flutter/material.dart';
import 'like.dart';
import 'search_word_pic.dart';
import 'nav.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async =>
    {WidgetsFlutterBinding.ensureInitialized(), runApp(MyApp())};

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _fbApp,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print("Error has occured ${snapshot.error.toString()}");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return HomeScreen();
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeScreen(),
        '/like': (context) => LikeScreen(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text('Picture Dictionary'),
          centerTitle: true,
          backgroundColor: Colors.pink[100],
        ),
        endDrawer: NavigationBar(),
        body: Container(
          padding: EdgeInsets.all(25),
          child: SearchWordPic(),
        ),
      ),
    );
  }
}
