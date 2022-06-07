import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/tapTheLama/components/lamaButton.dart';
import 'package:lama_app/tapTheLama/components/lamaHead.dart';
import 'dart:math';



class TapTheLamaGame extends FlameGame with HasTappables{

  //sets background Color
  Color backgroundColor()=> Colors.white70;

  //#region Global Variables Screen
  //screen size variables for responsiveness
  var screenWidth;
  var screenHeight;
  //#endregion

  //#region Global Variables Lama Buttons
  //initialize sizes and positions of buttons and heads
  var xPosTurkis;
  var xPosBlue;
  var xPosPurple;
  var xPosPink;
  var yPosButtons;

  var lamaButtonSize;

  var lamaButtonImageTurkis='png/lama_button_turkis.png';
  var lamaButtonImageBlue='png/lama_button_blue.png';
  var lamaButtonImagePurple='png/lama_button_purple.png';
  var lamaButtonImagePink='png/lama_button_pink.png';

  //initialise Lama Buttons
  LamaButton lamaButtonTurkis=LamaButton();
  LamaButton lamaButtonBlue=LamaButton();
  LamaButton lamaButtonPurple=LamaButton();
  LamaButton lamaButtonPink=LamaButton();

  //declare button animators
  CircleComponent animatorButtonTurkis=CircleComponent();
  CircleComponent animatorButtonBlue=CircleComponent();
  CircleComponent animatorButtonPurple=CircleComponent();
  CircleComponent animatorButtonPink=CircleComponent();

  //declare and initialise the colors for button animators
  final buttonAnimatorDefaultColor =PaletteEntry(Color(0xFFebedf0)).paint();
  final buttonAnimatorColorRed =PaletteEntry(Color(0xffff0006)).paint();
  final buttonAnimatorColorGreen =PaletteEntry(Color(0xff1cff00)).paint();
  final buttonAnimatorColorOrange =PaletteEntry(Color(0xffe8ce64)).paint();

  //#endregion

  //#region Global Variables Lama Heads
  var amountLamaHeadsPerColumn;
  var lamaHeadsTurkis=<LamaHead>[];
  var lamaHeadsBlue=<LamaHead>[];
  var lamaHeadsPurple=<LamaHead>[];
  var lamaHeadsPink=<LamaHead>[];
  static double lamaHeadSize=0.0;

  LamaHead lamaHeadTurkis=LamaHead(false, false);
  LamaHead lamaHeadBlue=LamaHead(false, false);
  LamaHead lamaHeadPurple=LamaHead(false, false);
  LamaHead lamaHeadPink=LamaHead(false, false);

  var lamaHeadImageTurkis= 'png/lama_head_turkis.png';
  var lamaHeadImageBlue= 'png/lama_head_blue.png';
  var lamaHeadImagePurple= 'png/lama_head_purple.png';
  var lamaHeadImagePink= 'png/lama_head_pink.png';
  var lamaHeadImageRed= 'png/lama_head_red.png';

  //#endregion

  //#region Global Variables Game Logic
  var velocity1;
  var velocity2;
  var score= 0;
  var life=100;
  var scoreIncrementerGoodHit=10;
  var scoreIncrementerOkayHit=5;
  var lifeDecreaserStandard=10;
  var lifeDecreaserRedLamaHit=10;
  var lamaHeadAppearingProbability=.3;
  var lamaHeadIsAngryProbability=0.05;
  var lamaHeadFirstColumExisting=false;
  var lamaHeadThirdColumnExisting=false;
  //# endregion

  //# region override methods
  @override
  Future<void> onLoad() async {
    super.onLoad();
    //initialise lama buttons and set screen sizes
    initLamaButtonsWithEffects();
    initLamaHeadColumns();
  }


  @override
  Future<void> update(double dt) async {
    super.update(dt);
    checkHits();
    moveLamaHeads(lamaHeadsTurkis,lamaHeadImageTurkis,1);
    moveLamaHeads(lamaHeadsBlue,lamaHeadImageBlue,2);
    moveLamaHeads(lamaHeadsPurple,lamaHeadImagePurple,3);
    moveLamaHeads(lamaHeadsPink,lamaHeadImagePink,4);
  }
  //# endregion

  //#region visual effects


  Future<void> checkHits() async {

    if(lamaButtonTurkis.buttonPressed){
      checkSingleHit(lamaHeadsTurkis,lamaButtonTurkis,animatorButtonTurkis);
    }
    else if(lamaButtonBlue.buttonPressed){
      checkSingleHit(lamaHeadsBlue,lamaButtonBlue,animatorButtonBlue);
    }
    else if(lamaButtonPurple.buttonPressed){
      checkSingleHit(lamaHeadsPurple,lamaButtonPurple,animatorButtonPurple);
    }
    else if(lamaButtonPink.buttonPressed){
      checkSingleHit(lamaHeadsPink,lamaButtonPink,animatorButtonPink);
    }
  }

  Future<void> checkSingleHit(List<LamaHead> lamaHeads, LamaButton lamaButton, CircleComponent animatorButton) async {
    LamaHead lamaHeadCopy= lamaHeads.firstWhere((element) => element.isHittable);
    if(lamaHeadCopy.isExisting){
      if(lamaHeadCopy.isAngry){
        life-=lifeDecreaserRedLamaHit;
      }else{
        if(lamaHeadCopy.y>=yPosButtons-lamaButtonSize*0.2 && lamaHeadCopy.y<=yPosButtons+lamaButtonSize*0.2){
          flashButton(lamaButton, buttonAnimatorColorGreen, animatorButton);
          score+=scoreIncrementerGoodHit;
        }
        else if(lamaHeadCopy.y>=yPosButtons-lamaButtonSize*0.6 && lamaHeadCopy.y<=yPosButtons+lamaButtonSize*0.6){
          flashButton(lamaButton, buttonAnimatorColorOrange, animatorButton);
          score+=scoreIncrementerOkayHit;
        }
        else{
          flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
          life-=lifeDecreaserStandard;
        }
      }
    }
    else{
      flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
    }
    //
    lamaHeads.firstWhere((element) => element.isHittable).sprite=await loadSprite('png/BLANK_ICON.png');
    lamaHeads.firstWhere((element) => element.isHittable).isExisting=false;
  }

  void flashButton(LamaButton lamaButton,Paint paint, CircleComponent animatorButton) async{
    animatorButton.paint=paint;
    lamaButton.buttonPressed=false;
    await Future.delayed(Duration(milliseconds: 100));
    animatorButton.paint=buttonAnimatorDefaultColor;
  }
  //# endregion

  //#region initialise Lama Buttons methods

  void initLamaButtonsWithEffects() async{
    //initialising screen size
    screenWidth=size[0];
    screenHeight=size[1];
    screenHeight/screenWidth>=(16/9) ? amountLamaHeadsPerColumn=6 : amountLamaHeadsPerColumn=5;
    velocity1=screenHeight/300;
    velocity2=screenHeight/300;
    yPosButtons=screenHeight*5/6;

    //initialise Lama Button and Lama Head sizes
    lamaButtonSize=screenWidth/6;
    lamaHeadSize= lamaButtonSize*0.95;

    //initialise all relevant button postions
    xPosTurkis = 1/8*screenWidth;
    xPosBlue = 3/8*screenWidth;
    xPosPurple = 5/8*screenWidth;
    xPosPink = 7/8*screenWidth;

    //specify all button circles
    animatorButtonTurkis = CircleComponent(radius: lamaButtonSize*0.6, position: Vector2(xPosTurkis, yPosButtons), paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonTurkis);
    animatorButtonBlue = CircleComponent(radius: lamaButtonSize*0.6, position: Vector2(xPosBlue, yPosButtons), paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonBlue);
    animatorButtonPurple = CircleComponent(radius: lamaButtonSize*0.6, position: Vector2(xPosPurple, yPosButtons), paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonPurple);
    animatorButtonPink = CircleComponent(radius: lamaButtonSize*0.6, position: Vector2(xPosPink, yPosButtons), paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonPink);

    //specify all LamaButtons
    initLamaButton(lamaButtonTurkis, xPosTurkis,lamaButtonImageTurkis);
    initLamaButton(lamaButtonBlue, xPosBlue,lamaButtonImageBlue);
    initLamaButton(lamaButtonPurple, xPosPurple,lamaButtonImagePurple);
    initLamaButton(lamaButtonPink, xPosPink,lamaButtonImagePink);
  }

  void initLamaButton(LamaButton button, double xPos, String imageSource) async{
    button.sprite= await loadSprite(imageSource);
    button.size=Vector2(lamaButtonSize,lamaButtonSize);
    button.y=yPosButtons;
    button.x=xPos;
    button.anchor=Anchor.center;
    add(button);
  }

  void initButtonAnimator(CircleComponent animatorButton){
    animatorButton.anchor=Anchor.center;
    add(animatorButton);
  }

  //# endregion

  //#region Initialise And Move Lama Heads
  Future<void> initLamaHeadColumns() async {
    initLamaHeadColumn(lamaHeadsTurkis, xPosTurkis, lamaHeadImageTurkis,1);
    initLamaHeadColumn(lamaHeadsBlue, xPosBlue,lamaHeadImageBlue,2);
    initLamaHeadColumn(lamaHeadsPurple, xPosPurple, lamaHeadImagePurple,3);
    initLamaHeadColumn(lamaHeadsPink, xPosPink, lamaHeadImagePink,4);

  }

  Future<void> initLamaHeadColumn(List<LamaHead> lamaHeadList, double xPos, String imageSource,int column) async {
    for(int i=0;i<=amountLamaHeadsPerColumn;i++){
      LamaHead lamaHead=LamaHead(generateRandomBoolean(lamaHeadAppearingProbability), generateRandomBoolean(lamaHeadIsAngryProbability));
      lamaHeadList.add(lamaHead);
      lamaHeadList.elementAt(i).y=(screenHeight/amountLamaHeadsPerColumn*i)-lamaHeadSize;
      lamaHeadList.elementAt(i).x=xPos;
      lamaHeadList.elementAt(i).anchor=Anchor.center;
      lamaHeadList.elementAt(i).sprite=await loadSprite('png/BLANK_ICON.png');
      add(lamaHeadList.elementAt(i));
    }
  }


  Future<void> moveLamaHeads(List<LamaHead> lamaHeadList,String imageSource,int column) async {

    for (int i = 0; i <= amountLamaHeadsPerColumn; i++) {

      if (lamaHeadList.elementAt(i).y >= screenHeight + lamaHeadSize) {
        lamaHeadList.elementAt(i).y = 0-lamaHeadSize/2;
        if(lamaHeadList.elementAt(i).isExisting&& !lamaHeadList.elementAt(i).isAngry){
          life-=lifeDecreaserStandard;
        }
        lamaHeadList.elementAt(i).isAngry=generateRandomBoolean(lamaHeadIsAngryProbability);
        switch(column){
          case 1:
            lamaHeadList.elementAt(i).isExisting=generateRandomBoolean(lamaHeadAppearingProbability);
            if(lamaHeadList.elementAt(i).isExisting){
              lamaHeadFirstColumExisting=true;
            }else{
              lamaHeadFirstColumExisting=false;
            }
            break;
          case 2:
            if(lamaHeadFirstColumExisting){
              lamaHeadList.elementAt(i).isExisting=false;
            }else{
              lamaHeadList.elementAt(i).isExisting=generateRandomBoolean(lamaHeadAppearingProbability*2);
            }
            break;
          case 3:
            lamaHeadList.elementAt(i).isExisting=generateRandomBoolean(lamaHeadAppearingProbability);
            if(lamaHeadList.elementAt(i).isExisting){
              lamaHeadThirdColumnExisting=true;
            }else{
              lamaHeadThirdColumnExisting=false;
            }
            break;
          case 4:
            if(lamaHeadThirdColumnExisting){
              lamaHeadList.elementAt(i).isExisting=false;
            }else{
              lamaHeadList.elementAt(i).isExisting=generateRandomBoolean(lamaHeadAppearingProbability);
            }
            break;
        }
        if(lamaHeadList.elementAt(i).isExisting){
          lamaHeadList.elementAt(i).size=Vector2(lamaHeadSize, lamaHeadSize);
          if(lamaHeadList.elementAt(i).isAngry){
            lamaHeadList.elementAt(i).sprite=await loadSprite(lamaHeadImageRed);
          }else{
            lamaHeadList.elementAt(i).sprite=await loadSprite(imageSource);
          }
        }else{
          lamaHeadList.elementAt(i).sprite=await loadSprite('png/BLANK_ICON.png');
        }
      } else {
        if(column==1 || column==2){
          lamaHeadList.elementAt(i).y += velocity1;
        }else{
          lamaHeadList.elementAt(i).y += velocity2;
        }
        setHittableButtonAttribute(lamaHeadList.elementAt(i));
      }
    }
  }

  void setHittableButtonAttribute(LamaHead lamaHead) {
    if(lamaHead.y>=yPosButtons-lamaButtonSize){
      lamaHead.isHittable=true;
    }
    if(lamaHead.y>=yPosButtons+lamaButtonSize){
      lamaHead.isHittable=false;
    }
  }

  //#endregion

  bool generateRandomBoolean(double probability){
    Random r = new Random();
    bool randomBoolean = r.nextDouble() > (1-probability);
    return randomBoolean;
  }




}