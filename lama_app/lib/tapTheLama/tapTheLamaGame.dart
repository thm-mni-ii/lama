import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lama_app/app/model/highscore_model.dart';
import 'package:lama_app/app/repository/user_repository.dart';
import 'package:lama_app/tapTheLama/components/LifeBar.dart';
import 'package:lama_app/tapTheLama/components/lamaButton.dart';
import 'package:lama_app/tapTheLama/components/lamaHead.dart';
import 'package:lama_app/tapTheLama/components/missedHeadAnimator.dart';
import 'dart:math';
import 'package:lama_app/tapTheLama/components/upperInGameDisplay.dart';
import '../util/LamaColors.dart';

class TapTheLamaGame extends FlameGame with HasTappables {
  //#region Contructor And Background
  ///constructor and necessary data
  BuildContext context;
  UserRepository? userRepo;
  int? userHighScore;
  int? allTimeHighScore;
  TapTheLamaGame(
      this.context, this.userRepo, this.userHighScore, this.allTimeHighScore);

  ///sets background color
  Color backgroundColor() => Colors.white70;
  //#endregion

  //#region Global Variables Screen
  ///screen size variables for responsiveness
  var screenWidth;
  var screenHeight;

  ///upper in game display variables
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
  late RectangleComponent lifeBarRedRectangle;
  late MissedHeadAnimator missedHeadAnimator;

  //#endregion

  //#region Global Variables Lama Buttons
  ///initialize sizes and positions of buttons and heads
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

  ///initialise Lama Buttons
  LamaButton lamaButtonTurkis = LamaButton();
  LamaButton lamaButtonBlue = LamaButton();
  LamaButton lamaButtonPurple = LamaButton();
  LamaButton lamaButtonPink = LamaButton();

  ///initialise button animators
  late CircleComponent animatorButtonTurkis;
  late CircleComponent animatorButtonBlue;
  late CircleComponent animatorButtonPurple;
  late CircleComponent animatorButtonPink;

  ///declare and initialise the colors for button animators
  final buttonAnimatorDefaultColor = PaletteEntry(Color(0xFFebedf0)).paint();
  final buttonAnimatorColorRed = PaletteEntry(Color(0x4cff0006)).paint();
  final buttonAnimatorColorGreen = PaletteEntry(Color(0x6b1cff00)).paint();
  final buttonAnimatorColorOrange = PaletteEntry(Color(0x81ffdd00)).paint();

  //#endregion

  //#region Global Variables Lama Heads
  ///data structures for lama heads
  var amountLamaHeadsPerColumn;
  var lamaHeadsTurkis = <LamaHead>[];
  var lamaHeadsBlue = <LamaHead>[];
  var lamaHeadsPurple = <LamaHead>[];
  var lamaHeadsPink = <LamaHead>[];
  static double lamaHeadSize = 0.0;

  ///initialising of lama heads
  LamaHead lamaHeadTurkis = LamaHead(false, false);
  LamaHead lamaHeadBlue = LamaHead(false, false);
  LamaHead lamaHeadPurple = LamaHead(false, false);
  LamaHead lamaHeadPink = LamaHead(false, false);

  ///picture sources of lama heads
  var lamaHeadImageTurkis = 'png/lama_head_turkis.png';
  var lamaHeadImageBlue = 'png/lama_head_blue.png';
  var lamaHeadImagePurple = 'png/lama_head_purple.png';
  var lamaHeadImagePink = 'png/lama_head_pink.png';
  var lamaHeadImageRed = 'png/lama_head_red.png';

  //#endregion

  //#region Global Variables Game Logic
  ///general game logic variables
  final gameId = 5;
  bool showMultiplyText = false;
  bool gameOver = false;

  ///variables for velocity and variables to change velocity
  var referenceVelocity;
  var velocity1;
  var velocity2;
  var velocityIncreaseFactor1 = 1.2;
  var velocityIncreaseFactor2 = 1.5;
  var scoreThresholdDifferentVelocity = 150;
  var scoreThresholdIncreaseVelocity = 300;
  var scoreThresholdSpacer = 300;
  var firstColumnIsFaster = true;

  ///score, streak and life variables
  var score = 0;
  var streakScore = 0;
  var scoreSum = 0;
  bool scoreOver1000 = false;
  bool scoreOver2500 = false;
  bool streak = false;
  var lifePercent = 100.0;
  var streakCounter = 0;
  var scoreIncrementerGoodHit = 10;
  var scoreIncrementerOkayHit = 5;
  var lifeDecreaserStandard = 5.0;
  var lifeDecreaserRedLamaHit = 20.0;
  var recoveryModuloDivider = 20;
  var recoverRate = 5;
  var streakThreshold = 20;

  ///lama head appearing variables
  var lamaHeadAppearingProbability = 0.3;
  var lamaHeadIsAngryProbability = 0.1;
  var lamaHeadFirstColumnExisting = false;
  var lamaHeadThirdColumnExisting = false;
  //# endregion

  //#region Global Game Over Variables
  late TextPaint gameOverText;
  late TextPaint gameOverSuccessText;
  late TextPaint gameOverScoreText;
  late TextPaint gameOverAdditionalScoreText;
  var tempUserHighScore;
  var tempAllTimeHighScore;
  var tempSuccessText = "";
  //#endregion

  //# region Override Methods
  ///method that gets loaded one time initially when the game starts
  @override
  Future<void> onLoad() async {
    super.onLoad();
    loadHighScores();
    initScoreDisplayAndLifeBar();
    initLamaButtonsWithEffects();
    initLamaHeadColumns();
  }

  ///method that updates the game regularly differently depending on its state (game over or still ongoing)
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
      updateSpeedAndProbabilityParameters();
      checkIfGameOver();
    } else {
      animateGameOverButtons();
    }
  }

  ///method that renders text regularly depending on its state (game over or still ongoing)
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (!gameOver) {
      scoreText.render(canvas, "Score: " + score.toString(),
          Vector2(screenWidth * 0.05, screenHeight * 0.05));
      streakText.render(canvas, "Streak: " + streakCounter.toString(),
          Vector2(screenWidth * 0.6, screenHeight * 0.05));
    } else {
      showGameOverText(canvas);
    }
  }
  //# endregion

  //#region Check Hits
  ///method to check the hits of all for buttons
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

  ///method that checks a single tap of the user on a button
  Future<void> checkSingleHit(List<LamaHead> lamaHeads, LamaButton lamaButton,
      CircleComponent animatorButton) async {
    ///initialise a copy of the lama head which currently is the nearest to the lama button (specified by isHittable attribute)
    LamaHead lamaHeadCopy =
        lamaHeads.firstWhere((element) => element.isHittable);

    ///checks if the lama head is existing (has an lama head image on the screen)
    if (lamaHeadCopy.isExisting) {
      ///decrease streak and life when an angry (/red) lama head is pressed
      if (lamaHeadCopy.isAngry) {
        lifePercent -= lifeDecreaserRedLamaHit;
        streakCounter = 0;
        //showToast(LamaColors.redAccent, "Aua :(");
      }

      ///if lama head isn't a red lama
      else {
        ///check if center point of the lama head has a deviation of 20% compared to the center of the lama button
        if (lamaHeadCopy.y >= yPosButtons - lamaButtonSize * 0.2 &&
            lamaHeadCopy.y <= yPosButtons + lamaButtonSize * 0.2) {
          ///animate the lama button with flash effect
          flashButton(lamaButton, buttonAnimatorColorGreen, animatorButton);

          ///increment score
          score += scoreIncrementerGoodHit;

          ///check if there is a streak and increment streakScore if so
          if (streak) {
            streakScore += scoreIncrementerGoodHit;
          }

          ///increment the streakCounter and check if lifeBar gets recovered
          streakCounter++;
          recoverLifeBarCheck();
        }

        ///check if center point of the lama head has a deviation of 60% compared to the center of the lama button
        else if (lamaHeadCopy.y >= yPosButtons - lamaButtonSize * 0.6 &&
            lamaHeadCopy.y <= yPosButtons + lamaButtonSize * 0.6) {
          ///animate the lama button with flash effect
          flashButton(lamaButton, buttonAnimatorColorOrange, animatorButton);

          ///increment score
          score += scoreIncrementerOkayHit;

          ///check if there is a streak and increment streakScore if so
          if (streak) {
            streakScore += scoreIncrementerOkayHit;
          }

          ///increment the streakCounter and check if lifeBar gets recovered
          streakCounter++;
          recoverLifeBarCheck();
        }

        ///check if center point of the lama head has a deviation of more than 60% compared to the center of the lama button
        ///if so button gets animated red, life gets decreased and streakCounter gets a reset
        else {
          flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
          lifePercent -= lifeDecreaserStandard;
          streakCounter = 0;
        }
      }
    }

    ///check if there is no lama to tap
    ///if so button gets animated red, life gets decreased and streakCounter gets a reset
    else {
      flashButton(lamaButton, buttonAnimatorColorRed, animatorButton);
      lifePercent -= lifeDecreaserStandard;
      streakCounter = 0;
    }

    ///original lama head gets marked as hit and disappears on the screen
    lamaHeads.firstWhere((element) => element.isHittable).sprite =
        await loadSprite('png/BLANK_ICON.png');
    lamaHeads.firstWhere((element) => element.isHittable).isExisting = false;

    ///animate a toast when streak equals streakThreshold
    if (streakCounter == streakThreshold) {
      showToast(LamaColors.greenAccent, "x2 Punkte!");
    }
  }
  //#endregion

  //#region Visual Effects
  ///method that flashes a button in a certain color for 0.1 seconds
  void flashButton(LamaButton lamaButton, Paint paint,
      CircleComponent animatorButton) async {
    animatorButton.paint = paint;
    lamaButton.buttonPressed = false;
    await Future.delayed(Duration(milliseconds: 100));
    animatorButton.paint = buttonAnimatorDefaultColor;
  }

  ///animates the bottom part of the display in a certain color
  Future<void> flashMissedHeadAnimator() async {
    missedHeadAnimator.paint = buttonAnimatorColorRed;
    await Future.delayed(Duration(milliseconds: 100));
    missedHeadAnimator.paint = upperInGameDisplayColor;
  }

  ///updates the graphics of the lifeBar according to the current life in percent
  void updateLifeBar() {
    lifeBar.x = lifePercent * lifeBarWidth / 100;
  }

  ///animation to let the lama buttons rotate
  void animateGameOverButtons() {
    lamaButtonTurkis.angle -= 0.1;
    lamaButtonBlue.angle -= 0.1;
    lamaButtonPurple.angle += 0.1;
    lamaButtonPink.angle += 0.1;
  }

  ///general method to create a FlutterToast with a certain text and color
  void showToast(Color color, String text) => Fluttertoast.showToast(
        msg: text,
        fontSize: screenWidth * 0.08,
        gravity: ToastGravity.CENTER,
        textColor: color,
        backgroundColor: Colors.white.withOpacity(0.0),
      );
  //# endregion

  //#region Initialise Score Counter, Life Bar, Lama Buttons and Button Animators
  ///method to create a lifeBar and score display on the screen
  void initScoreDisplayAndLifeBar() {
    ///initialising screen size depending on the used device
    screenWidth = size[0];
    screenHeight = size[1];

    ///set amount of the lama heads that fall down responsively (<16/9 height/width ratio stands for tablet device)
    screenHeight / screenWidth >= (16 / 9)
        ? amountLamaHeadsPerColumn = 6
        : amountLamaHeadsPerColumn = 5;

    ///set velocities initially
    referenceVelocity = screenHeight / 300;
    velocity1 = referenceVelocity;
    velocity2 = referenceVelocity;
    yPosButtons = screenHeight * 5 / 6;

    ///initialise upper in game display
    upperInGameDisplayHeight = screenHeight * 0.1;
    upperInGameDisplay =
        UpperInGameDisplay(screenWidth, upperInGameDisplayHeight, 0, 0);
    upperInGameDisplay.paint = upperInGameDisplayColor;
    add(upperInGameDisplay);

    ///initialise score display, streak display and lifeBar
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
    lifeBarRedRectangle = RectangleComponent(
        position: Vector2(lifeBarHorizontalPosition, lifeBarVerticalPosition),
        anchor: Anchor.center,
        size: Vector2(lifeBarWidth, lifeBarHeight),
        paint: lifeBarRedColor,
        priority: 4);
    add(lifeBarRedRectangle);
    lifeBar = LifeBar(lifeBarWidth, lifeBarHeight, lifeBarHorizontalPosition,
        lifeBarVerticalPosition);
    lifeBar.paint = lifeBarGreenColor;
    lifeBar.anchor = Anchor.centerRight;
    add(lifeBar);

    ///initialise the animator on bottom of screen when lama heads where missed
    missedHeadAnimator = MissedHeadAnimator(
        screenWidth, screenHeight * 0.03, screenWidth, screenHeight * 0.985);
    missedHeadAnimator.paint = upperInGameDisplayColor;
    missedHeadAnimator.anchor = Anchor.centerRight;
    add(missedHeadAnimator);
  }

  ///method to initialise all lama buttons with flash effects
  void initLamaButtonsWithEffects() async {
    ///initialise Lama Button and Lama Head sizes
    lamaButtonSize = screenWidth / 6;
    lamaHeadSize = lamaButtonSize * 0.95;

    ///initialise all relevant button positions
    xPosTurkis = 1 / 8 * screenWidth;
    xPosBlue = 3 / 8 * screenWidth;
    xPosPurple = 5 / 8 * screenWidth;
    xPosPink = 7 / 8 * screenWidth;

    ///initialise all button animator circles
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

    ///initialise all LamaButtons
    initLamaButton(lamaButtonTurkis, xPosTurkis, lamaButtonImageTurkis);
    initLamaButton(lamaButtonBlue, xPosBlue, lamaButtonImageBlue);
    initLamaButton(lamaButtonPurple, xPosPurple, lamaButtonImagePurple);
    initLamaButton(lamaButtonPink, xPosPink, lamaButtonImagePink);
  }

  ///method to initialise a single lama button
  void initLamaButton(
      LamaButton button, double xPos, String imageSource) async {
    button.sprite = await loadSprite(imageSource);
    button.size = Vector2(lamaButtonSize, lamaButtonSize);
    button.y = yPosButtons;
    button.x = xPos;
    button.anchor = Anchor.center;
    add(button);
  }

  ///method to initialise a single lama button animator (for flash effect)
  void initButtonAnimator(CircleComponent animatorButton) {
    animatorButton.anchor = Anchor.center;
    add(animatorButton);
  }
  //# endregion

  //#region Initialise And Move Lama Heads
  ///initialise all lama heads
  Future<void> initLamaHeadColumns() async {
    initLamaHeadColumn(lamaHeadsTurkis, xPosTurkis, lamaHeadImageTurkis, 1);
    initLamaHeadColumn(lamaHeadsBlue, xPosBlue, lamaHeadImageBlue, 2);
    initLamaHeadColumn(lamaHeadsPurple, xPosPurple, lamaHeadImagePurple, 3);
    initLamaHeadColumn(lamaHeadsPink, xPosPink, lamaHeadImagePink, 4);
  }

  ///initialise one lama head column
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

  ///method to move the lama heads along the x axis and to generate a new lama head when the old lama head disappears at lower screen end
  Future<void> moveLamaHeads(
      List<LamaHead> lamaHeadList, String imageSource, int column) async {
    for (int i = 0; i <= amountLamaHeadsPerColumn; i++) {
      ///chek if lama head is at lower display end
      if (lamaHeadList.elementAt(i).y >= screenHeight + lamaHeadSize) {
        ///generate new lama head with offset at upper display end
        lamaHeadList.elementAt(i).y = 0 - lamaHeadSize / 4 * 3;

        ///decrease life and end streak when lama reaches lower display end untapped
        if (lamaHeadList.elementAt(i).isExisting &&
            !lamaHeadList.elementAt(i).isAngry) {
          lifePercent -= lifeDecreaserStandard;
          streakCounter = 0;
          flashMissedHeadAnimator();
        }

        ///set newly generated lama head with set probability to an angry (red) lama
        lamaHeadList.elementAt(i).isAngry =
            generateRandomBoolean(lamaHeadIsAngryProbability);

        ///logic to set a new lama just once for two columns
        ///Example: if column one contains a lama at the given position then column 2 can't contain a lama head because game must be playable with two thumbs
        switch (column) {
          case 1:
            lamaHeadList.elementAt(i).isExisting =
                generateRandomBoolean(lamaHeadAppearingProbability);
            if (lamaHeadList.elementAt(i).isExisting) {
              lamaHeadFirstColumnExisting = true;
            } else {
              lamaHeadFirstColumnExisting = false;
            }
            break;
          case 2:
            if (lamaHeadFirstColumnExisting) {
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
                  generateRandomBoolean(lamaHeadAppearingProbability * 2);
            }
            break;
        }

        ///creating the lama head visually
        ///normal lama gets the right image, angry lama gets red lama image and no lama gets a blank png as image
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
      }

      ///move lama heads that are not at lower display end
      else {
        if (column == 1 || column == 2) {
          lamaHeadList.elementAt(i).y += velocity1;
        } else {
          lamaHeadList.elementAt(i).y += velocity2;
        }

        ///set lama head hittable if it is the closest to the lama button
        setHittableButtonAttribute(lamaHeadList.elementAt(i));

        ///rotate lama head if there is a good streak
        if (isAStreak()) {
          lamaHeadList.elementAt(i).angle += 0.1;
        }
      }
    }
  }

  ///set lama head hittable if it is the closest to the lama button
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
  ///method to generate a random boolean depending on passed probability
  bool generateRandomBoolean(double probability) {
    Random r = new Random();
    bool randomBoolean = r.nextDouble() > (1 - probability);
    return randomBoolean;
  }

  ///checks if the game is over and if so saves the high score and opens game over menu
  void checkIfGameOver() {
    if (lifePercent <= 0) {
      saveHighScore();
      openGameOverMenu();
      gameOver = true;
    }
  }

  ///updates speed and probability parameters at certain threshold to make the game harder with time
  void updateSpeedAndProbabilityParameters() {
    ///decrease velocity factor at a score of 1000 so that the game doesn't get to hard
    if (!scoreOver1000) {
      if (score > 1000) {
        velocityIncreaseFactor1 = 1.1;
        velocityIncreaseFactor2 = 1.25;
        lamaHeadIsAngryProbability = 0.2;
        scoreOver1000 = true;
      }
    }

    ///decrease lama head appearing probability at score of 2500 so that the game doesn't get to hard
    if (scoreOver1000 && !scoreOver2500) {
      if (score > 2500) {
        lamaHeadAppearingProbability = 0.2;
        lamaHeadIsAngryProbability = 0.3;
        scoreOver2500 = true;
      }
    }

    ///increases the velocity of all columns, just the left columns and just the right columns alternating so that the game gets harder with higher score
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

  ///method to check if there is a good streak in the game
  bool isAStreak() {
    if (streakCounter >= streakThreshold) {
      streak = true;
      return true;
    } else {
      streak = false;
      return false;
    }
  }

  ///checks if the lifeBar can be recovered by a good streak
  void recoverLifeBarCheck() {
    if (streak &&
        streakCounter > 20 &&
        streakCounter % recoveryModuloDivider == 0) {
      lifePercent = lifePercent + recoverRate;
      if (lifePercent >= 100) {
        lifePercent = 100;
      } else {
        showToast(LamaColors.greenAccent, "+ $recoverRate LP!");
      }
    }
  }
  //#endregion

  //#region load/save score and open game over menu
  ///method to save the high score in the user repo if the score is higher than the old high score
  void saveHighScore() {
    ///total score sum is a sum of the regular score and the streak score
    scoreSum = score + streakScore;
    if (score + streakScore > userHighScore!) {
      userRepo!.addHighscore(Highscore(
          gameID: gameId,
          score: scoreSum,
          userID: userRepo!.authenticatedUser!.id));
    }
  }

  ///method to load the current hig scores from the user repo
  void loadHighScores() async {
    userHighScore = await userRepo!.getMyHighscore(gameId);
    print(userHighScore.toString());
    allTimeHighScore = await userRepo!.getHighscore(gameId);
  }
  //#endregion

  //#region Game Over Methods
  ///method to open the game over menu and remove certain parts of the old game screen
  Future<void> openGameOverMenu() async {
    remove(lifeBar);
    remove(upperInGameDisplay);
    remove(lifeBarRedRectangle);
    RectangleComponent gameOverBackground = RectangleComponent(
        position: Vector2(0, 0),
        anchor: Anchor.topLeft,
        size: Vector2(screenWidth, screenHeight),
        paint: PaletteEntry(Color(0xeaeceaea)).paint(),
        priority: 5);
    add(gameOverBackground);
    createGameOverTextAndGameOverButtons();
  }

  ///method to create the game over text containing current score, user high score and all time high score
  Future<void> createGameOverTextAndGameOverButtons() async {
    ///initialise TextPaint Objects for relevant text parts in the game over menu
    gameOverText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth * 0.15,
            fontWeight: FontWeight.bold,
            color: scoreSum >= userHighScore! && scoreSum != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));

    gameOverSuccessText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
            color: scoreSum >= userHighScore! && scoreSum != 0
                ? LamaColors.greenAccent
                : LamaColors.redAccent));

    gameOverScoreText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth * 0.08,
            fontWeight: FontWeight.bold,
            color: LamaColors.blueAccent));

    gameOverAdditionalScoreText = TextPaint(
        style: TextStyle(
            fontSize: screenWidth * 0.04, color: LamaColors.bluePrimary));

    ///make lama buttons visible and increase their size
    List<LamaButton> lamaButtons = [
      lamaButtonTurkis,
      lamaButtonBlue,
      lamaButtonPurple,
      lamaButtonPink
    ];
    lamaButtons.forEach((element) {
      element.priority = 6;
      element.size = Vector2(lamaButtonSize * 1.2, lamaButtonSize * 1.2);
    });

    ///temporal variables to get a create a correct score text
    tempUserHighScore = userHighScore;
    tempAllTimeHighScore = allTimeHighScore;
    tempSuccessText = "";

    ///creating individual text depending on the score of the player
    if (scoreSum > userHighScore!) {
      tempSuccessText = "Super, dein bestes Spiel bisher!";
      userHighScore = scoreSum;
      tempUserHighScore = scoreSum;
      if (scoreSum > allTimeHighScore!) {
        tempSuccessText = "Wow, ein neuer Highscore!";
        userHighScore = scoreSum;
        allTimeHighScore = scoreSum;
        tempAllTimeHighScore = scoreSum;
      }
    } else if (scoreSum == 0) {
      tempSuccessText = "Das war wohl nichts :(";
      lamaButtons.forEach((element) async {
        element.sprite = await loadSprite(lamaHeadImageRed);
      });
    } else if (scoreSum == userHighScore) {
      tempSuccessText = "Fast!";
    } else {
      tempSuccessText = "Das war wohl nichts :(";
      lamaButtons.forEach((element) async {
        element.sprite = await loadSprite(lamaHeadImageRed);
      });
    }
  }

  ///render all game over texts
  void showGameOverText(Canvas canvas) {
    gameOverText.render(
        canvas, "Game Over!", Vector2(screenWidth * 0.5, screenHeight * 1 / 10),
        anchor: Anchor.center);

    gameOverSuccessText.render(canvas, tempSuccessText,
        Vector2(screenWidth * 0.5, screenHeight * 2 / 10),
        anchor: Anchor.center);

    /// set height of additional game text depending on the height/width ratio of the device
    var yPosAdditionalText;
    screenHeight / screenWidth >= (16 / 9)
        ? yPosAdditionalText = screenHeight * 0.345
        : yPosAdditionalText = screenHeight * 0.325;

    gameOverAdditionalScoreText.render(
        canvas,
        "(Score: $score + Streak-Score: $streakScore)",
        Vector2(screenWidth * 0.15, yPosAdditionalText),
        anchor: Anchor.centerLeft);

    gameOverScoreText.render(
        canvas,
        "Dein Score:     $scoreSum\n\nDein Rekord:  $tempUserHighScore\n\nHigh-Score:    $tempAllTimeHighScore",
        Vector2(screenWidth * 0.15, screenHeight * 4 / 10),
        anchor: Anchor.centerLeft);
  }
  //#endregion
}
