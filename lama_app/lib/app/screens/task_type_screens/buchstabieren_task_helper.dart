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
