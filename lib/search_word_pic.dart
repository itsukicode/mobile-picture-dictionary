import 'package:flutter/material.dart';
import 'package:pixabay_picker/model/pixabay_media.dart';
import 'package:pixabay_picker/pixabay_picker.dart';
import 'api_key.dart';

class SearchWordPic extends StatefulWidget {
  @override
  _SearchWordPicState createState() => _SearchWordPicState();
}

class _SearchWordPicState extends State<SearchWordPic> {
  List<String> picUrlList = [];
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
        .requestImagesWithKeyword(keyword: keyword, resultsPerPage: 1);
    if (res != null) {
      res.hits.forEach((f) {
        setState(() {
          picUrlList.add(f.getDownloadLink());
        });
      });
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
                onPressed: () =>
                    {picUrlList.clear(), getImage(myController.text)}),
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

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        _buildSearchBox(),
        // _buildDefBox(),
        Container(margin: EdgeInsets.only(top: 20.0)),
        _buildPicBox(),
      ],
    ));
  }
}
