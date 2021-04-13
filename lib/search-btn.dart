import 'package:flutter/material.dart';
import 'image.dart';

// File Name ==> search_word_pic.dart
// Container
// Search Box => like buildWidget function in pref
// Def
// Pic
class SearchButton extends StatefulWidget {
  @override
  _SearchButtonState createState() => _SearchButtonState();
}

// void getImage(String keyword) async {
//   List<Widget> picList;
//   PixabayPicker picker = PixabayPicker(apiKey: api_key, language: "en");
//   PixabayResponse res = await picker.api
//       .requestImagesWithKeyword(keyword: keyword, resultsPerPage: 1);
//   if (res != null) {
//     res.hits.forEach((f) {
//       // Listを作る
//       print(f.getDownloadLink());
//     });
//   }
// }

class _SearchButtonState extends State<SearchButton> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => {getImage(myController.text)}),
          )),
    );
  }
}
