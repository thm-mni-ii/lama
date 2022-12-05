import 'dart:math';
import 'dart:io';
import 'dart:collection';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lama_app/app/bloc/add_vocab_bloc.dart';
import 'package:lama_app/app/event/add_vocab_events.dart';
import 'package:lama_app/app/screens/add_vocab_crop.dart';
import 'package:lama_app/app/state/add_vocab_state.dart';
import 'package:lama_app/util/LamaColors.dart';
import 'package:lama_app/util/LamaTextTheme.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:translator/translator.dart';
import 'package:lama_app/util/pair.dart';

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
  final complete_vocabList = <String>[];
  late List<Pair<String?, String?>> vocabPairList;
  XFile? imageFile;
  List<String> testList = ['wort1', 'wort1', 'wort1'];
  int selectedValue = 0;
  bool listType = true;
  final editableBloc = AddVocabBloc();
  @override
  void initState() {
    super.initState();
    //BlocProvider.of<AddVocabBloc>(context).add(AddVocabCamEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: LamaColors.orangeAccent,
          title: const Text("Vokabeln hinzufügen"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (textScanning) const CircularProgressIndicator(),

              if (!textScanning && imageFile == null)
                Container(
                  child: Text('Noch kein Bild ausgewaehlt'),
                ),
              // if (imageFile != null)
              //   Image.file(
              //     File(imageFile!.path),
              //   ),
              if (vocabList1.isEmpty || vocabList2.isEmpty)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: LamaColors.orangeAccent),
                        onPressed: () {
                          getImage(ImageSource.gallery);
                          BlocProvider.of<AddVocabBloc>(context)
                              .add(ReorderEvent());
                        },
                        child: Container(
                          child: Column(
                            children: [
                              Icon(
                                Icons.image,
                                size: 30,
                              ),
                              Text(
                                "Galerie",
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
                        style: ElevatedButton.styleFrom(
                            primary: LamaColors.orangeAccent),
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
                                "Kamera",
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

              if (!vocabList1.isEmpty || !vocabList2.isEmpty)
                BlocBuilder<AddVocabBloc, AddVocabState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(5, 10, 0, 5),
                          child: Row(
                            children: [
                              Expanded(child: Text('Vokabeln ordnen/löschen')),
                              Radio(
                                value: 0,
                                groupValue: selectedValue,
                                onChanged: (value) => setState(() {
                                  context
                                      .read<AddVocabBloc>()
                                      .add(ReorderEvent());
                                  // BlocProvider.of<AddVocabBloc>(context)
                                  //     .add(EditableEvent(AddVocabBloc().editable));
                                  selectedValue = 0;
                                  // print(AddVocabBloc().editable);
                                  //print(listType);
                                }),
                              ),
                              Expanded(
                                  child: Text('Vokabeln editieren/hinzufügen')),
                              Radio(
                                value: 1,
                                groupValue: selectedValue,
                                onChanged: (value) => setState(() {
                                  context
                                      .read<AddVocabBloc>()
                                      .add(EditableEvent());
                                  selectedValue = 1;
                                }),
                              ),
                              Expanded(child: Text('Vokabeln verschieben')),
                              Radio(
                                value: 2,
                                groupValue: selectedValue,
                                onChanged: (value) => setState(() {
                                  context.read<AddVocabBloc>().add(SwapEvent());
                                  selectedValue = 2;
                                }),
                              ),
                            ],
                          ),
                        ),
                        (state is EditableState)
                            ? Row(
                                children: [
                                  Expanded(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            vocabList1.add('');
                                          });
                                        }),
                                  ),
                                  Expanded(
                                    child: IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                        icon: Icon(Icons.add),
                                        onPressed: () {
                                          setState(() {
                                            vocabList2.add('');
                                          });
                                        }),
                                  ),
                                ],
                              )
                            : Container(),
                        Row(
                          children: [
                            LimitedBox(
                                maxWidth: MediaQuery.of(context).size.width / 2,
                                child: vocabList2.isEmpty
                                    ? Container(
                                        child: Text('empty list'),
                                      )
                                    : ReorderVocab(vocabList1, state, 1)),

                            // FittedBox(
                            //   fit: BoxFit.scaleDown,
                            //   child: LimitedBox(
                            //     maxHeight: MediaQuery.of(context).size.width,
                            //     maxWidth: MediaQuery.of(context).size.width / 3,
                            //     child: Container(
                            //       child: vocabList2.isEmpty
                            //           ? Container(
                            //               child: Text('swap buttons'),
                            //             )
                            //           : SingleChildScrollView(
                            //             child: Column(
                            //                 children: [
                            //                   for (var i in vocabList1)
                            //                     Container(
                            //                       margin: EdgeInsets.fromLTRB(0, 7, 0, 7),
                            //                       padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            //                       child: Icon(Icons.compare_arrows),
                            //                     ),
                            //                 ],
                            //               ),
                            //           ),
                            //     ),
                            //   ),
                            // ),

                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: LimitedBox(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2,
                                  child: vocabList2.isEmpty
                                      ? Container(
                                          child: Text('empty list'),
                                        )
                                      : ReorderVocab(vocabList2, state, 2)),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 15,
          child: BottomAppBar(
            child: IconTheme(
              data:
                  IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
              child: Row(
                children: <Widget>[
                  if (!vocabList1.isEmpty || vocabList2.isEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 1,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.red,
                        onPressed: () {
                          context.read<AddVocabBloc>().add(AddVocabCamEvent());
                        },
                      ),
                    ),
                  // Container(
                  //     alignment: Alignment.center,
                  //     width: 2,
                  //     height: MediaQuery.of(context).size.height / 15,
                  //     color: Colors.grey),
                  if (!vocabList1.isEmpty || vocabList2.isEmpty)
                    Container(
                      width: MediaQuery.of(context).size.width / 2 - 1,
                      child: IconButton(
                        icon: const Icon(Icons.check),
                        color: Colors.green,
                        onPressed: () {
                          print(complete_vocabList);
                          Navigator.of(context).pop(complete_vocabList);
                          
                        },
                      ),
                    ),
                ],
              ),
            ),
          ),
        ));
  }

// source for code https://github.com/ritsat/text_recognition
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: LamaColors.orangeAccent,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        setState(() {});
        getRecognisedText(croppedFile);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = "Error occured while scanning";
      setState(() {});
    }
  }

  void getRecognisedText(CroppedFile? image) async {
    vocabList1.clear();
    vocabList2.clear();
    complete_vocabList.clear();
    final inputImage = InputImage.fromFilePath(image!.path);
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
      if (isWord(block.text)) {
        if (centerPointList[x] < centerPoint) {
          vocabList1.add(block.text);
          complete_vocabList.add(block.text);
        } else {
          vocabList2.add(block.text);
          complete_vocabList.add(block.text);
        }
      }
      x++;
    }

    // debugPrint(vocabList1.toString());
    // debugPrint(vocabList2.toString());
    // debugPrint(centerPoint.toString());
    // debugPrint(centerPointList.toString());

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
        '${s[0]}'.contains(new RegExp(r'[1-9]')) ||
        '${s[0]}'.contains(new RegExp(r'[(]'))) {
      return true;
    }
    return false;
  }

  HashMap matchVocab() {
    HashMap hashy = new HashMap();
    //if (vocabList1.length == vocabList2.length)
    for (int i = 0; i < vocabList1.length; i++) {
      hashy[vocabList1[i]] = vocabList2[i];
    }
    return hashy;
  }

  // Widget EditableList(List<String> vocabList) {
  //   return ListView.builder(
  //     itemCount: vocabList.length,
  //     itemBuilder: (context, index) {
  //       final vocab = vocabList[index];
  //       return Card(
  //         child: ListTile(
  //           contentPadding: const EdgeInsets.all(5),
  //           leading: true
  //               ? IconButton(
  //                   icon: Icon(Icons.cancel),
  //                   onPressed: () {
  //                     vocabList.remove(index);

  //                     setState(() {
  //                       vocabList.removeAt(index);
  //                       print(vocabList);
  //                     });
  //                   })
  //               : vocabList == vocabList1
  //                   ? Icon(Icons.arrow_forward)
  //                   : Icon(Icons.arrow_back),
  //           dense: true,
  //           title: Text(vocab),
  //         ),
  //       );
  //     },
  //   );
  // }
  bool testbool = true;
  final textController = TextEditingController();
  String testString = 'asdasd';
  Widget ReorderVocab(List<String> vocabList, AddVocabState state, int list) {
    return ReorderableListView(
        buildDefaultDragHandles: (state is ReorderState),
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
          for (int index = 0; index < vocabList.length; index += 1)
            ListTile(
              key: Key('$index'),
              title: (state is EditableState)
                  ? TextFormField(
                      //controller: textController,
                      // decoration: InputDecoration(hintText: vocabList[index]),
                      initialValue: vocabList[index],
                      onChanged: (text) {
                        vocabList[index] = text;
                        print(vocabList[index]);
                        print(vocabList);
                        print(vocabList1);
                      },
                    )
                  : Text(
                      vocabList[index],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

              leading: (state is ReorderState)
                  ? IconButton(
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      icon: Icon(Icons.cancel),
                      onPressed: () {
                        vocabList.remove(index);
                        setState(() {
                          vocabList.removeAt(index);
                          print(vocabList);
                        });
                      })
                  : (state is SwapState)
                      ? IconButton(
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                          icon: Icon((vocabList == vocabList1)
                              ? Icons.arrow_forward
                              : Icons.arrow_back),
                          onPressed: () {
                            setState(() {
                              moveSingleVocab(index, list);

                              print(vocabList);
                            });
                          })
                      : SizedBox(
                          height: 0,
                          width: 0,
                        ),

              // leading: IconButton(
              //     padding: EdgeInsets.zero,
              //     constraints: BoxConstraints(),
              //     icon: Icon(Icons.edit),
              //     onPressed: () {
              //       testBool = true;
              //       setState(() {});
              //     }),
              dense: false,
              //   trailing: (vocabList == vocabList1 && state is SwapState)
              //       ? IconButton(
              //           padding: EdgeInsets.zero,
              //           constraints: BoxConstraints(),
              //           icon: Icon(Icons.compare_arrows),
              //           onPressed: () {
              //             setState(() {
              //               print(vocabList);
              //             });
              //           })
              //       : SizedBox(
              //           height: 0,
              //         ),
            ),
        ],
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            final String item = vocabList.removeAt(oldIndex);
            vocabList.insert(newIndex, item);
          });
        });
  }

  void moveSingleVocab(int index, int list) {
    if (list == 1) {
      vocabList2.insert(index, vocabList1[index]);
      vocabList1.removeAt(index);
       complete_vocabList.insert(index, vocabList1[index]);
      complete_vocabList.removeAt(index);
    } else {
      vocabList1.insert(index, vocabList2[index]);
      vocabList2.removeAt(index);
       complete_vocabList.insert(index, vocabList2[index]);
      complete_vocabList.removeAt(index);
    }
  }

  Future<void> cropMyImage() async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
  }
}
