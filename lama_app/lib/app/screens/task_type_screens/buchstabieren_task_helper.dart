import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';

import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/task_bloc.dart';
import 'package:lama_app/app/event/task_events.dart';

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
Future<void> preloadPngs(context, Map<String, String> pngs) async {
  for (int i = 0; i < pngs.length; i++) {
    await cacheImageByUrl2(context, pngs.values.toList()[i]);
  }
}

String bestimmeEinZufallsBuchstabenAusWort(String wort, int zufallsZahl) {
  String antwortString = "";
  antwortString.substring(zufallsZahl, zufallsZahl + 1);
  return antwortString;
}

int bestimmeEinZufallsZahlFuerWort(String wort) {
  var rng = Random();
  int zufallsZahl = rng.nextInt(wort.length);

  return zufallsZahl;
}

String getRandomLiteral(int length) {
  const ch = 'abcdefghijklmnopqrstuvwxyz';
  Random r = Random();
  return String.fromCharCodes(
      Iterable.generate(length, (_) => ch.codeUnitAt(r.nextInt(ch.length))));
}
