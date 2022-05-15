import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

import 'dart:math';
import 'package:flutter/material.dart';

CachedNetworkImage tudas() {
  return CachedNetworkImage(
    imageUrl:
        "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true",
    cacheKey: "Wurst",
  );
}

CachedNetworkImageProvider bla() {
  return CachedNetworkImageProvider(
      "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true",
      cacheKey: "Wurst");
}

Image etwas2() {
  return Image(
      image: CachedNetworkImageProvider(
          "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true",
          cacheKey: "Wurst"));
}

void etwas3() {
  DefaultCacheManager()
      .downloadFile(
          "https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true")
      .then((_) {});
  // var file = await DefaultCacheManager().getSingleFile("https://github.com/handitosb/lamaapps/blob/main/Bilder_Test/Auto.png?raw=true");
}

Image cacheImageByUrl(BuildContext context, String url) {
  Image image = Image(
    image: CachedNetworkImageProvider(
        url), //max Höhe/Breite kann hier eingestellt werden

    //fit: BoxFit.cover,
  );

  precacheImage(image.image, context);
  return image;
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
