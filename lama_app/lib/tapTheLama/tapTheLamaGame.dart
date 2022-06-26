import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/tapTheLama/components/LifeBar.dart';
import 'package:lama_app/tapTheLama/components/lamaButton.dart';
import 'package:lama_app/tapTheLama/components/lamaHead.dart';
import 'package:lama_app/tapTheLama/components/missedHeadAnimator.dart';
import 'dart:math';

import 'package:lama_app/tapTheLama/components/upperInGameDisplay.dart';
import 'package:lama_app/tetris/tetrisHelper.dart';

import '../util/LamaColors.dart';

class TapTheLamaGame extends FlameGame with HasTappables {

  //constructor and necessary data
  BuildContext context;
  UserRepository? userRepo;
  int? userHighScore;
  int? allTimeHighScore;
  TapTheLamaGame(this.context,this.userRepo, this.userHighScore, this.allTimeHighScore);

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
  late RectangleComponent lifebarRedRectangle;
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
  LamaButton gameOverLamaButton=LamaButton();

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

  final gameId=5;
  var score = 0;
  var streakScore=0;
  var scoreSum=0;
  bool gameOver = false;
  bool streak=false;
  var referenceVelocity;
  var lifePercent = 100.0;
  var streakCounter = 0;

  var scoreIncrementerGoodHit = 10;
  var scoreIncrementerOkayHit = 5;
  var lifeDecreaserStandard = 5.0;
  var lifeDecreaserRedLamaHit = 20.0;
  var lamaHeadAppearingProbability = 0.3;
  var lamaHeadIsAngryProbability = 0.1;
  var lamaHeadFirstColumExisting = false;
  var lamaHeadThirdColumnExisting = false;
  var scoreThresholdDifferentVelocity = 150;
  var scoreThresholdIncreaseVelocity = 300;
  var scoreThresholdSpacer = 300;
  bool scoreOver1000=false;
  bool scoreOver2500=false;
  var firstColumnIsFaster = true;
  var velocity1;
  var velocity2;
  var velocityIncreaseFactor1 = 1.2;
  var velocityIncreaseFactor2 = 1.5;
  var recoveryModuloDivider = 10;
  var recoverRate=5;
  var streakThreshold = 20;

  //# endregion

  //#region Global Game Over Variables
  late TextPaint gameOverText;
  late TextPaint gameOverSuccessText;
  late TextPaint gameOverScoreText;
  late TextPaint gameOverAdditionalScoreText;
  late TextPaint leaveApplicationText;
  var tempUserHighScore;
  var tempAllTimeHighScore;
  var tempSuccessText="";
  //#endregion

  //# region Override Methods
  @override
  Future<void> onLoad() async {
    super.onLoad();
    loadHighScores();
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
      checkIfGameOver();
    }else{
      animateGameOverButton();
      checkIfGameOverButtonIsTapped();
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if(!gameOver){
      scoreText.render(canvas, "Score: " + score.toString(),
          Vector2(screenWidth * 0.05, screenHeight * 0.05));
      streakText.render(canvas, "Streak: " + streakCounter.toString(),
          Vector2(screenWidth * 0.6, screenHeight * 0.05));
    }else{

      showGameOverText(canvas);
    }
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
          score += scoreIncrementerGoodHit;
          if(streak){streakScore+=scoreIncrementerGoodHit;}
          streakCounter++;
          recoverLifeBarCheck();
        } else if (lamaHeadCopy.y >= yPosButtons - lamaButtonSize * 0.6 &&
            lamaHeadCopy.y <= yPosButtons + lamaButtonSize * 0.6) {
          flashButton(lamaButton, buttonAnimatorColorOrange, animatorButton);
          score += scoreIncrementerOkayHit;
          if(streak){streakScore+=scoreIncrementerOkayHit;}
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

  void animateGameOverButton() {
    gameOverLamaButton.angle-=0.1;
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
    lifebarRedRectangle = RectangleComponent(
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

    //specify all button animator circles
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
        lamaHeadList.elementAt(i).y = 0 - lamaHeadSize /4*3;
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
                  generateRandomBoolean(lamaHeadAppearingProbability*2);
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

  void checkIfGameOver() {
    if (lifePercent <= 0) {
      saveHighScore();
      openGameOverMenu();
      createGameOverText();
      gameOver = true;
    }
  }

  void updateSpeedParameters() {
    if(!scoreOver1000){
      if (score > 1000) {
        velocityIncreaseFactor1 = 1.1;
        velocityIncreaseFactor2 = 1.25;
        lamaHeadIsAngryProbability = 0.2;
        scoreOver1000=true;
      }
    }

    if(scoreOver1000 &&!scoreOver2500){
      if(score>2500){
        lamaHeadAppearingProbability=0.2;
        lamaHeadIsAngryProbability = 0.3;
        scoreOver2500=true;
      }
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
    if (streakCounter >= streakThreshold) {
      streak=true;
      return true;
    } else {
      streak=false;
      return false;
    }
  }

  void recoverLifeBarCheck() {
    if (streak && streakCounter != 0 && streakCounter % recoveryModuloDivider == 0) {
      lifePercent = lifePercent + recoverRate;
      if (lifePercent >= 100) {
        lifePercent = 100;
      }
    }
  }
  //#endregion

  //#region load/save score and open game over menu
  void saveHighScore() {
    scoreSum=score+streakScore;
    if(score+streakScore>userHighScore!){
      userRepo!.addHighscore(
          Highscore(
              gameID: gameId,
              score: scoreSum,
              userID: userRepo!.authenticatedUser!.id
          )
      );
    }
  }

  void loadHighScores() async {
    userHighScore = await userRepo!.getMyHighscore(gameId);
    print(userHighScore.toString());
    allTimeHighScore = await userRepo!.getHighscore(gameId);
  }
  //#endregion

  //#region Game Over Methods
  Future<void> openGameOverMenu() async {
    remove(lifeBar);
    remove(upperInGameDisplay);
    remove(lifebarRedRectangle);
    RectangleComponent gameOverBackground = RectangleComponent(
        position: Vector2(0, 0),
        anchor: Anchor.topLeft,
        size: Vector2(screenWidth, screenHeight),
        paint: PaletteEntry(Color(0xeaeceaea)).paint(),
        priority: 5
    );
    add(gameOverBackground);


    gameOverLamaButton.sprite= await loadSprite(lamaButtonImagePurple);
    gameOverLamaButton.size=Vector2(lamaButtonSize*1.5, lamaButtonSize*1.5);
    gameOverLamaButton.x=screenWidth/2;
    gameOverLamaButton.y=yPosButtons;
    gameOverLamaButton.anchor=Anchor.center;
    gameOverLamaButton.priority=6;
    add(gameOverLamaButton);

  }

  void createGameOverText() {
    gameOverText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth*0.15,
            fontWeight: FontWeight.bold,
            color: LamaColors.purplePrimary)

    );


    gameOverSuccessText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth*0.06,
            fontWeight: FontWeight.bold,
            color: LamaColors.purplePrimary)
    );

    gameOverScoreText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth*0.08,
            fontWeight: FontWeight.bold,
            color: LamaColors.blueAccent)
    );

    gameOverAdditionalScoreText= TextPaint(
        style: TextStyle(
            fontSize: screenWidth*0.04,
            color: LamaColors.blueAccent)
    );

    leaveApplicationText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth*0.06,
            fontWeight: FontWeight.bold,
            color: LamaColors.purpleAccent)
    );

    tempUserHighScore=userHighScore;
    tempAllTimeHighScore=allTimeHighScore;
    tempSuccessText="";

    if(scoreSum>userHighScore!){
      tempSuccessText="Super, dein bestes Spiel bisher!";
      userHighScore=scoreSum;
      tempUserHighScore=scoreSum;
      if(scoreSum>allTimeHighScore!){
        tempSuccessText="Wow, ein neuer Highscore!";
        userHighScore=scoreSum;
        allTimeHighScore=scoreSum;
        tempAllTimeHighScore=scoreSum;
      }
    }else if(scoreSum==0){
      tempSuccessText="Das war wohl nichts :(";
    }
    else if(scoreSum==userHighScore){
      tempSuccessText="Fast!";
    }
    else{
      tempSuccessText="Das war wohl nichts :(";
    }
  }

  void showGameOverText(Canvas canvas) {
    var horizontalResponsivenessSpacer;
    var verticalResponsivenessSpacer;
    if(screenHeight / screenWidth >= (16 / 9)){
      horizontalResponsivenessSpacer=0.1;
      verticalResponsivenessSpacer=0.45;
    }else{
      horizontalResponsivenessSpacer=0.15;
      verticalResponsivenessSpacer=0.5;
    }




    gameOverText.render(canvas, "Game Over!",
        Vector2(screenWidth * 0.5, screenHeight * 0.075), anchor: Anchor.center);

    gameOverSuccessText.render(canvas,tempSuccessText,
        Vector2(screenWidth*0.5, screenHeight*0.175), anchor: Anchor.center);

    gameOverAdditionalScoreText.render(canvas," Regulärer Score:\t\t\t\t\t\t\t$score\n\t\t\t+\n Streak-Score:  \t\t\t\t\t\t\t\t$streakScore\n\t\t\t=",
        Vector2(screenWidth*horizontalResponsivenessSpacer, screenHeight*0.275), anchor: Anchor.centerLeft);

    gameOverScoreText.render(canvas,"Dein Score:\t\t$scoreSum\n\nDein Rekord: \t$tempUserHighScore\n\nHigh Score:\t\t$tempAllTimeHighScore",
        Vector2(screenWidth*0.5, screenHeight*verticalResponsivenessSpacer), anchor: Anchor.center);

    leaveApplicationText.render(canvas,"Zum Verlassen das Lama drücken",
        Vector2(screenWidth*0.5, screenHeight*0.7), anchor: Anchor.center);

  }



  void checkIfGameOverButtonIsTapped() {
    if(gameOverLamaButton.buttonPressed){
      //Navigator.pop(context);
    }
  }


  //#endregion
}
