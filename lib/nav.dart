import 'package:flutter/material.dart';

class NavigationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
