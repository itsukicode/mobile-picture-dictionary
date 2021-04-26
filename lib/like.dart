import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import 'word.dart';

class LikeScreen extends StatefulWidget {
  @override
  _LikeScreenState createState() => _LikeScreenState();
}

class _LikeScreenState extends State<LikeScreen> {
  final Widget emptyWidget = new Container(width: 0, height: 0);

  void playAudio(String audioURL) async {
    print(audioURL);
    AudioPlayer audioPlayer = AudioPlayer();
    int result = await audioPlayer.play(audioURL);
    print(result);
    if (result == 1) {
      print('success audio');
    } else {
      print('not success audio');
    }
  }

  Widget _buildWordAndAudio(String word, String audio) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Row(
        children: [
          Text(
            word,
            style: TextStyle(fontSize: 28),
          ),
          IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                playAudio(audio);
              }),
          IconButton(
              icon: Icon(Icons.book),
              onPressed: () {
                // setState(() {
                //   isOpen = !isOpen;
                // });
              }),
        ],
      ),
    );
  }

  // Widget _buildDef() {
  //   return Text(
  //     definition,
  //     style: TextStyle(fontSize: 18),
  //   );
  // }

  // Widget _buildDefBox() {
  //   return Container(
  //     padding: EdgeInsets.all(10),
  //     child: Column(
  //       children: [_buildWordAndAudio(), isOpen ? _buildDef() : emptyWidget],
  //     ),
  //   );
  // }

  void printURL(List<DocumentSnapshot> w) {
    w.forEach((word) {
      print(word['imageURL'][0]);
    });
  }

  Widget _buildPicBox(List<dynamic> picURL) {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: _pictures(picURL),
      ),
    );
  }

  List<Widget> _pictures(List<dynamic> picURL) {
    return picURL
        .map((pic) => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image:
                    DecorationImage(fit: BoxFit.fill, image: NetworkImage(pic)),
                borderRadius: BorderRadius.circular(40),
              ),
              margin: EdgeInsets.all(5),
            ))
        .toList();
  }

  List<Widget> _savedWord(List<DocumentSnapshot> words) {
    return words
        .map((w) => Container(
              margin: EdgeInsets.all(25),
              height: 220,
              child: Column(
                children: [
                  _buildWordAndAudio(w['word'], w['audio']),
                  _buildPicBox(w['imageURL']),
                ],
              ),
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Like'),
        centerTitle: true,
        backgroundColor: Colors.pink[100],
      ),
      body: Center(
        child: FutureBuilder(
          future: FirebaseFirestore.instance.collection('images').get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final List<DocumentSnapshot> words = snapshot.data.docs;
              // printURL(words);
              return Container(child: ListView(children: _savedWord(words)));
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
