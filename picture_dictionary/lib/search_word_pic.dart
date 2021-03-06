import 'package:flutter/material.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'api_key.dart';
import 'package:dio/dio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'picture.dart';

class SearchWordPic extends StatefulWidget {
  @override
  _SearchWordPicState createState() => _SearchWordPicState();
}

class _SearchWordPicState extends State<SearchWordPic> {
  List<Picture> picList = [];
  String searchWord = '';
  String definition = '';
  String audioURL = '';
  bool isOpen = true;
  bool isPressed = false;

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
      CollectionReference images =
          FirebaseFirestore.instance.collection('images');
      var docRef = images.doc(keyword);
      int count = 0;
      int index = 0;
      bool saved;
      String picURL;
      docRef.get().then((doc) => {
            if (doc.exists)
              {
                res.hits.forEach((f) {
                  saved = false;
                  picURL = f.getDownloadLink();
                  print("Count $count");
                  doc["imageURL"].forEach((url) => {
                        index = int.parse(url[url.length - 1]),
                        print("Index $index"),
                        if (index == count)
                          {
                            picURL = url.substring(0, url.length - 1),
                            saved = true
                          }
                      });
                  count++;
                  setState(() {
                    picList.add(new Picture(url: picURL, isSaved: saved));
                  });
                })
              }
            else
              {
                res.hits.forEach((f) {
                  setState(() {
                    picList.add(
                        new Picture(url: f.getDownloadLink(), isSaved: false));
                  });
                })
              }
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
            borderSide:
                BorderSide(color: Color.fromRGBO(5, 30, 52, 1), width: 1.5),
            borderRadius: BorderRadius.circular(50),
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey[300], width: 1.5),
              borderRadius: BorderRadius.circular(50)),
          suffixIcon: Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle, color: Color.fromRGBO(5, 30, 52, 1)),
            child: IconButton(
                icon: Icon(
                  Icons.search_rounded,
                  color: Colors.white,
                ),
                onPressed: () => {
                      picList.clear(),
                      getImage(myController.text),
                      getDef(myController.text)
                    }),
          )),
    );
  }

  List<Widget> _pictures() {
    return picList
        .map((pic) => Container(
              width: 100,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: IconButton(
                        icon: Icon(
                          Icons.favorite,
                          color:
                              pic.isSaved ? Colors.red[700] : Colors.grey[400],
                          size: 40,
                        ),
                        onPressed: () {
                          setState(() {
                            pic.isSaved = !pic.isSaved;
                          });
                          String index = picList.indexOf(pic).toString();
                          CollectionReference images =
                              FirebaseFirestore.instance.collection('images');
                          var docRef = images.doc(searchWord);
                          docRef.get().then((doc) => {
                                if (pic.isSaved)
                                  {
                                    if (doc.exists)
                                      {
                                        print(doc["imageURL"].length),
                                        // User pressed Like btn
                                        // Determine true(btn turns to  red) or false(btn truns to grey)
                                        // If red ==> Add it
                                        // If there is no word exsisted on firebase
                                        // Go else statement add it as new word
                                        // If there exist, update imageURL array
                                        docRef.update({
                                          "imageURL": FieldValue.arrayUnion(
                                              [pic.url + index])
                                        }),
                                      }
                                    else
                                      {
                                        images.doc(searchWord).set({
                                          "word": searchWord,
                                          "def": definition,
                                          "audio": audioURL,
                                          "imageURL": [pic.url + index],
                                        }),
                                      }
                                  }
                                else
                                  {
                                    // If false ==> Remove it
                                    // Remove the image from array
                                    // Then, check the length of array.
                                    // If it becomes to zero, delete the word from firebase
                                    // Otherwise, do nothing
                                    //  "imageURL": FieldValue.arrayRemove([url])
                                    //
                                    docRef.update({
                                      "imageURL": FieldValue.arrayRemove(
                                          [pic.url + index])
                                    }),
                                    if (doc["imageURL"].length - 1 == 0)
                                      {
                                        docRef.delete().then(
                                              (res) => print(
                                                  "Document successfully deleted!"),
                                            )
                                      }
                                  }
                              });
                        }),
                  )
                ],
              ),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(pic.url)),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Text(
        definition,
        style: TextStyle(fontSize: 18),
      ),
    );
  }

  Widget _buildDefBox() {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 10),
      // margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey[300]))),
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
