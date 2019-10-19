import 'dart:async';
import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/pages/games/game_scaffold.dart';
import 'package:inf_sim/util/audio.dart';
import 'package:inf_sim/util/custom_colors.dart';
import 'package:inf_sim/util/input.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/time_utils.dart';

import '../wrapper.dart';

class BalloonPop extends StatefulWidget {
  WrapperState wrapper;

  BalloonPop(this.wrapper);

  @override
  _BalloonPop createState() => _BalloonPop();
}

class _BalloonPop extends State<BalloonPop> {
  GameScaffold gameScaffold;
  Game game;
  Widget gameWidget;

  int _score = 0;

  @override
  initState() {
    super.initState();
    game = Game(this);
    gameWidget = game.widget;
  }

  @override
  Widget build(BuildContext c) {
    game.parent = this;
    game.context = c;
    return gameScaffold = GameScaffold(gameWidget, CL.of(c).l.balloonPop, balloonPopColor,
        () => _score, () => Data.balloonPopHighscore);
  }

  void incrementScore() {
    audioPlayer.play("sounds/balloon_pop_score.wav", volume: 0.5);

    if (mounted) {
      setState(() {
        _score++;
      });
    }
  }

  resetScores() {
    if (mounted) {
      setState(() {
        _score = 0;
      });
    }
  }
}

class Game extends BaseGame {
  static const double INITIAL_SPEED = 150;
  static const double SPEED_INCREMENT_PER_FRAME = 0.05;

  static Random random = Random();
  List<Balloon> balloons = List();

  _BalloonPop parent;

  TextPainter textPainter;
  TextStyle textStyle;
  Offset textPosition;

  Size dimensions;
  String countdownText = "";
  int countdownCounter;

  BuildContext context;

  Paint backgroundPaint;
  Rect backgroundRect;

  // Game variables
  double speed = INITIAL_SPEED;
  bool playing = false;
  bool countdown = false;

  Game(this.parent) : super() {
    init();
    newGame();
  }

  @override
  void resize(Size screenSize) {
    super.resize(screenSize);
    backgroundRect = Rect.fromLTWH(0, 0, screenSize.width, screenSize.height);
  }

  void newGame() {
    // Load countdown text
    textStyle = TextStyle(
      color: Colors.black,
      fontSize: 90,
      shadows: <Shadow>[
        Shadow(
          blurRadius: 7,
          color: Colors.white,
          offset: Offset(3, 3),
        ),
      ],
    );

    textPainter = TextPainter(textAlign: TextAlign.center, textDirection: TextDirection.ltr);
    textPosition = Offset.zero;

    // Initialize game screen
    components.clear();
    balloons.clear();
    Flame.util.initialDimensions().then((value) {
      dimensions = value;
      dimensions = Size(
          dimensions.width, dimensions.height - parent.gameScaffold.appBar.preferredSize.height);
      int start = dimensions.height ~/ (dimensions.width / 4);
      for (int i = start; i < start + 7; i++) {
        addRandomSprite(i, value);
      }
    });

    // Reset variables
    playing = false;
    speed = INITIAL_SPEED;
    parent.resetScores();

    // Start countdown timer
    startCountdown();
  }

  void startCountdown() async {
    countdown = true;
    countdownCounter = 3;
    countdownText = countdownCounter.toString();

    await Future.delayed(Duration(milliseconds: 250));
    for (int i = 0; i < 3; i++) {
      audioPlayer.play("sounds/countdown.wav");
      countdownText = countdownCounter.toString();
      await Future.delayed(Duration(milliseconds: 500));
      countdownCounter--;
    }
    audioPlayer.play("sounds/go.wav");

    countdown = false;
    startGame();
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(backgroundRect, backgroundPaint);
    super.render(canvas);
    if (countdown) {
      textPainter.paint(canvas, textPosition);
    }
  }

  @override
  void update(double t) {
    super.update(t);

    // Countdown
    if (countdown) {
      textPainter.text = TextSpan(text: countdownText, style: textStyle);
      textPainter.layout();
      if (dimensions != null) {
        textPosition = Offset((dimensions.width / 2) - (textPainter.width / 2),
            (dimensions.height / 2) - (textPainter.height / 2));
      }
    }

    // Game objects
    if (playing) {
      Balloon spriteWithMaxY = balloons.first;
      Balloon spriteToReset;

      for (Balloon sprite in balloons) {
        if (sprite.y <= -sprite.height && sprite.popped) {
          spriteToReset = sprite;
        } else if (sprite.y < -sprite.height / 2 && (!sprite.popped)) {
          finishGame();
        }

        if (sprite.y > spriteWithMaxY.y) {
          spriteWithMaxY = sprite;
        }
      }

      if (spriteToReset != null) {
        randomlyResetSprite(spriteToReset, spriteWithMaxY.y);
      }

      speed += SPEED_INCREMENT_PER_FRAME;
    }
  }

  randomlyResetSprite(Balloon sprite, double minY) {
    sprite.reset(
        random.nextInt(4) * sprite.dimensions.width / 4, minY + sprite.dimensions.width / 4);
  }

  addRandomSprite(int tileY, Size dimensions) {
    addSprite(Balloon(this, random.nextInt(4), tileY, dimensions));
  }

  addSprite(Balloon sprite) {
    add(sprite);
    balloons.insert(0, sprite);
  }

  handleInput(double dx, double dy) {
    dy -= parent.gameScaffold.appBar.preferredSize.height + 58;
    if (playing) {
      for (Balloon sprite in balloons) {
        Rect r = sprite.toRect();
        if (dx > r.left && dx < r.right && dy > r.top && dy < r.bottom) {
          sprite.pop();
        }
      }
    }
  }

  startGame() {
    playing = true;
  }

  finishGame() {
    if (!playing) {
      return;
    }

    audioPlayer.play("sounds/lose.wav");

    playing = false;

    int today = TimeUtils.todayAsDay();

    // Score
    bool highscore = parent._score > Data.balloonPopHighscore;
    if (highscore) {
      Data.balloonPopHighscore = parent._score;
    }

    // Increase money and followers
    int moneyScore = GameLogic.increaseMoneyFromScore(parent._score, today);
    int followerScore = GameLogic.increaseFollowersFromScore(parent._score, today);

    // Show dialog
    showGameFinishedDialog(context, parent._score, highscore, moneyScore, followerScore,
        () => newGame(), () => parent.widget.wrapper.switchToIndex(WrapperState.HOME));
  }

  void init() {
    Input.addTapReceiver(handleInput);

    backgroundPaint = Paint();
    backgroundPaint.color = Color(0xffffffff);
  }
}

class Balloon extends SpriteComponent {
  Random random = Random();

  static const int RED = 0;
  static const int BLUE = 1;
  static const int GREEN = 2;
  static const int YELLOW = 3;

  Game parent;

  Size dimensions;
  bool popped;

  int type;

  Balloon(this.parent, int tileX, int tileY, this.dimensions)
      : super.square(dimensions.width / 4, "balloon_red.png") {
    reset(dimensions.width / 4 * tileX, dimensions.width / 4 * tileY);
  }

  reset(double x, double y) {
    this.x = x;
    this.y = y;
    popped = false;
    type = random.nextInt(YELLOW + 1);
    updateCurrentImage();
  }

  @override
  void update(double t) {
    if (parent.playing) {
      y -= t * parent.speed;
    }
  }

  String getCurrentImageName() {
    switch (type) {
      case RED:
        return "balloon_red.png";
      case BLUE:
        return "balloon_blue.png";
      case GREEN:
        return "balloon_green.png";
      case YELLOW:
        return "balloon_yellow.png";
      default:
        throw "invalid type: $type";
    }
  }

  void pop() {
    switch (type) {
      case RED:
        if (!popped) {
          parent.parent.incrementScore();
          popped = true;
        }
        break;
      case BLUE:
      case GREEN:
      case YELLOW:
        type--;
        parent.parent.incrementScore();
        updateCurrentImage();
    }
  }

  @override
  void render(Canvas canvas) {
    if (!popped) {
      super.render(canvas);
    }
  }

  void updateCurrentImage() {
    Flame.images.load(getCurrentImageName()).then((img) {
      sprite.image = img;
    });
  }
}
