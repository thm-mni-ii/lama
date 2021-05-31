import 'dart:math';

import 'package:flutter/services.dart';

class LamaFactsRepository {
  List<String> lamafacts;

  loadFacts() async {
    String lamaFactsString =
        await rootBundle.loadString('assets/lama_facts.txt');
    lamafacts = lamaFactsString.split("\n");
  }

  String getRandomLamaFact() {
    var rng = new Random();
    return lamafacts[rng.nextInt(lamafacts.length)];
  }
}
