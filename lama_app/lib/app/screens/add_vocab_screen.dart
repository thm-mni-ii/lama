import 'dart:math';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/add_vocab_bloc.dart';
import 'package:lama_app/app/event/add_vocab_events.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';

class AddVocabScreen extends StatefulWidget {
  AddVocabScreen();

  @override
  State<StatefulWidget> createState() {
    return AddVocabScreenState();
  }
}

class AddVocabScreenState extends State<AddVocabScreen> {
  late bool textScanning = false;
  late String scannedText = ' ';
  final vocabList1 = <String>[];
  final vocabList2 = <String>[];
  XFile? imageFile;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddVocabBloc>(context).add(AddVocabCamEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: LamaColors.mainPink,
        title: const Text("Vokabeln hinzufügen"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning) const CircularProgressIndicator(),
                if (!textScanning && imageFile == null)
                  Container(
                    child: Text('Noch kein Bild ausgewaehlt'),
                  ),
                if (imageFile != null)
                  Image.file(
                    File(imageFile!.path),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.gallery);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 30,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),  
                Container(
                  child: Text(
                    scannedText,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Container(
                  child: vocabList1.isEmpty
                      ? Text('')
                      : Text(vocabList1.toString()),
                ),
                SizedBox(height: 20),
                Container(
                  child: vocabList2.isEmpty
                      ? Text('')
                      : Text(vocabList2.toString()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// source for code https://github.com/ritsat/text_recognition
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognisedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(XFile image) async {
    vocabList1.clear();
    vocabList2.clear();
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";

    final centerPointList = <int>[];
    int centerPointSum = 0;
    int centerPoint = 0;
    int i = 0;
    int x = 0;

    for (TextBlock block in recognisedText.blocks) {
      int? singleCenterPoint = 0;
      final singleCenterPointList = <String>[];
      List<String> cornerPoints = block.rect.center.toString().split('');

      for (int k = 0; k < cornerPoints.length; k++) {
        if (cornerPoints[k] == '.') break;
        if (isNumeric(cornerPoints[k].toString())) {
          singleCenterPointList.add(cornerPoints[k]);
        }
      }

      singleCenterPoint = int.tryParse(singleCenterPointList.join());
      centerPointList.add(singleCenterPoint!);
      centerPointSum = centerPointSum + singleCenterPoint;
      i++;
      centerPoint = centerPointSum ~/ i;
    }

// adds vocabs to respective lists by dividing table at the average top left word corner point
    for (TextBlock block in recognisedText.blocks) {
      print(block.text);
      if (isWord(block.text)) {
        if (centerPointList[x] < centerPoint) {
          vocabList1.add(block.text);
        } else {
          vocabList2.add(block.text);
        }
      }
      x++;
    }

    debugPrint(vocabList1.toString());
    debugPrint(vocabList2.toString());
    debugPrint(centerPoint.toString());
    debugPrint(centerPointList.toString());

    textScanning = false;
    setState(() {});
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  bool isWord(String s) {
    if ('${s[0]}'.contains(new RegExp(r'[A-Z]')) ||
        '${s[0]}'.contains(new RegExp(r'[a-z]')) ||
        '${s[0]}'.contains(new RegExp(r'[1-9]'))) {
      return true;
    }
    return false;
  }
}
