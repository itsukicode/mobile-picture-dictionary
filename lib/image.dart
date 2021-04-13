// import 'package:flutter/material.dart';
// import 'package:pixabay_picker/model/pixabay_media.dart';
// import 'package:pixabay_picker/pixabay_picker.dart';
// import 'api_key.dart';

// class GetImage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: _pictures(),
//     );
//   }
// }

// void getImage(String keyword) async {
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

// List<Widget> _pictures() {
//   return taskList
//       .map((task) => Container(
//             width: 100,
//             height: 60,
//             decoration: BoxDecoration(color: Colors.white,
//                 // borderRadius: BorderRadius.circular(40),
//                 boxShadow: [
//                   BoxShadow(),
//                   //   BoxShadow(offset: Offset(20, 20), color: Colors.yellow),
//                 ]),
//             margin: EdgeInsets.all(5),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Text(
//                   task.taskName,
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 Text(
//                   task.workInterval,
//                   style: TextStyle(fontSize: 16, color: Colors.black),
//                 ),
//                 Text(task.breakInterval,
//                     style: TextStyle(fontSize: 16, color: Colors.black)),
//               ],
//             ),
//           ))
//       .toList();
}
