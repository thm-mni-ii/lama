import 'dart:math';
import 'package:flutter/services.dart';

/// Repository that provides access to the lama facts.
///
/// This is used in the main menu to display a random lama fact.
///
/// Author K.Binder
class LamaFactsRepository {
  List<String> lamafacts;

  ///Loads all lama facts from the flutter assets (assets/lama_facts.txt)
  loadFacts() async {
    String lamaFactsString =
        await rootBundle.loadString('assets/lama_facts.txt');
    lamafacts = lamaFactsString.split("\n");
  }

  ///Returns a random fact from the loaded lama facts.
  String getRandomLamaFact() {
    var rng = new Random();
    return lamafacts[rng.nextInt(lamafacts.length)];
  }
}
