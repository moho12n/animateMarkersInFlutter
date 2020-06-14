import 'package:flutter/material.dart';
import 'tools/tools.dart';
import 'ui/mapScreen.dart';

import 'models/markerModel.dart';

void main() {
  Tools.markersList.add(MarkersModel(
      1,
      "La Grande Poste",
      "The Algiers central post office is an office building for postal services located at Alger Centre municipality in Algiers, Algeria",
      "36.752887",
      "3.042048",
      "https://www.dzbreaking.com/wp-content/uploads/2018/03/2000.png"));
  Tools.markersList.add(MarkersModel(
      2,
      "Mosquee Ketchaoua",
      "The Ketchaoua Mosque is a mosque in Algiers, the capital of Algeria. It was built during the Ottoman rule in the 17th century and is located at the foot of the Casbah, which is a UNESCO World Heritage Site",
      "36.7850",
      "3.0608",
      "https://ttnotes.com/images/makam-echahid-algiers.jpg"));
  Tools.markersList.add(MarkersModel(
      3,
      "The shrine of the martyr",
      "The Maqam Echahid is a concrete monument commemorating the Algerian war for independence. The monument was opened in 1982 on the 20th anniversary of Algeria's independence",
      "36.7456",
      "3.0698",
      "https://www.airfrance.co.uk/GB/common/common/img/tbaf/news/ALG/la-mosquee-ketchaoua-l-histoire-avec-un-grand-h/ALG-la-mosquee-ketchaoua-l-histoire-avec-un-grand-h-2_1-1024x512.jpg"));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AnimateMarkers',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainMapScreen(),
    );
  }
}
