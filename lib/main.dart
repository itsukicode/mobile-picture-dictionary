import 'package:flutter/material.dart';
import 'like.dart';
import 'search_word_pic.dart';
import 'nav.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/home': (context) => HomeScreen(),
        '/like': (context) => LikeScreen(),
      },
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    );
  }
}
