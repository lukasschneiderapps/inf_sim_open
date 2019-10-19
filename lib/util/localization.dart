import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:inf_sim/logic/game_logic.dart';

// CL = Custom Localizations
abstract class AbstractCL {
  ///
  /// GENERAL
  ///
  get appName;

  get okay;

  get close;

  get unknown;

  get aboutText;

  ///
  /// PAGES
  ///

  // Games
  get gamesExplanation;

  get likeTiles;

  get balloonPop;

  get spaceShip;

  get play;

  // Profile

  get posts;

  get followers;

  // Like Tiles
  get money;

  get playAgain;

  get back;

  get gameFinished;

  get score;

  get highscore;

  get newHighscore;

  get reward;

  // Stats
  get today;

  get sevenDays;

  get likes;

  get statsHint;

  get revenue;

  // Splash
  get infSim;

  get createdBy;

  // Home
  get letsGo;

  get welcome;

  get firstStartMessage;

  get notEnoughMoney;

  get createPost;

  get gamesTitle;

  get shopTitle;

  get statsTitle;

  get profileTitle;

  get error;

  get postCooldownMsg;

  // Shop

  get likesPerSecond;

  get followersPerSecond;

  get moneyPerSecond;

  get level;

  get like4Like;

  get photographer;

  get bot;

  get commentSpamming;

  get imageEditing;

  get affiliate;

  get agency;

  get deliverNewspaper;

  get ads;

  get postsPerHour;

  get max;

  get rankNoob;

  get hacking;

  get rankBeginner;

  get collaborations;

  get aiBot;

  get productPlacements;

  get merchandise;

  get viralMarketing;

  get magic;

  get marketingManager;

  get cryptoTrading;

  get realEstate;
}

class DeCustomLocalization extends AbstractCL {
  get letsGo => "Los geht's";

  get firstStartMessage =>
      "Worum geht es in diesem Spiel?\n\nEs geht um..\n- Mehr Follower\n- Mehr Geld\n- Mehr Likes\n\nIndem du..\n- Posts erstellst\n- Spiele spielst\n- Upgrades kaufst\n\nHinweis: Pro 10 Likes verdienst du \$1\n\nViel Spaß!";

  get welcome => "Herzlich Willkommen!";

  get close => "Schließen";

  get aboutText =>
      "Erstellt von Lukas Schneider Apps.\n\nDatenschutz: https://lukasschneider.info/android-apps-privacy-policy-de\n\nImpressum: https://lukasschneider.info/impressum";

  get createdBy => "Lukas Schneider Apps - 2019";

  get spaceShip => "Space Ship";

  get gamesExplanation => "Spiele, um Geld and Follower zu erhalten";

  get balloonPop => "Balloon Pop";

  get reward => "Belohnung";

  get newHighscore => "NEUER REKORD!";

  get score => "Score";

  get highscore => "Rekord";

  get postCooldownMsg =>
      "Bitte warte einen Augenblick, bis du wieder einen Post erstellen kannst..";

  get cryptoTrading => "Kryptowährungs Handel";

  get realEstate => "Immobilien";

  get marketingManager => "Marketing Manager";

  get hacking => "Hacking";

  get viralMarketing => "Virales Marketing";

  get merchandise => "Merchandise";

  get productPlacements => "Produkt Platzierungen";

  get aiBot => "Künstliche Intelligenz Bot";

  get collaborations => "Kollaborationen";

  get photographer => "Persönlicher Fotograf";

  get affiliate => "Affiliate Marketing";

  get bot => "Bot";

  get imageEditing => "Bild Bearbeitungs Fähigkeiten";

  get rankNoob => "Noob";

  get ads => "Werbung";

  get rankBeginner => "Anfänger";

  get max => "MAX";

  get postsPerHour => "Posts / h";

  get moneyPerSecond => "\$ pro Sekunde";

  get deliverNewspaper => "Zeitung austragen";

  get money => "Geld";

  get createPost => "Post erstellen";

  get like4Like => "Like 4 Like";

  get commentSpamming => "Kommentar Spam";

  get agency => "Marketing Agentur";

  get likesPerSecond => "Likes pro Sekunde";

  get followersPerSecond => "Follower pro Sekunde";

  get level => "LV.";

  get revenue => "Umsatz";

  get statsHint => "Pro ${1.0 ~/ GameLogic.DOLLARS_PER_LIKE} Likes verdienst du \$1";

  get today => "Heute";

  get sevenDays => "Letzte 7 Tage";

  get likes => "Likes";

  get posts => "Posts";

  get followers => "Follower";

  get playAgain => "Erneut spielen";

  get back => "Zurück";

  get gameFinished => "Spiel beendet";

  get play => "Spielen";

  get likeTiles => "Like Tiles";

  get okay => "Okay";

  get appName => "Influencer Simulator";

  get infSim => "Influencer\nSimulator";

  get notEnoughMoney => "Du hast nicht genug Geld";

  get gamesTitle => "Spiele";

  get shopTitle => "Upgrades";

  get statsTitle => "Statistik";

  get profileTitle => "Mein Profil";

  get error => "-/-";

  get unknown => "???";

  get magic => "Magie";
}

class EnCustomLocalization extends AbstractCL {
  get firstStartMessage =>
      "What is this game about?\n\nIt's about getting..\n- More followers\n- More money\n- More likes\n\nBy..\n- Creating posts\n- Playing games\n- Buying upgrades\n\nNote: Per 10 likes you earn \$1\n\nHave fun!";

  get letsGo => "Let's go!";

  get welcome => "Welcome!";

  get close => "Close";

  get aboutText =>
      "Created by Lukas Schneider Apps.\n\nPrivacy Policy: https://lukasschneider.info/android-apps-privacy-policy-en\n\nImprint: https://lukasschneider.info/impressum";

  get createdBy => "Lukas Schneider Apps - 2019";

  get spaceShip => "Space Ship";

  get gamesExplanation => "Play games to get money and followers";

  get balloonPop => "Balloon Pop";

  get reward => "Reward";

  get newHighscore => "NEW BEST!";

  get score => "Score";

  get highscore => "Best";

  get postCooldownMsg => "Please wait until you can create another post..";

  get cryptoTrading => "Cryptocurrency Trading";

  get realEstate => "Real Estate";

  get marketingManager => "Marketing Manager";

  get hacking => "Hacking";

  get magic => "Magic";

  get viralMarketing => "Viral Marketing";

  get merchandise => "Merchandise";

  get productPlacements => "Product Placements";

  get aiBot => "Artificial Intelligence Bot";

  get collaborations => "Collaborations";

  get photographer => "Personal Photographer";

  get affiliate => "Affiliate Marketing";

  get bot => "Bot";

  get ads => "Advertisements";

  get imageEditing => "Image Editing Skills";

  get rankNoob => "Noob";

  get rankBeginner => "Beginner";

  get max => "MAX";

  get postsPerHour => "Posts / h";

  get moneyPerSecond => "\$ per second";

  get deliverNewspaper => "Deliver Newspaper";

  get money => "Money";

  get createPost => "Create post";

  get like4Like => "Like 4 Like";

  get commentSpamming => "Comment Spamming";

  get agency => "Marketing Agency";

  get likesPerSecond => "Likes per second";

  get followersPerSecond => "Followers per second";

  get level => "LV.";

  get revenue => "Revenue";

  get statsHint => "You earn \$1 per ${1.0 ~/ GameLogic.DOLLARS_PER_LIKE} likes";

  get today => "Today";

  get sevenDays => "Last 7 Days";

  get likes => "Likes";

  get posts => "Posts";

  get followers => "Followers";

  get playAgain => "Play again";

  get back => "Back";

  get gameFinished => "Game finished";

  get play => "Play";

  get likeTiles => "Like Tiles";

  get okay => "Okay";

  get appName => "Influencer Simulator";

  get infSim => "Influencer\nSimulator";

  get notEnoughMoney => "You don't have enough money";

  get gamesTitle => "Games";

  get shopTitle => "Upgrades";

  get statsTitle => "Statistics";

  get profileTitle => "My profile";

  get error => "-/-";

  get unknown => "???";
}

// CL = Custom Localizations
class CL {
  Locale locale;
  AbstractCL customLocalization;

  static CL instance;

  CL(Locale locale) {
    this.locale = locale;
    if (locale.languageCode == "de") {
      customLocalization = DeCustomLocalization();
    } else {
      customLocalization = EnCustomLocalization();
    }
  }

  static CL of(BuildContext context) {
    if (instance == null) {
      instance = Localizations.of<CL>(context, CL);
    }
    return instance;
  }

  AbstractCL get l => customLocalization;
}

class CustomLocalizationsDelegate extends LocalizationsDelegate<CL> {
  const CustomLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'de'].contains(locale.languageCode);

  @override
  Future<CL> load(Locale locale) {
    return SynchronousFuture<CL>(CL(locale));
  }

  @override
  bool shouldReload(CustomLocalizationsDelegate old) => false;
}
