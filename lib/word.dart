import 'package:picture_dictionary/picture.dart';

class Word {
  List<dynamic> picList = [];
  String word = '';
  String def = '';
  String audioURL = '';
  bool isPressed;

  Word({
    this.picList,
    this.word,
    this.def,
    this.audioURL,
    this.isPressed,
  });
}
