class BuchstabenListeClass {
  int stelleImWort;
  int zugewiesenerZufallsInt;
  var buchstabe;
  bool buchstabeSchonRichtigGesetztFlag = false;

  BuchstabenListeClass(
      this.stelleImWort, this.buchstabe, this.zugewiesenerZufallsInt);

  bool checkIfPointsCollide(List<BuchstabenListeClass> buchstabenListe) {
    bool retVal = false;

    buchstabenListe.forEach((buchstabeToCheck) {
      if (buchstabeToCheck.buchstabe == buchstabe &&
          buchstabeToCheck.buchstabeSchonRichtigGesetztFlag == false) {
        retVal = true;
      }
    });

    return retVal;
  }
}
