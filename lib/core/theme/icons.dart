import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tokens.dart';

/// Icon mapping for FontAwesome icons used in the app
/// Based on the inventory from web_design files
enum AppIcon {
  // Navigation & Actions
  home,
  back,
  next,
  previous,
  close,
  menu,
  search,
  filter,
  sort,
  refresh,
  sync,

  // Chat & Communication
  chat,
  comments,
  commentDots,
  send,
  attach,
  microphone,
  image,
  file,

  // User & Auth
  user,
  lock,
  signIn,
  signOut,

  // Content Management
  edit,
  delete,
  trash,
  archive,
  share,
  download,
  upload,
  save,

  // Organization
  folder,
  folderPlus,
  plus,
  minus,

  // Settings & Configuration
  settings,
  cog,
  palette,
  bell,
  shield,
  database,
  info,

  // Help & Support
  help,
  question,
  book,
  lightbulb,

  // Status & Feedback
  check,
  warning,
  error,
  infoCircle,
  exclamation,

  // UI Elements
  ellipsisH,
  ellipsisV,
  chevronUp,
  chevronDown,
  chevronLeft,
  chevronRight,
  angleUp,
  angleDown,
  angleLeft,
  angleRight,
  anglesUp,
  anglesDown,

  // Specific Features
  graduationCap,
  code,
  sitemap,
  brain,
  inbox,
  history,
  lockKeyhole,

  // Display & Layout
  list,
  grid,
  thLarge,
  bars,

  // Media
  play,
  pause,
  stop,
}

/// Icon mapping class to get FontAwesome icons
class AppIcons {
  AppIcons._();

  /// Get FontAwesome icon data for the given app icon
  static IconData getIcon(AppIcon icon) {
    switch (icon) {
      // Navigation & Actions
      case AppIcon.home:
        return FontAwesomeIcons.house;
      case AppIcon.back:
        return FontAwesomeIcons.arrowLeft;
      case AppIcon.next:
        return FontAwesomeIcons.arrowRight;
      case AppIcon.previous:
        return FontAwesomeIcons.arrowLeft;
      case AppIcon.close:
        return FontAwesomeIcons.xmark;
      case AppIcon.menu:
        return FontAwesomeIcons.bars;
      case AppIcon.search:
        return FontAwesomeIcons.magnifyingGlass;
      case AppIcon.filter:
        return FontAwesomeIcons.filter;
      case AppIcon.sort:
        return FontAwesomeIcons.arrowsUpDown;
      case AppIcon.refresh:
        return FontAwesomeIcons.arrowsRotate;
      case AppIcon.sync:
        return FontAwesomeIcons.arrowsRotate;

      // Chat & Communication
      case AppIcon.chat:
        return FontAwesomeIcons.comment;
      case AppIcon.comments:
        return FontAwesomeIcons.comments;
      case AppIcon.commentDots:
        return FontAwesomeIcons.commentDots;
      case AppIcon.send:
        return FontAwesomeIcons.paperPlane;
      case AppIcon.attach:
        return FontAwesomeIcons.paperclip;
      case AppIcon.microphone:
        return FontAwesomeIcons.microphone;
      case AppIcon.image:
        return FontAwesomeIcons.image;
      case AppIcon.file:
        return FontAwesomeIcons.file;

      // User & Auth
      case AppIcon.user:
        return FontAwesomeIcons.user;
      case AppIcon.lock:
        return FontAwesomeIcons.lock;
      case AppIcon.signIn:
        return FontAwesomeIcons.rightToBracket;
      case AppIcon.signOut:
        return FontAwesomeIcons.rightFromBracket;

      // Content Management
      case AppIcon.edit:
        return FontAwesomeIcons.pen;
      case AppIcon.delete:
        return FontAwesomeIcons.trash;
      case AppIcon.trash:
        return FontAwesomeIcons.trash;
      case AppIcon.archive:
        return FontAwesomeIcons.boxArchive;
      case AppIcon.share:
        return FontAwesomeIcons.share;
      case AppIcon.download:
        return FontAwesomeIcons.download;
      case AppIcon.upload:
        return FontAwesomeIcons.upload;
      case AppIcon.save:
        return FontAwesomeIcons.floppyDisk;

      // Organization
      case AppIcon.folder:
        return FontAwesomeIcons.folder;
      case AppIcon.folderPlus:
        return FontAwesomeIcons.folderPlus;
      case AppIcon.plus:
        return FontAwesomeIcons.plus;
      case AppIcon.minus:
        return FontAwesomeIcons.minus;

      // Settings & Configuration
      case AppIcon.settings:
        return FontAwesomeIcons.gear;
      case AppIcon.cog:
        return FontAwesomeIcons.gear;
      case AppIcon.palette:
        return FontAwesomeIcons.palette;
      case AppIcon.bell:
        return FontAwesomeIcons.bell;
      case AppIcon.shield:
        return FontAwesomeIcons.shield;
      case AppIcon.database:
        return FontAwesomeIcons.database;
      case AppIcon.info:
        return FontAwesomeIcons.info;

      // Help & Support
      case AppIcon.help:
        return FontAwesomeIcons.circleQuestion;
      case AppIcon.question:
        return FontAwesomeIcons.question;
      case AppIcon.book:
        return FontAwesomeIcons.book;
      case AppIcon.lightbulb:
        return FontAwesomeIcons.lightbulb;

      // Status & Feedback
      case AppIcon.check:
        return FontAwesomeIcons.check;
      case AppIcon.warning:
        return FontAwesomeIcons.triangleExclamation;
      case AppIcon.error:
        return FontAwesomeIcons.circleExclamation;
      case AppIcon.infoCircle:
        return FontAwesomeIcons.circleInfo;
      case AppIcon.exclamation:
        return FontAwesomeIcons.exclamation;

      // UI Elements
      case AppIcon.ellipsisH:
        return FontAwesomeIcons.ellipsis;
      case AppIcon.ellipsisV:
        return FontAwesomeIcons.ellipsisVertical;
      case AppIcon.chevronUp:
        return FontAwesomeIcons.chevronUp;
      case AppIcon.chevronDown:
        return FontAwesomeIcons.chevronDown;
      case AppIcon.chevronLeft:
        return FontAwesomeIcons.chevronLeft;
      case AppIcon.chevronRight:
        return FontAwesomeIcons.chevronRight;
      case AppIcon.angleUp:
        return FontAwesomeIcons.angleUp;
      case AppIcon.angleDown:
        return FontAwesomeIcons.angleDown;
      case AppIcon.angleLeft:
        return FontAwesomeIcons.angleLeft;
      case AppIcon.angleRight:
        return FontAwesomeIcons.angleRight;
      case AppIcon.anglesUp:
        return FontAwesomeIcons.anglesUp;
      case AppIcon.anglesDown:
        return FontAwesomeIcons.anglesDown;

      // Specific Features
      case AppIcon.graduationCap:
        return FontAwesomeIcons.graduationCap;
      case AppIcon.code:
        return FontAwesomeIcons.code;
      case AppIcon.sitemap:
        return FontAwesomeIcons.sitemap;
      case AppIcon.brain:
        return FontAwesomeIcons.brain;
      case AppIcon.inbox:
        return FontAwesomeIcons.inbox;
      case AppIcon.history:
        return FontAwesomeIcons.clockRotateLeft;
      case AppIcon.lockKeyhole:
        return FontAwesomeIcons.lock;

      // Display & Layout
      case AppIcon.list:
        return FontAwesomeIcons.list;
      case AppIcon.grid:
        return FontAwesomeIcons.tableCells;
      case AppIcon.thLarge:
        return FontAwesomeIcons.tableCellsLarge;
      case AppIcon.bars:
        return FontAwesomeIcons.bars;

      // Media
      case AppIcon.play:
        return FontAwesomeIcons.play;
      case AppIcon.pause:
        return FontAwesomeIcons.pause;
      case AppIcon.stop:
        return FontAwesomeIcons.stop;
    }
  }

  /// Get icon size based on the token size
  static double getIconSize(double tokenSize) {
    return tokenSize;
  }

  /// Get default icon size
  static double get defaultIconSize => AppTokens.iconSizeM;
}
