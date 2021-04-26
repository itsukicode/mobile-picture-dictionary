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
  List<Word> wordList = [];

  void playAudio(String audioURL) async {
    print(audioURL);
    AudioPlayer audioPlayer = AudioPlayer();
    int result = await audioPlayer.play(audioURL);
    if (result == 1) {
      print('success audio');
    } else {
      print('not success audio');
    }
  }

  Widget _buildWordAndAudio(Word word) {
    return Container(
      padding: EdgeInsets.only(left: 8.0),
      margin: EdgeInsets.only(bottom: 5.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
      child: Row(
        children: [
          Text(
            word.word,
            style: TextStyle(fontSize: 28),
          ),
          IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () {
                playAudio(word.audioURL);
              }),
          IconButton(
              icon: Icon(Icons.book),
              onPressed: () {
                setState(() {
                  word.isPressed = !word.isPressed;
                });
              }),
        ],
      ),
    );
  }

  Widget _buildDef(Word word) {
    return Text(
      word.def,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildDefBox(Word word) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          _buildWordAndAudio(word),
          word.isPressed ? _buildDef(word) : emptyWidget
        ],
      ),
    );
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

  List<Widget> _savedWord() {
    return wordList
        .map((w) => Container(
              margin: EdgeInsets.all(25),
              height: 220,
              child: Column(
                children: [
                  _buildDefBox(w),
                  _buildPicBox(w.picList),
                ],
              ),
            ))
        .toList();
  }

  void createListOfWord(List<dynamic> words) {
    List<dynamic> picURL;
    int size = words.length;
    for (int i = 0; i < size; i++) {
      picURL = words[i]["imageURL"];
      wordList.add(new Word(
          word: words[i]["word"],
          def: words[i]["def"],
          audioURL: words[i]["audio"],
          picList: picURL,
          isPressed: false));
    }
    print(wordList.length);
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
            if (snapshot.hasData) {
              final List<DocumentSnapshot> words = snapshot.data.docs;
              createListOfWord(words);
              return Container(child: ListView(children: _savedWord()));
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
