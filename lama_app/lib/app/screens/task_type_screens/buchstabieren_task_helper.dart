import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math';
import 'package:flutter/material.dart';

Image cacheImageByUrl(BuildContext context, String url) {
  Image image = Image(
    image: CachedNetworkImageProvider(
        url), //max Höhe/Breite kann hier eingestellt werden

    //fit: BoxFit.cover,
  );

  precacheImage(image.image, context);
  return image;
}

Future<void> cacheImageByUrl2(BuildContext context, String url) async {
  Image image = Image(
    image: CachedNetworkImageProvider(
        url), //max Höhe/Breite kann hier eingestellt werden

    //fit: BoxFit.cover,
  );

  await precacheImage(image.image, context);
}

int erstelleEineRandomNummer(task) {
  var rng = Random();
  var zufallsZahl = rng.nextInt(task.woerter.length);
  return zufallsZahl;
}

String holeUrl(task, int zufallszahl) {
  List<String> woerterURLs = task.woerter.values.toList();
  String url = woerterURLs[zufallszahl];
  return url;
}

void precacheAllImagesForTask(task, BuildContext context) {
  for (int i = 0; i < task.woerter.length; i++) {
    cacheImageByUrl(context, holeUrl(task, i));
  }
}

///This method gets called when clicking on the button "Deutsch" and preloads
///all images for the "Buchstabieren" Task
///
///currently loads them everytime the button is pressed (I think)
Future<void> preloadPngs(context) async {
  var pngs = {
    "Auto":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true",
    "Baum":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Baum.png?raw=true",
    "Biene":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Biene.png?raw=true",
    "Faultier":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Faultier.png?raw=true",
    "Fisch":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Fisch.png?raw=true",
    "Frosch":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Frosch.png?raw=true",
    "Hund":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Hund.png?raw=true",
    "Igel":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Igel.png?raw=true",
    "Jaguar":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Jaguar.png?raw=true",
    "Krokodil":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Krokodil.png?raw=true",
    "Küken":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Küken.png?raw=true",
    "Regenwurm":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Regenwurm.png?raw=true",
    "Robbe":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Robbe.png?raw=true",
    "Schmetterling":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Schmetterling.png?raw=true",
    "Schnecke":
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Schnecke.png?raw=true",
  };
  for (int i = 0; i < pngs.length; i++) {
    await cacheImageByUrl2(context, pngs.values.toList()[i]);
  }
}
