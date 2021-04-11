import 'package:flutter/material.dart';
import 'search-btn.dart';

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
      endDrawer: Container(
        width: 1000,
        child: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors
                .transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: Drawer(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 50),
                    child: ListTile(
                        title: Center(
                            child: Text('Home',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                )
                                // decoration: TextDecoration.underline),
                                )),
                        onTap: () {
                          Navigator.pop(context);
                          // Navigator.pushNamed(context, '/home');
                        }),
                  ),
                  ListTile(
                      title: Center(
                          child: Text(
                        'Like',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                        ),
                      )),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, '/like');
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Center(child: SearchButton()),
            Center(
              child: Text('Definition'),
            ),
            Center(
              child: Text('Picture'),
            ),
          ],
        ),
      ),
    );
  }
}

class LikeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Like'),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: Center(),
    );
  }
}
