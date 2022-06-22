import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/tapTheLama/components/LifeBar.dart';
import 'package:lama_app/tapTheLama/components/lamaButton.dart';
import 'package:lama_app/tapTheLama/components/lamaHead.dart';
import 'package:lama_app/tapTheLama/components/missedHeadAnimator.dart';
import 'dart:math';

import 'package:lama_app/tapTheLama/components/upperInGameDisplay.dart';

class TapTheLamaGame extends FlameGame with HasTappables {
  //sets background color
  Color backgroundColor() => Colors.white70;

  //#region Global Variables Screen
  //screen size variables for responsiveness
  var screenWidth;
  var screenHeight;
  var changer = 30.0;

  //upper in game display variables
  late double upperInGameDisplayHeight;
  late UpperInGameDisplay upperInGameDisplay;
  final upperInGameDisplayColor = PaletteEntry(Color(0xfff4f4f6)).paint();
  final lifeBarRedColor = PaletteEntry(Color(0xffff0006)).paint();
  final lifeBarGreenColor = PaletteEntry(Color(0xff1cff00)).paint();
  late TextPaint scoreText;
  late TextPaint streakText;
  var lifeBarHorizontalPosition;
  var lifeBarVerticalPosition;
  var lifeBarWidth;
  var lifeBarHeight;
  late LifeBar lifeBar;
  var multiplier = 1;
  late MissedHeadAnimator missedHeadAnimator;

  //#endregion

  //#region Global Variables Lama Buttons
  //initialize sizes and positions of buttons and heads
  var xPosTurkis;
  var xPosBlue;
  var xPosPurple;
  var xPosPink;
  var yPosButtons;

  var lamaButtonSize;

  var lamaButtonImageTurkis = 'png/lama_button_turkis.png';
  var lamaButtonImageBlue = 'png/lama_button_blue.png';
  var lamaButtonImagePurple = 'png/lama_button_purple.png';
  var lamaButtonImagePink = 'png/lama_button_pink.png';

  //initialise Lama Buttons
  LamaButton lamaButtonTurkis = LamaButton();
  LamaButton lamaButtonBlue = LamaButton();
  LamaButton lamaButtonPurple = LamaButton();
  LamaButton lamaButtonPink = LamaButton();

  //initialise button animators
  late CircleComponent animatorButtonTurkis;
  late CircleComponent animatorButtonBlue;
  late CircleComponent animatorButtonPurple;
  late CircleComponent animatorButtonPink;

  //declare and initialise the colors for button animators
  final buttonAnimatorDefaultColor = PaletteEntry(Color(0xFFebedf0)).paint();
  final buttonAnimatorColorRed = PaletteEntry(Color(0x4cff0006)).paint();
  final buttonAnimatorColorGreen = PaletteEntry(Color(0x6b1cff00)).paint();
  final buttonAnimatorColorOrange = PaletteEntry(Color(0x81ffdd00)).paint();

  //#endregion

  //#region Global Variables Lama Heads
  var amountLamaHeadsPerColumn;
  var lamaHeadsTurkis = <LamaHead>[];
  var lamaHeadsBlue = <LamaHead>[];
  var lamaHeadsPurple = <LamaHead>[];
  var lamaHeadsPink = <LamaHead>[];
  static double lamaHeadSize = 0.0;

  LamaHead lamaHeadTurkis = LamaHead(false, false);
  LamaHead lamaHeadBlue = LamaHead(false, false);
  LamaHead lamaHeadPurple = LamaHead(false, false);
  LamaHead lamaHeadPink = LamaHead(false, false);

  var lamaHeadImageTurkis = 'png/lama_head_turkis.png';
  var lamaHeadImageBlue = 'png/lama_head_blue.png';
  var lamaHeadImagePurple = 'png/lama_head_purple.png';
  var lamaHeadImagePink = 'png/lama_head_pink.png';
  var lamaHeadImageRed = 'png/lama_head_red.png';


  //#endregion

  //#region Global Variables Game Logic
  bool gameOver = false;
  var referenceVelocity;
  var velocity1;
  var velocity2;
  var score = 0;
  var lifePercent = 100.0;
  var streakCounter = 0;
  var scoreIncrementerGoodHit = 10;
  var scoreIncrementerOkayHit = 5;
  var lifeDecreaserStandard = 5.0;
  var lifeDecreaserRedLamaHit = 20.0;
  var lamaHeadAppearingProbability = .3;
  var lamaHeadIsAngryProbability = 0.1;
  var lamaHeadFirstColumExisting = false;
  var lamaHeadThirdColumnExisting = false;
  var scoreThresholdDifferentVelocity = 150;
  var scoreThresholdIncreaseVelocity = 300;
  var scoreThresholdSpacer = 300;
  var firstColumnIsFaster = true;
  var velocityIncreaseFactor1 = 1.2;
  var velocityIncreaseFactor2 = 1.5;
  var recoveryThreshold = 30;
  var multiplierIncreaseThreshold = 20;
  //# endregion

  //# region Override Methods
  @override
  Future<void> onLoad() async {
    super.onLoad();
    initScoreCounterAndLifebar();
    initLamaButtonsWithEffects();
    initLamaHeadColumns();
  }

  @override
  Future<void> update(double dt) async {
    updateLifeBar();
    super.update(dt);
    if (!gameOver) {
      checkHits();
      moveLamaHeads(lamaHeadsTurkis, lamaHeadImageTurkis, 1);
      moveLamaHeads(lamaHeadsBlue, lamaHeadImageBlue, 2);
      moveLamaHeads(lamaHeadsPurple, lamaHeadImagePurple, 3);
      moveLamaHeads(lamaHeadsPink, lamaHeadImagePink, 4);
      updateSpeedParameters();
      checkGameOver();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    scoreText.render(canvas, "Score: " + score.toString(),
        Vector2(screenWidth * 0.05, screenHeight * 0.05));
    streakText.render(canvas, "Streak: " + streakCounter.toString(),
        Vector2(screenWidth * 0.6, screenHeight * 0.05));
  }
  //# endregion

  //#region Check Hits
  Future<void> checkHits() async {
    if (lamaButtonTurkis.buttonPressed) {
      checkSingleHit(lamaHeadsTurkis, lamaButtonTurkis, animatorButtonTurkis);
    } else if (lamaButtonBlue.buttonPressed) {
      checkSingleHit(lamaHeadsBlue, lamaButtonBlue, animatorButtonBlue);
    } else if (lamaButtonPurple.buttonPressed) {
      checkSingleHit(lamaHeadsPurple, lamaButtonPurple, animatorButtonPurple);
    } else if (lamaButtonPink.buttonPressed) {
      checkSingleHit(lamaHeadsPink, lamaButtonPink, animatorButtonPink);
    }
  }

  Future<void> checkSingleHit(List<LamaHead> lamaHeads, LamaButton lamaButton,
      CircleComponent animatorButton) async {
    LamaHead lamaHeadCopy =
        lamaHeads.firstWhere((element) => element.isHittable);
    if (lamaHeadCopy.isExisting) {
      if (lamaHeadCopy.isAngry) {
        lifePercent -= lifeDecreaserRedLamaHit;
        streakCounter = 0;
      } else {
        if (lamaHeadCopy.y >= yPosButtons - lamaButtonSize * 0.2 &&
            lamaHeadCopy.y <= yPosButtons + lamaButtonSize * 0.2) {
          flashButton(lamaButton, buttonAnimatorColorGreen, animatorButton);
          score += scoreIncrementerGoodHit * multiplier;
          streakCounter++;
          recoverLifeBarCheck();
        } else if (lamaHeadCopy.y >= yPosButtons - lamaButtonSize * 0.6 &&
            lamaHeadCopy.y <= yPosButtons + lamaButtonSize * 0.6) {
          flashButton(lamaButton, buttonAnimatorColorOrange, animatorButton);
          score += scoreIncrementerOkayHit * multiplier;
          streakCounter++;
          recoverLifeBarCheck();
        } else {
          flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
          lifePercent -= lifeDecreaserStandard;
          streakCounter = 0;
        }
      }
    } else {
      flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
      lifePercent -= lifeDecreaserStandard;
      streakCounter = 0;
    }
    //
    lamaHeads.firstWhere((element) => element.isHittable).sprite =
        await loadSprite('png/BLANK_ICON.png');
    lamaHeads.firstWhere((element) => element.isHittable).isExisting = false;
  }
  //#endregion

  //#region Visual Effects
  void flashButton(LamaButton lamaButton, Paint paint,
      CircleComponent animatorButton) async {
    animatorButton.paint = paint;
    lamaButton.buttonPressed = false;
    await Future.delayed(Duration(milliseconds: 100));
    animatorButton.paint = buttonAnimatorDefaultColor;
  }

  Future<void> flashMissedHeadAnimator() async {
    missedHeadAnimator.paint = buttonAnimatorColorRed;
    await Future.delayed(Duration(milliseconds: 100));
    missedHeadAnimator.paint = upperInGameDisplayColor;
  }

  void updateLifeBar() {
    lifeBar.x = lifePercent * lifeBarWidth / 100;
  }

  //# endregion

  //#region Initialise Score Counter, Life Bar, Lama Buttons and Button Animators

  void initScoreCounterAndLifebar() {
    //initialising screen size
    screenWidth = size[0];
    screenHeight = size[1];
    screenHeight / screenWidth >= (16 / 9)
        ? amountLamaHeadsPerColumn = 6
        : amountLamaHeadsPerColumn = 5;
    referenceVelocity = screenHeight / 300;
    velocity1 = referenceVelocity;
    velocity2 = referenceVelocity;
    yPosButtons = screenHeight * 5 / 6;

    //initialise upper in game display
    upperInGameDisplayHeight = screenHeight * 0.1;
    upperInGameDisplay =
        UpperInGameDisplay(screenWidth, upperInGameDisplayHeight, 0, 0);
    upperInGameDisplay.paint = upperInGameDisplayColor;
    add(upperInGameDisplay);

    //initialise score and lifebar
    lifeBarHorizontalPosition = screenWidth / 2;
    lifeBarVerticalPosition = screenHeight * 0.03;
    lifeBarWidth = screenWidth;
    lifeBarHeight = screenHeight * 0.03;
    var textSize = screenWidth / 15;
    scoreText = TextPaint(
        style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.black));
    streakText = TextPaint(
        style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: Colors.black));
    RectangleComponent lifebarRedRectangle = RectangleComponent(
        position: Vector2(lifeBarHorizontalPosition, lifeBarVerticalPosition),
        anchor: Anchor.center,
        size: Vector2(lifeBarWidth, lifeBarHeight),
        paint: lifeBarRedColor,
        priority: 4);
    add(lifebarRedRectangle);
    lifeBar = LifeBar(lifeBarWidth, lifeBarHeight, lifeBarHorizontalPosition,
        lifeBarVerticalPosition);
    lifeBar.paint = lifeBarGreenColor;
    lifeBar.anchor = Anchor.centerRight;
    add(lifeBar);
    missedHeadAnimator = MissedHeadAnimator(
        screenWidth, screenHeight * 0.03, screenWidth, screenHeight * 0.985);
    missedHeadAnimator.paint = upperInGameDisplayColor;
    missedHeadAnimator.anchor = Anchor.centerRight;
    add(missedHeadAnimator);
  }

  void initLamaButtonsWithEffects() async {
    //initialise Lama Button and Lama Head sizes
    lamaButtonSize = screenWidth / 6;
    lamaHeadSize = lamaButtonSize * 0.95;

    //initialise all relevant button positions
    xPosTurkis = 1 / 8 * screenWidth;
    xPosBlue = 3 / 8 * screenWidth;
    xPosPurple = 5 / 8 * screenWidth;
    xPosPink = 7 / 8 * screenWidth;

    //specify all button circles
    animatorButtonTurkis = CircleComponent(
        radius: lamaButtonSize * 0.6,
        position: Vector2(xPosTurkis, yPosButtons),
        paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonTurkis);
    animatorButtonBlue = CircleComponent(
        radius: lamaButtonSize * 0.6,
        position: Vector2(xPosBlue, yPosButtons),
        paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonBlue);
    animatorButtonPurple = CircleComponent(
        radius: lamaButtonSize * 0.6,
        position: Vector2(xPosPurple, yPosButtons),
        paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonPurple);
    animatorButtonPink = CircleComponent(
        radius: lamaButtonSize * 0.6,
        position: Vector2(xPosPink, yPosButtons),
        paint: buttonAnimatorDefaultColor);
    initButtonAnimator(animatorButtonPink);

    //specify all LamaButtons
    initLamaButton(lamaButtonTurkis, xPosTurkis, lamaButtonImageTurkis);
    initLamaButton(lamaButtonBlue, xPosBlue, lamaButtonImageBlue);
    initLamaButton(lamaButtonPurple, xPosPurple, lamaButtonImagePurple);
    initLamaButton(lamaButtonPink, xPosPink, lamaButtonImagePink);
  }

  void initLamaButton(
      LamaButton button, double xPos, String imageSource) async {
    button.sprite = await loadSprite(imageSource);
    button.size = Vector2(lamaButtonSize, lamaButtonSize);
    button.y = yPosButtons;
    button.x = xPos;
    button.anchor = Anchor.center;
    add(button);
  }

  void initButtonAnimator(CircleComponent animatorButton) {
    animatorButton.anchor = Anchor.center;
    add(animatorButton);
  }
  //# endregion

  //#region Initialise And Move Lama Heads
  Future<void> initLamaHeadColumns() async {
    initLamaHeadColumn(lamaHeadsTurkis, xPosTurkis, lamaHeadImageTurkis, 1);
    initLamaHeadColumn(lamaHeadsBlue, xPosBlue, lamaHeadImageBlue, 2);
    initLamaHeadColumn(lamaHeadsPurple, xPosPurple, lamaHeadImagePurple, 3);
    initLamaHeadColumn(lamaHeadsPink, xPosPink, lamaHeadImagePink, 4);
  }

  Future<void> initLamaHeadColumn(List<LamaHead> lamaHeadList, double xPos,
      String imageSource, int column) async {
    for (int i = 0; i <= amountLamaHeadsPerColumn; i++) {
      LamaHead lamaHead =
          LamaHead(false, generateRandomBoolean(lamaHeadIsAngryProbability));
      lamaHeadList.add(lamaHead);
      lamaHeadList.elementAt(i).y =
          (screenHeight / amountLamaHeadsPerColumn * i) - lamaHeadSize;
      lamaHeadList.elementAt(i).x = xPos;
      lamaHeadList.elementAt(i).anchor = Anchor.center;
      lamaHeadList.elementAt(i).sprite = await loadSprite('png/BLANK_ICON.png');
      add(lamaHeadList.elementAt(i));
    }
  }

  Future<void> moveLamaHeads(
      List<LamaHead> lamaHeadList, String imageSource, int column) async {
    for (int i = 0; i <= amountLamaHeadsPerColumn; i++) {
      if (lamaHeadList.elementAt(i).y >= screenHeight + lamaHeadSize) {
        lamaHeadList.elementAt(i).y = 0 - lamaHeadSize / 2;
        if (lamaHeadList.elementAt(i).isExisting &&
            !lamaHeadList.elementAt(i).isAngry) {
          lifePercent -= lifeDecreaserStandard;
          streakCounter = 0;
          flashMissedHeadAnimator();
        }
        lamaHeadList.elementAt(i).isAngry =
            generateRandomBoolean(lamaHeadIsAngryProbability);
        switch (column) {
          case 1:
            lamaHeadList.elementAt(i).isExisting =
                generateRandomBoolean(lamaHeadAppearingProbability);
            if (lamaHeadList.elementAt(i).isExisting) {
              lamaHeadFirstColumExisting = true;
            } else {
              lamaHeadFirstColumExisting = false;
            }
            break;
          case 2:
            if (lamaHeadFirstColumExisting) {
              lamaHeadList.elementAt(i).isExisting = false;
            } else {
              lamaHeadList.elementAt(i).isExisting =
                  generateRandomBoolean(lamaHeadAppearingProbability * 2);
            }
            break;
          case 3:
            lamaHeadList.elementAt(i).isExisting =
                generateRandomBoolean(lamaHeadAppearingProbability);
            if (lamaHeadList.elementAt(i).isExisting) {
              lamaHeadThirdColumnExisting = true;
            } else {
              lamaHeadThirdColumnExisting = false;
            }
            break;
          case 4:
            if (lamaHeadThirdColumnExisting) {
              lamaHeadList.elementAt(i).isExisting = false;
            } else {
              lamaHeadList.elementAt(i).isExisting =
                  generateRandomBoolean(lamaHeadAppearingProbability);
            }
            break;
        }
        if (lamaHeadList.elementAt(i).isExisting) {
          lamaHeadList.elementAt(i).size = Vector2(lamaHeadSize, lamaHeadSize);
          if (lamaHeadList.elementAt(i).isAngry) {
            lamaHeadList.elementAt(i).sprite =
                await loadSprite(lamaHeadImageRed);
          } else {
            lamaHeadList.elementAt(i).sprite = await loadSprite(imageSource);
          }
        } else {
          lamaHeadList.elementAt(i).sprite =
              await loadSprite('png/BLANK_ICON.png');
        }
      } else {
        if (column == 1 || column == 2) {
          lamaHeadList.elementAt(i).y += velocity1;
        } else {
          lamaHeadList.elementAt(i).y += velocity2;
        }
        setHittableButtonAttribute(lamaHeadList.elementAt(i));
        if (isAStreak()) {
          lamaHeadList.elementAt(i).angle += 0.1;
        }
      }
    }
  }

  void setHittableButtonAttribute(LamaHead lamaHead) {
    if (lamaHead.y >= yPosButtons - lamaButtonSize) {
      lamaHead.isHittable = true;
    }
    if (lamaHead.y >= yPosButtons + lamaButtonSize) {
      lamaHead.isHittable = false;
    }
  }

  //#endregion

  //#region Game Logic Methods

  bool generateRandomBoolean(double probability) {
    Random r = new Random();
    bool randomBoolean = r.nextDouble() > (1 - probability);
    return randomBoolean;
  }

  void checkGameOver() {
    if (lifePercent <= 0) {
      gameOver = true;
    }
  }

  void updateSpeedParameters() {
    if (score > 1000) {
      velocityIncreaseFactor1 = 1.1;
      velocityIncreaseFactor2 = 1.25;
      lamaHeadIsAngryProbability = 0.2;
    }

    if (score >= scoreThresholdDifferentVelocity - scoreIncrementerGoodHit &&
        score <= scoreThresholdDifferentVelocity + scoreIncrementerGoodHit) {
      if (firstColumnIsFaster) {
        velocity1 = referenceVelocity * velocityIncreaseFactor2;
        velocity2 = referenceVelocity;
        firstColumnIsFaster = false;
      } else {
        velocity1 = referenceVelocity;
        velocity2 = referenceVelocity * velocityIncreaseFactor2;
        firstColumnIsFaster = true;
      }
      scoreThresholdDifferentVelocity =
          scoreThresholdDifferentVelocity + scoreThresholdSpacer;
    } else if (score >=
            scoreThresholdIncreaseVelocity - scoreIncrementerGoodHit &&
        score <= scoreThresholdIncreaseVelocity + scoreIncrementerGoodHit) {
      referenceVelocity = referenceVelocity * velocityIncreaseFactor1;

      velocity1 = referenceVelocity;
      velocity2 = referenceVelocity;
      scoreThresholdIncreaseVelocity =
          scoreThresholdIncreaseVelocity + scoreThresholdSpacer;
    }
  }

  bool isAStreak() {
    if (streakCounter >= multiplierIncreaseThreshold) {
      multiplier = 2;
      return true;
    } else {
      multiplier = 1;
      return false;
    }
  }

  void recoverLifeBarCheck() {
    if (streakCounter != 0 && streakCounter % recoveryThreshold == 0) {
      lifePercent = lifePercent + 10.0;
      if (lifePercent >= 100) {
        lifePercent = 100;
      }
    }
  }
  //#endregion

}
