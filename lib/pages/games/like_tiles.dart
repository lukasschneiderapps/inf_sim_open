import 'dart:async';
import 'dart:math';

import 'package:flame/components/component.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:inf_sim/data/data.dart';
import 'package:inf_sim/logic/game_logic.dart';
import 'package:inf_sim/util/audio.dart';
import 'package:inf_sim/util/custom_colors.dart';
import 'package:inf_sim/util/input.dart';
import 'package:inf_sim/util/localization.dart';
import 'package:inf_sim/util/time_utils.dart';

import '../wrapper.dart';
import 'game_scaffold.dart';

class LikeTiles extends StatefulWidget {
  WrapperState wrapper;

  LikeTiles(this.wrapper);

  @override
  _LikeTiles createState() => _LikeTiles();
}

class _LikeTiles extends State<LikeTiles> {
  Game game;
  Widget gameWidget;
  GameScaffold gameScaffold;

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
    return gameScaffold = GameScaffold(gameWidget, CL.of(c).l.likeTiles, likeTilesColor,
        () => _score, () => Data.likeTilesHighscore);
  }

  void incrementScore() {
    audioPlayer.play("sounds/like_tiles_score.wav", volume: 0.5);

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
  static const double INITIAL_SPEED = 400;
  static const double SPEED_INCREMENT_PER_FRAME = 0.1;

  static Random random = Random();
  List<LikeTile> likeTiles = List();

  _LikeTiles parent;

  TextPainter textPainter;
  TextStyle textStyle;
  Offset textPosition;

  Size dimensions;
  String countdownText = "";
  int countdownCounter;

  BuildContext context;

  Paint whitePaint;
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
    //super.resize(screenSize);
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
    likeTiles.clear();
    Flame.util.initialDimensions().then((value) {
      dimensions = value;
      dimensions = Size(
          dimensions.width, dimensions.height - parent.gameScaffold.appBar.preferredSize.height);
      for (int i = -7; i < 2; i++) {
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
    canvas.drawRect(backgroundRect, whitePaint);
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
      LikeTile spriteWithMinY = likeTiles.first;
      LikeTile spriteToReset;

      for (LikeTile sprite in likeTiles) {
        if (sprite.y >= sprite.dimensions.height && sprite.filled) {
          spriteToReset = sprite;
        } else if (sprite.y > dimensions.height - sprite.height / 2 && (!sprite.filled)) {
          finishGame();
        }

        if (sprite.y < spriteWithMinY.y) {
          spriteWithMinY = sprite;
        }
      }

      if (spriteToReset != null) {
        randomlyResetSprite(spriteToReset, spriteWithMinY.y);
      }

      speed += SPEED_INCREMENT_PER_FRAME;
    }
  }

  randomlyResetSprite(LikeTile sprite, double minY) {
    sprite.reset(
        random.nextInt(4) * sprite.dimensions.width / 4, minY - sprite.dimensions.width / 4);
  }

  addRandomSprite(int tileY, Size dimensions) {
    addSprite(LikeTile(this, random.nextInt(4), tileY, dimensions));
  }

  addSprite(LikeTile sprite) {
    add(sprite);
    likeTiles.insert(0, sprite);
  }

  handleInput(double dx, double dy) {
    dy -= parent.gameScaffold.appBar.preferredSize.height + 58;
    if (playing) {
      for (LikeTile sprite in likeTiles) {
        Rect r = sprite.toRect();
        if (dx > r.left && dx < r.right && dy > r.top && dy < r.bottom) {
          sprite.setFilled();
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
    bool highscore = parent._score > Data.likeTilesHighscore;
    if (highscore) {
      Data.likeTilesHighscore = parent._score;
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

    whitePaint = Paint();
    whitePaint.color = Color(0xffffffff);
  }
}

class LikeTile extends SpriteComponent {
  Game parent;

  Size dimensions;
  bool filled;

  LikeTile(this.parent, int tileX, int tileY, this.dimensions)
      : super.square(dimensions.width / 4, "heart_outline.png") {
    reset(dimensions.width / 4 * tileX, dimensions.width / 4 * tileY);
  }

  reset(double x, double y) {
    this.x = x;
    this.y = y;
    filled = false;
    Flame.images.load(getCurrentImageName()).then((img) {
      sprite.image = img;
    });
  }

  @override
  void update(double t) {
    if (parent.playing) {
      y += t * parent.speed;
    }
  }

  void setFilled() {
    if (!filled) {
      parent.parent.incrementScore();
      filled = true;
      Flame.images.load(getCurrentImageName()).then((img) {
        sprite.image = img;
      });
    }
  }

  String getCurrentImageName() => filled ? "heart_filled.png" : "heart_outline.png";
}
