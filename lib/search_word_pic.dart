import 'package:flutter/material.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'api_key.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';

class SearchWordPic extends StatefulWidget {
  @override
  _SearchWordPicState createState() => _SearchWordPicState();
}

class _SearchWordPicState extends State<SearchWordPic> {
  List<String> picUrlList = [];
  String searchWord = '';
  String definition = '';
  String audioURL = '';
  bool isOpen = true;
  final Widget emptyWidget = new Container(width: 0, height: 0);

  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  void getImage(String keyword) async {
    PixabayPicker picker = PixabayPicker(apiKey: api_key, language: "en");
    PixabayResponse res = await picker.api
        .requestImagesWithKeyword(keyword: keyword, resultsPerPage: 6);
    if (res != null) {
      res.hits.forEach((f) {
        setState(() {
          print(f.getDownloadLink());
          picUrlList.add(f.getDownloadLink());
        });
      });
    }
  }

  void getDef(String keyword) async {
    try {
      var response = await Dio()
          .get('https://api.dictionaryapi.dev/api/v2/entries/en/$keyword');
      setState(() {
        searchWord = response.data[0]['word'];
        definition =
            response.data[0]['meanings'][0]['definitions'][0]['definition'];
        audioURL = response.data[0]['phonetics'][0]['audio'];
      });
    } catch (e) {
      print(e);
    }
  }

  void playAudio() async {
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

  Widget _buildSearchBox() {
    return TextField(
      controller: myController,
      obscureText: false,
      decoration: InputDecoration(
          hintText: 'search word',
          contentPadding:
              const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.pink[50], width: 1.5),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.circular(50)),
          suffixIcon: Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.pink[100]),
            child: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.indigo[900],
                ),
                onPressed: () => {
                      picUrlList.clear(),
                      getImage(myController.text),
                      getDef(myController.text)
                    }),
          )),
    );
  }

  List<Widget> _pictures() {
    return picUrlList
        .map((url) => Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image:
                    DecorationImage(fit: BoxFit.fill, image: NetworkImage(url)),
                borderRadius: BorderRadius.circular(40),
              ),
              margin: EdgeInsets.all(5),
            ))
        .toList();
  }

  Widget _buildPicBox() {
    return Expanded(
      child: GridView.count(
        crossAxisCount: 2,
        children: _pictures(),
      ),
    );
  }

  Widget _buildWordAndAudio() {
    return Row(
      children: [
        Text(
          searchWord,
          style: TextStyle(fontSize: 28),
        ),
        IconButton(
            icon: Icon(Icons.volume_up),
            onPressed: () {
              playAudio();
            }),
        IconButton(
            icon: Icon(Icons.book),
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
              });
            }),
      ],
    );
  }

  Widget _buildDef() {
    return Text(
      definition,
      style: TextStyle(fontSize: 18),
    );
  }

  Widget _buildDefBox() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [_buildWordAndAudio(), isOpen ? _buildDef() : emptyWidget],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return searchWord.isNotEmpty
        ? Container(
            child: Column(children: [
            _buildSearchBox(),
            _buildDefBox(),
            _buildPicBox(),
          ]))
        : Container(
            child: _buildSearchBox(),
          );
  }
}
