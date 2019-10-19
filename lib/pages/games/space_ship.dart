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

class SpaceShip extends StatefulWidget {
  WrapperState wrapper;

  SpaceShip(this.wrapper);

  @override
  _SpaceShip createState() => _SpaceShip();
}

class _SpaceShip extends State<SpaceShip> {
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
    return gameScaffold = GameScaffold(gameWidget, CL.of(c).l.spaceShip, spaceShipColor,
        () => _score, () => Data.spaceShipHighscore);
  }

  void incrementScore() {
    audioPlayer.play("sounds/space_ship_score.wav", volume: 0.5);

    if (mounted) {
      setState(() {
        _score += 2;
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
  static const double INITIAL_SPEED = 550;
  static const double SPEED_INCREMENT_PER_FRAME = 0.1;
  static const int OBSTACLE_SPACING = 5;

  static Random random = Random();
  List<Obstacle> obstacles = List();

  _SpaceShip parent;

  TextPainter textPainter;
  TextStyle textStyle;
  Offset textPosition;

  Size dimensions;
  String countdownText = "";
  int countdownCounter;

  BuildContext context;

  Paint backgroundPaint;
  Rect backgroundRect;

  Player player;

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
    obstacles.clear();
    Flame.util.initialDimensions().then((value) {
      dimensions = value;
      dimensions = Size(
          dimensions.width, dimensions.height - parent.gameScaffold.appBar.preferredSize.height);

      // Create player
      add(player = Player(this, dimensions.width / 4 * 2, dimensions));

      // Generate obstacles
      for (int i = -7; i < 1; i++) {
        addRandomSprite(i, value);
        addRandomSprite(i, value);
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
      Obstacle spriteWithMinY = obstacles.first;
      List<Obstacle> spritesToReset = List();
      for (Obstacle sprite in obstacles) {
        if (sprite.y >= sprite.dimensions.height) {
          spritesToReset.add(sprite);
        }

        if (sprite.y < spriteWithMinY.y) {
          spriteWithMinY = sprite;
        }

        // Player collision
        int playerTileX = (player.x / (dimensions.width / 4)).round();
        int spriteTileX = (sprite.x / (dimensions.width / 4)).round();
        if (playerTileX == spriteTileX &&
            sprite.y + sprite.height > player.y &&
            sprite.y < player.y + player.height) {
          finishGame();
        }
      }

      for (Obstacle spriteToReset in spritesToReset) {
        randomlyResetSprite(spriteToReset, spriteWithMinY.y);
      }
      if (spritesToReset.length > 0) {
        parent.incrementScore();
      }

      speed += SPEED_INCREMENT_PER_FRAME;
    }
  }

  randomlyResetSprite(Obstacle sprite, double minY) {
    sprite.reset(random.nextInt(4) * sprite.dimensions.width / 4,
        minY - OBSTACLE_SPACING * (sprite.dimensions.width / 4));
  }

  addRandomSprite(int tileY, Size dimensions) {
    addSprite(Obstacle(this, random.nextInt(4), tileY * OBSTACLE_SPACING, dimensions));
  }

  addSprite(Obstacle sprite) {
    add(sprite);
    obstacles.insert(0, sprite);
  }

  handleInput(double dx, double dy) {
    dy -= parent.gameScaffold.appBar.preferredSize.height + 58;
    if (playing && player != null) {
      if (dx < dimensions.width / 2) {
        // Left
        if (player.x > 0) {
          player.x -= dimensions.width / 4;
        }
      } else {
        // Right
        if (player.x < dimensions.width - dimensions.width / 4) {
          player.x += dimensions.width / 4;
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
    bool highscore = parent._score > Data.spaceShipHighscore;
    if (highscore) {
      Data.spaceShipHighscore = parent._score;
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

class Player extends SpriteComponent {
  Game parent;

  Size dimensions;

  Player(this.parent, double x, this.dimensions)
      : super.square(dimensions.width / 4, "spaceship.png") {
    this.x = x;
    this.y = dimensions.height - height * 1.8;
  }

  @override
  void update(double t) {
    if (parent.playing) {}
  }
}

class Obstacle extends SpriteComponent {
  Game parent;

  Size dimensions;

  int tileX;
  int tileY;

  Obstacle(this.parent, this.tileX, this.tileY, this.dimensions)
      : super.square(dimensions.width / 6, "obstacle.png") {
    reset(dimensions.width / 4 * tileX, dimensions.width / 4 * tileY);
  }

  reset(double x, double y) {
    this.x = x + width / 4;
    this.y = y;
  }

  @override
  void update(double t) {
    if (parent.playing) {
      y += t * parent.speed;
    }
  }
}
