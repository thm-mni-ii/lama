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
  XFile? imageFile;

  final vocabList = <String>[];

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
                if (imageFile != null) Image.file(File(imageFile!.path)),
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
                Container(child: Text('')),
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
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = GoogleMlKit.vision.textDetector();
    RecognisedText recognisedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = "";
    for (TextBlock block in recognisedText.blocks) {
      int i = 0;
      for (TextLine line in block.lines) {
        scannedText = scannedText + line.text + "\n";

        debugPrint(line.text);
        debugPrint(line.rect.toString());
        debugPrint(line.cornerPoints.toString());
        //vocabList[i] = line.text;
       // if(line.rect. > block.rect.center);
        vocabList.add(line.text);
        i++;

        //print(vocabList.toString());
        // List<String> regLan = block.recognizedLanguages;
        // print('reglang:  ' + regLan.toString());

        //for (TextElement element in line.elements) {debugPrint(element.text);}

      }
    }
    debugPrint(vocabList.toString());

    // debugPrint(recognisedText.text);
    // debugPrint('Scanned Text: ');
    // debugPrint(scannedText);
    textScanning = false;
    setState(() {});
  }
}
