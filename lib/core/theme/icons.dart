import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tokens.dart';

/// Icon mapping for FontAwesome icons used in the app
/// Organized by categories matching web_design/assets/js/icons.js
enum AppIcon {
  // البرمجة والتقنية - Programming & Technology (24 icons)
  code,
  laptopCode,
  terminal,
  bug,
  cogs,
  microchip,
  server,
  networkWired,
  shieldAlt,
  key,
  database,
  table,
  chartBar,
  mobileAlt,
  globe,
  cloud,
  robot,
  brain,
  sitemap,
  projectDiagram,
  fileCode,
  codeBranch,
  codeMerge,
  codeCompare,

  // الرياضيات والإحصائيات - Mathematics & Statistics (23 icons)
  calculator,
  squareRootAlt,
  infinity,
  percentage,
  chartLine,
  chartPie,
  chartArea,
  sortNumericUp,
  sortNumericDown,
  equals,
  plus,
  minus,
  times,
  divide,
  superscript,
  subscript,
  sigma,
  pi,
  function,
  integral,
  triangle,
  omega,
  theta,

  // العلوم والكيمياء - Science & Chemistry (23 icons)
  atom,
  flask,
  microscope,
  dna,
  leaf,
  seedling,
  droplet,
  fire,
  bolt,
  magnet,
  satellite,
  rocket,
  sun,
  moon,
  star,
  telescope,
  vial,
  pills,
  stethoscope,
  heartbeat,
  eye,
  ear,
  nose,
  tooth,
  bone,
  lungs,
  liver,
  kidney,
  stomach,
  intestines,

  // الدراسة والأكاديمية - Study & Academic (27 icons)
  graduationCap,
  book,
  bookOpen,
  pen,
  pencilAlt,
  highlighter,
  stickyNote,
  clipboard,
  fileAlt,
  folder,
  archive,
  calendarAlt,
  clock,
  stopwatch,
  hourglassHalf,
  bell,
  flag,
  trophy,
  medal,
  certificate,
  award,
  userGraduate,
  chalkboardTeacher,
  chalkboard,
  search,
  questionCircle,
  lightbulb,

  // الإبداع والتصميم - Creativity & Design (25 icons)
  palette,
  paintBrush,
  magic,
  sparkles,
  eyeDropper,
  camera,
  video,
  music,
  headphones,
  gamepad,
  dice,
  puzzlePiece,
  cube,
  gem,
  crown,
  ribbon,

  // العمل الجماعي والتواصل - Collaboration & Communication (24 icons)
  users,
  userFriends,
  handshake,
  comments,
  commentDots,
  envelope,
  phone,
  videoCamera,
  shareAlt,
  link,
  sync,
  download,
  upload,
  print,
  copy,
  paperPlane,
  inbox,
  send,
  bellSlash,

  // Navigation & Common Actions
  home,
  back,
  next,
  previous,
  close,
  menu,
  filter,
  sort,
  refresh,

  // Chat & Communication
  chat,
  attach,
  image,
  file,
  message,
  reply,
  share,
  paperclip,

  // User & Auth
  user,
  lock,
  signIn,
  signOut,

  // Content Management
  edit,
  delete,
  trash,
  save,

  // Organization
  folderPlus,
  folderOpen,
  heart,
  thumbtack,

  // Settings & Configuration
  settings,
  cog,
  shield,
  info,

  // Help & Support
  help,
  question,

  // Status & Feedback
  check,
  warning,
  error,
  infoCircle,
  exclamation,
  exclamationTriangle,

  // UI Elements
  ellipsis,
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
  upRightAndDownLeftFromCenter, // f424 - expand
  downLeftAndUpRightToCenter, // f422 - collapse
  // Specific Features
  history,
  lockKeyhole,
  unlock,
  microphone,
  fileCodeIcon,

  // Display & Layout
  list,
  grid,
  thLarge,
  bars,

  // Media
  play,
  pause,
  stop,
  film,
  fileText,

  // File Types
  fileLines,

  // Arrows & Direction
  arrowLeft,
  arrowRight,
  arrowUp,
  arrowDown,
  arrowTurnUpLeft,
  arrowTurnUpRight,
  arrowTurnDownLeft,
  arrowTurnDownRight,

  // Common UI
  xmark,
  checkCircle,
  timesCircle,
  infoCircleIcon,
  exclamationCircle,
}

/// Icon mapping class to get FontAwesome icons
class AppIcons {
  AppIcons._();

  /// Get FontAwesome icon data for the given app icon
  static IconData getIcon(AppIcon icon) {
    switch (icon) {
      // البرمجة والتقنية - Programming & Technology
      case AppIcon.code:
        return FontAwesomeIcons.code;
      case AppIcon.laptopCode:
        return FontAwesomeIcons.laptopCode;
      case AppIcon.terminal:
        return FontAwesomeIcons.terminal;
      case AppIcon.bug:
        return FontAwesomeIcons.bug;
      case AppIcon.cogs:
        return FontAwesomeIcons.gears;
      case AppIcon.microchip:
        return FontAwesomeIcons.microchip;
      case AppIcon.server:
        return FontAwesomeIcons.server;
      case AppIcon.networkWired:
        return FontAwesomeIcons.networkWired;
      case AppIcon.shieldAlt:
        return FontAwesomeIcons.shieldHalved;
      case AppIcon.key:
        return FontAwesomeIcons.key;
      case AppIcon.database:
        return FontAwesomeIcons.database;
      case AppIcon.table:
        return FontAwesomeIcons.table;
      case AppIcon.chartBar:
        return FontAwesomeIcons.chartBar;
      case AppIcon.mobileAlt:
        return FontAwesomeIcons.mobileScreen;
      case AppIcon.globe:
        return FontAwesomeIcons.globe;
      case AppIcon.cloud:
        return FontAwesomeIcons.cloud;
      case AppIcon.robot:
        return FontAwesomeIcons.robot;
      case AppIcon.brain:
        return FontAwesomeIcons.brain;
      case AppIcon.sitemap:
        return FontAwesomeIcons.sitemap;
      case AppIcon.projectDiagram:
        return FontAwesomeIcons.diagramProject;
      case AppIcon.fileCode:
        return FontAwesomeIcons.fileCode;
      case AppIcon.codeBranch:
        return FontAwesomeIcons.codeBranch;
      case AppIcon.codeMerge:
        return FontAwesomeIcons.codeMerge;
      case AppIcon.codeCompare:
        return FontAwesomeIcons.codeCompare;

      // الرياضيات والإحصائيات - Mathematics & Statistics
      case AppIcon.calculator:
        return FontAwesomeIcons.calculator;
      case AppIcon.squareRootAlt:
        return FontAwesomeIcons.squareRootVariable;
      case AppIcon.infinity:
        return FontAwesomeIcons.infinity;
      case AppIcon.percentage:
        return FontAwesomeIcons.percent;
      case AppIcon.chartLine:
        return FontAwesomeIcons.chartLine;
      case AppIcon.chartPie:
        return FontAwesomeIcons.chartPie;
      case AppIcon.chartArea:
        return FontAwesomeIcons.chartArea;
      case AppIcon.sortNumericUp:
        return FontAwesomeIcons.arrowDownWideShort;
      case AppIcon.sortNumericDown:
        return FontAwesomeIcons.arrowUpShortWide;
      case AppIcon.equals:
        return FontAwesomeIcons.equals;
      case AppIcon.plus:
        return FontAwesomeIcons.plus;
      case AppIcon.minus:
        return FontAwesomeIcons.minus;
      case AppIcon.times:
        return FontAwesomeIcons.xmark;
      case AppIcon.divide:
        return FontAwesomeIcons.divide;
      case AppIcon.superscript:
        return FontAwesomeIcons.superscript;
      case AppIcon.subscript:
        return FontAwesomeIcons.subscript;
      case AppIcon.sigma:
        return FontAwesomeIcons.s; // fallback
      case AppIcon.pi:
        return FontAwesomeIcons.p; // fallback
      case AppIcon.function:
        return FontAwesomeIcons.f; // fallback
      case AppIcon.integral:
        return FontAwesomeIcons.i; // fallback
      case AppIcon.triangle:
        return FontAwesomeIcons.triangleExclamation; // fallback
      case AppIcon.omega:
        return FontAwesomeIcons.o; // fallback
      case AppIcon.theta:
        return FontAwesomeIcons.circle; // fallback

      // العلوم والكيمياء - Science & Chemistry
      case AppIcon.atom:
        return FontAwesomeIcons.atom;
      case AppIcon.flask:
        return FontAwesomeIcons.flask;
      case AppIcon.microscope:
        return FontAwesomeIcons.microscope;
      case AppIcon.dna:
        return FontAwesomeIcons.dna;
      case AppIcon.leaf:
        return FontAwesomeIcons.leaf;
      case AppIcon.seedling:
        return FontAwesomeIcons.seedling;
      case AppIcon.droplet:
        return FontAwesomeIcons.droplet;
      case AppIcon.fire:
        return FontAwesomeIcons.fire;
      case AppIcon.bolt:
        return FontAwesomeIcons.bolt;
      case AppIcon.magnet:
        return FontAwesomeIcons.magnet;
      case AppIcon.satellite:
        return FontAwesomeIcons.satellite;
      case AppIcon.rocket:
        return FontAwesomeIcons.rocket;
      case AppIcon.sun:
        return FontAwesomeIcons.sun;
      case AppIcon.moon:
        return FontAwesomeIcons.moon;
      case AppIcon.star:
        return FontAwesomeIcons.star;
      case AppIcon.telescope:
        return FontAwesomeIcons.binoculars; // fallback
      case AppIcon.vial:
        return FontAwesomeIcons.vial;
      case AppIcon.pills:
        return FontAwesomeIcons.pills;
      case AppIcon.stethoscope:
        return FontAwesomeIcons.stethoscope;
      case AppIcon.heartbeat:
        return FontAwesomeIcons.heartPulse;
      case AppIcon.eye:
        return FontAwesomeIcons.eye;
      case AppIcon.ear:
        return FontAwesomeIcons.earListen;
      case AppIcon.nose:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.tooth:
        return FontAwesomeIcons.tooth;
      case AppIcon.bone:
        return FontAwesomeIcons.bone;
      case AppIcon.lungs:
        return FontAwesomeIcons.lungs;
      case AppIcon.liver:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.kidney:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.stomach:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.intestines:
        return FontAwesomeIcons.question; // fallback

      // الدراسة والأكاديمية - Study & Academic
      case AppIcon.graduationCap:
        return FontAwesomeIcons.graduationCap;
      case AppIcon.book:
        return FontAwesomeIcons.book;
      case AppIcon.bookOpen:
        return FontAwesomeIcons.bookOpen;
      case AppIcon.pen:
        return FontAwesomeIcons.pen;
      case AppIcon.pencilAlt:
        return FontAwesomeIcons.pencil;
      case AppIcon.highlighter:
        return FontAwesomeIcons.highlighter;
      case AppIcon.stickyNote:
        return FontAwesomeIcons.noteSticky;
      case AppIcon.clipboard:
        return FontAwesomeIcons.clipboard;
      case AppIcon.fileAlt:
        return FontAwesomeIcons.fileLines;
      case AppIcon.folder:
        return FontAwesomeIcons.folder;
      case AppIcon.archive:
        return FontAwesomeIcons.boxArchive;
      case AppIcon.calendarAlt:
        return FontAwesomeIcons.calendar;
      case AppIcon.clock:
        return FontAwesomeIcons.clock;
      case AppIcon.stopwatch:
        return FontAwesomeIcons.stopwatch;
      case AppIcon.hourglassHalf:
        return FontAwesomeIcons.hourglassHalf;
      case AppIcon.bell:
        return FontAwesomeIcons.bell;
      case AppIcon.flag:
        return FontAwesomeIcons.flag;
      case AppIcon.trophy:
        return FontAwesomeIcons.trophy;
      case AppIcon.medal:
        return FontAwesomeIcons.medal;
      case AppIcon.certificate:
        return FontAwesomeIcons.certificate;
      case AppIcon.award:
        return FontAwesomeIcons.award;
      case AppIcon.userGraduate:
        return FontAwesomeIcons.userGraduate;
      case AppIcon.chalkboardTeacher:
        return FontAwesomeIcons.chalkboardUser;
      case AppIcon.chalkboard:
        return FontAwesomeIcons.chalkboard;
      case AppIcon.search:
        return FontAwesomeIcons.magnifyingGlass;
      case AppIcon.questionCircle:
        return FontAwesomeIcons.circleQuestion;
      case AppIcon.lightbulb:
        return FontAwesomeIcons.lightbulb;

      // الإبداع والتصميم - Creativity & Design
      case AppIcon.palette:
        return FontAwesomeIcons.palette;
      case AppIcon.paintBrush:
        return FontAwesomeIcons.paintbrush;
      case AppIcon.magic:
        return FontAwesomeIcons.wandMagic;
      case AppIcon.sparkles:
        return FontAwesomeIcons.wandMagicSparkles;
      case AppIcon.eyeDropper:
        return FontAwesomeIcons.eyeDropper;
      case AppIcon.camera:
        return FontAwesomeIcons.camera;
      case AppIcon.video:
        return FontAwesomeIcons.video;
      case AppIcon.music:
        return FontAwesomeIcons.music;
      case AppIcon.headphones:
        return FontAwesomeIcons.headphones;
      case AppIcon.gamepad:
        return FontAwesomeIcons.gamepad;
      case AppIcon.dice:
        return FontAwesomeIcons.dice;
      case AppIcon.puzzlePiece:
        return FontAwesomeIcons.puzzlePiece;
      case AppIcon.cube:
        return FontAwesomeIcons.cube;
      case AppIcon.gem:
        return FontAwesomeIcons.gem;
      case AppIcon.crown:
        return FontAwesomeIcons.crown;
      case AppIcon.ribbon:
        return FontAwesomeIcons.ribbon;

      // العمل الجماعي والتواصل - Collaboration & Communication
      case AppIcon.users:
        return FontAwesomeIcons.users;
      case AppIcon.userFriends:
        return FontAwesomeIcons.userGroup;
      case AppIcon.handshake:
        return FontAwesomeIcons.handshake;
      case AppIcon.comments:
        return FontAwesomeIcons.comments;
      case AppIcon.commentDots:
        return FontAwesomeIcons.commentDots;
      case AppIcon.envelope:
        return FontAwesomeIcons.envelope;
      case AppIcon.phone:
        return FontAwesomeIcons.phone;
      case AppIcon.videoCamera:
        return FontAwesomeIcons.videoCamera;
      case AppIcon.shareAlt:
        return FontAwesomeIcons.shareNodes;
      case AppIcon.link:
        return FontAwesomeIcons.link;
      case AppIcon.sync:
        return FontAwesomeIcons.arrowsRotate;
      case AppIcon.download:
        return FontAwesomeIcons.download;
      case AppIcon.upload:
        return FontAwesomeIcons.upload;
      case AppIcon.print:
        return FontAwesomeIcons.print;
      case AppIcon.copy:
        return FontAwesomeIcons.copy;
      case AppIcon.paperPlane:
        return FontAwesomeIcons.paperPlane;
      case AppIcon.inbox:
        return FontAwesomeIcons.inbox;
      case AppIcon.send:
        return FontAwesomeIcons.paperPlane;
      case AppIcon.bellSlash:
        return FontAwesomeIcons.bellSlash;

      // Navigation & Common Actions
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
      case AppIcon.filter:
        return FontAwesomeIcons.filter;
      case AppIcon.sort:
        return FontAwesomeIcons.arrowsUpDown;
      case AppIcon.refresh:
        return FontAwesomeIcons.arrowsRotate;

      // Chat & Communication
      case AppIcon.chat:
        return FontAwesomeIcons.comment;
      case AppIcon.attach:
        return FontAwesomeIcons.paperclip;
      case AppIcon.image:
        return FontAwesomeIcons.image;
      case AppIcon.file:
        return FontAwesomeIcons.file;
      case AppIcon.message:
        return FontAwesomeIcons.message;
      case AppIcon.reply:
        return FontAwesomeIcons.reply;
      case AppIcon.share:
        return FontAwesomeIcons.share;
      case AppIcon.paperclip:
        return FontAwesomeIcons.paperclip;

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
      case AppIcon.save:
        return FontAwesomeIcons.floppyDisk;

      // Organization
      case AppIcon.folderPlus:
        return FontAwesomeIcons.folderPlus;
      case AppIcon.folderOpen:
        return FontAwesomeIcons.folderOpen;
      case AppIcon.heart:
        return FontAwesomeIcons.heart;
      case AppIcon.thumbtack:
        return FontAwesomeIcons.thumbtack;

      // Settings & Configuration
      case AppIcon.settings:
        return FontAwesomeIcons.gear;
      case AppIcon.cog:
        return FontAwesomeIcons.gear;
      case AppIcon.shield:
        return FontAwesomeIcons.shield;
      case AppIcon.info:
        return FontAwesomeIcons.info;

      // Help & Support
      case AppIcon.help:
        return FontAwesomeIcons.circleQuestion;
      case AppIcon.question:
        return FontAwesomeIcons.question;

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
      case AppIcon.exclamationTriangle:
        return FontAwesomeIcons.triangleExclamation;

      // UI Elements
      case AppIcon.ellipsis:
        return FontAwesomeIcons.ellipsis;
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
      case AppIcon.upRightAndDownLeftFromCenter:
        return FontAwesomeIcons.upRightAndDownLeftFromCenter;
      case AppIcon.downLeftAndUpRightToCenter:
        return FontAwesomeIcons.downLeftAndUpRightToCenter;

      // Specific Features
      case AppIcon.history:
        return FontAwesomeIcons.clockRotateLeft;
      case AppIcon.lockKeyhole:
        return FontAwesomeIcons.lock;
      case AppIcon.unlock:
        return FontAwesomeIcons.unlock;
      case AppIcon.microphone:
        return FontAwesomeIcons.microphone;
      case AppIcon.fileCodeIcon:
        return FontAwesomeIcons.fileCode;

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
      case AppIcon.film:
        return FontAwesomeIcons.film;
      case AppIcon.fileText:
        return FontAwesomeIcons.fileLines;

      // File Types
      case AppIcon.fileLines:
        return FontAwesomeIcons.fileLines;

      // Arrows & Direction
      case AppIcon.arrowLeft:
        return FontAwesomeIcons.arrowLeft;
      case AppIcon.arrowRight:
        return FontAwesomeIcons.arrowRight;
      case AppIcon.arrowUp:
        return FontAwesomeIcons.arrowUp;
      case AppIcon.arrowDown:
        return FontAwesomeIcons.arrowDown;
      case AppIcon.arrowTurnUpLeft:
        return FontAwesomeIcons.arrowTurnUp;
      case AppIcon.arrowTurnUpRight:
        return FontAwesomeIcons.arrowTurnUp;
      case AppIcon.arrowTurnDownLeft:
        return FontAwesomeIcons.arrowTurnDown;
      case AppIcon.arrowTurnDownRight:
        return FontAwesomeIcons.arrowTurnDown;

      // Common UI
      case AppIcon.xmark:
        return FontAwesomeIcons.xmark;
      case AppIcon.checkCircle:
        return FontAwesomeIcons.circleCheck;
      case AppIcon.timesCircle:
        return FontAwesomeIcons.circleXmark;
      case AppIcon.infoCircleIcon:
        return FontAwesomeIcons.circleInfo;
      case AppIcon.exclamationCircle:
        return FontAwesomeIcons.circleExclamation;
    }
  }

  /// Get icon size based on the token size
  static double getIconSize(double tokenSize) {
    return tokenSize;
  }

  /// Get default icon size
  static double get defaultIconSize => AppTokens.iconSizeM;

  /// Convert FontAwesome class string to AppIcon enum
  /// Supports web format like "fa-duotone fa-light fa-palette"
  static AppIcon? fromFontAwesomeClass(String fontAwesomeClass) {
    // Extract the main icon class from web format
    final cleanClass = fontAwesomeClass.split(' ').last.replaceAll('fa-', '');

    return _fontAwesomeToAppIconMap[cleanClass];
  }

  /// Convert AppIcon enum to FontAwesome class string for web
  /// Returns format like "fa-duotone fa-light fa-palette"
  static String toFontAwesomeClass(
    AppIcon appIcon, {
    String style = 'fas', // fas, far, fab, fa-duotone, etc.
    String? weight, // light, regular, solid, etc.
  }) {
    final iconClass = _appIconToFontAwesomeMap[appIcon] ?? 'question';
    final weightPrefix = weight != null ? ' fa-$weight' : '';
    return '$style$weightPrefix fa-$iconClass';
  }

  /// Get all available icons for folder selection
  static Map<AppIcon, String> getFolderIcons() {
    return {
      AppIcon.folder: 'مجلد عادي',
      AppIcon.code: 'برمجة',
      AppIcon.database: 'قاعدة بيانات',
      AppIcon.brain: 'خوارزميات',
      AppIcon.sitemap: 'هياكل بيانات',
      AppIcon.graduationCap: 'أكاديمي',
      AppIcon.book: 'دراسة',
      AppIcon.lightbulb: 'أفكار',
      AppIcon.star: 'مهم',
      AppIcon.heart: 'مفضل',
      AppIcon.fire: 'عاجل',
      AppIcon.rocket: 'مشاريع',
      AppIcon.palette: 'تصميم',
      AppIcon.chartLine: 'إحصائيات',
      AppIcon.users: 'فريق',
      AppIcon.calculator: 'رياضيات',
      AppIcon.flask: 'تجارب',
      AppIcon.pencilAlt: 'كتابة',
      AppIcon.search: 'بحث',
      AppIcon.clock: 'مواعيد',
    };
  }
}

/// Mapping from FontAwesome class names to AppIcon enums
const Map<String, AppIcon> _fontAwesomeToAppIconMap = {
  // Programming & Technology
  'code': AppIcon.code,
  'laptop-code': AppIcon.laptopCode,
  'terminal': AppIcon.terminal,
  'bug': AppIcon.bug,
  'cogs': AppIcon.cogs,
  'gears': AppIcon.cogs,
  'microchip': AppIcon.microchip,
  'server': AppIcon.server,
  'network-wired': AppIcon.networkWired,
  'shield-alt': AppIcon.shieldAlt,
  'shield-halved': AppIcon.shieldAlt,
  'key': AppIcon.key,
  'database': AppIcon.database,
  'table': AppIcon.table,
  'chart-bar': AppIcon.chartBar,
  'mobile-alt': AppIcon.mobileAlt,
  'mobile-screen': AppIcon.mobileAlt,
  'globe': AppIcon.globe,
  'cloud': AppIcon.cloud,
  'robot': AppIcon.robot,
  'brain': AppIcon.brain,
  'sitemap': AppIcon.sitemap,
  'project-diagram': AppIcon.projectDiagram,
  'diagram-project': AppIcon.projectDiagram,
  'file-code': AppIcon.fileCode,
  'code-branch': AppIcon.codeBranch,
  'code-merge': AppIcon.codeMerge,
  'code-compare': AppIcon.codeCompare,

  // Mathematics & Statistics
  'calculator': AppIcon.calculator,
  'square-root-alt': AppIcon.squareRootAlt,
  'square-root-variable': AppIcon.squareRootAlt,
  'infinity': AppIcon.infinity,
  'percentage': AppIcon.percentage,
  'percent': AppIcon.percentage,
  'chart-line': AppIcon.chartLine,
  'chart-pie': AppIcon.chartPie,
  'chart-area': AppIcon.chartArea,
  'sort-numeric-up': AppIcon.sortNumericUp,
  'sort-numeric-down': AppIcon.sortNumericDown,
  'equals': AppIcon.equals,
  'plus': AppIcon.plus,
  'minus': AppIcon.minus,
  'times': AppIcon.times,
  'xmark': AppIcon.times,
  'divide': AppIcon.divide,
  'superscript': AppIcon.superscript,
  'subscript': AppIcon.subscript,
  'sigma': AppIcon.sigma,
  'pi': AppIcon.pi,
  'function': AppIcon.function,
  'integral': AppIcon.integral,
  'triangle': AppIcon.triangle,
  'omega': AppIcon.omega,
  'theta': AppIcon.theta,

  // Science & Chemistry
  'atom': AppIcon.atom,
  'flask': AppIcon.flask,
  'microscope': AppIcon.microscope,
  'dna': AppIcon.dna,
  'leaf': AppIcon.leaf,
  'seedling': AppIcon.seedling,
  'droplet': AppIcon.droplet,
  'fire': AppIcon.fire,
  'bolt': AppIcon.bolt,
  'magnet': AppIcon.magnet,
  'satellite': AppIcon.satellite,
  'rocket': AppIcon.rocket,
  'sun': AppIcon.sun,
  'moon': AppIcon.moon,
  'star': AppIcon.star,
  'telescope': AppIcon.telescope,
  'vial': AppIcon.vial,
  'pills': AppIcon.pills,
  'stethoscope': AppIcon.stethoscope,
  'heartbeat': AppIcon.heartbeat,
  'heart-pulse': AppIcon.heartbeat,
  'eye': AppIcon.eye,
  'ear': AppIcon.ear,
  'ear-listen': AppIcon.ear,
  'nose': AppIcon.nose,
  'tooth': AppIcon.tooth,
  'bone': AppIcon.bone,
  'lungs': AppIcon.lungs,
  'liver': AppIcon.liver,
  'kidneys': AppIcon.kidney,
  'stomach': AppIcon.stomach,
  'intestines': AppIcon.intestines,

  // Study & Academic
  'graduation-cap': AppIcon.graduationCap,
  'book': AppIcon.book,
  'book-open': AppIcon.bookOpen,
  'pen': AppIcon.pen,
  'pencil-alt': AppIcon.pencilAlt,
  'pencil': AppIcon.pencilAlt,
  'highlighter': AppIcon.highlighter,
  'sticky-note': AppIcon.stickyNote,
  'note-sticky': AppIcon.stickyNote,
  'clipboard': AppIcon.clipboard,
  'file-alt': AppIcon.fileAlt,
  'file-lines': AppIcon.fileAlt,
  'folder': AppIcon.folder,
  'archive': AppIcon.archive,
  'box-archive': AppIcon.archive,
  'calendar-alt': AppIcon.calendarAlt,
  'calendar': AppIcon.calendarAlt,
  'clock': AppIcon.clock,
  'stopwatch': AppIcon.stopwatch,
  'hourglass-half': AppIcon.hourglassHalf,
  'bell': AppIcon.bell,
  'flag': AppIcon.flag,
  'trophy': AppIcon.trophy,
  'medal': AppIcon.medal,
  'certificate': AppIcon.certificate,
  'award': AppIcon.award,
  'user-graduate': AppIcon.userGraduate,
  'chalkboard-teacher': AppIcon.chalkboardTeacher,
  'chalkboard-user': AppIcon.chalkboardTeacher,
  'chalkboard': AppIcon.chalkboard,
  'magnifying-glass': AppIcon.search,
  'search': AppIcon.search,
  'question-circle': AppIcon.questionCircle,
  'circle-question': AppIcon.questionCircle,
  'lightbulb': AppIcon.lightbulb,

  // Creativity & Design
  'palette': AppIcon.palette,
  'paint-brush': AppIcon.paintBrush,
  'paintbrush': AppIcon.paintBrush,
  'magic': AppIcon.magic,
  'wand-magic': AppIcon.magic,
  'sparkles': AppIcon.sparkles,
  'wand-magic-sparkles': AppIcon.sparkles,
  'eye-dropper': AppIcon.eyeDropper,
  'camera': AppIcon.camera,
  'video': AppIcon.video,
  'music': AppIcon.music,
  'headphones': AppIcon.headphones,
  'gamepad': AppIcon.gamepad,
  'dice': AppIcon.dice,
  'puzzle-piece': AppIcon.puzzlePiece,
  'cube': AppIcon.cube,
  'gem': AppIcon.gem,
  'crown': AppIcon.crown,
  'ribbon': AppIcon.ribbon,

  // Collaboration & Communication
  'users': AppIcon.users,
  'user-friends': AppIcon.userFriends,
  'user-group': AppIcon.userFriends,
  'handshake': AppIcon.handshake,
  'comments': AppIcon.comments,
  'comment-dots': AppIcon.commentDots,
  'envelope': AppIcon.envelope,
  'phone': AppIcon.phone,
  'video-camera': AppIcon.videoCamera,
  'share-alt': AppIcon.shareAlt,
  'share-nodes': AppIcon.shareAlt,
  'link': AppIcon.link,
  'sync': AppIcon.sync,
  'arrows-rotate': AppIcon.sync,
  'download': AppIcon.download,
  'upload': AppIcon.upload,
  'print': AppIcon.print,
  'copy': AppIcon.copy,
  'paper-plane': AppIcon.paperPlane,
  'inbox': AppIcon.inbox,
  'send': AppIcon.send,
  'bell-slash': AppIcon.bellSlash,

  // Navigation & Common Actions
  'house': AppIcon.home,
  'home': AppIcon.home,
  'arrow-left': AppIcon.back,
  'arrow-right': AppIcon.next,
  'bars': AppIcon.menu,
  'filter': AppIcon.filter,
  'arrows-up-down': AppIcon.sort,
  'refresh': AppIcon.refresh,

  // Chat & Communication
  'comment': AppIcon.chat,
  'paperclip': AppIcon.attach,
  'image': AppIcon.image,
  'file': AppIcon.file,
  'message': AppIcon.message,
  'reply': AppIcon.reply,
  'share': AppIcon.share,

  // User & Auth
  'user': AppIcon.user,
  'lock': AppIcon.lock,
  'right-to-bracket': AppIcon.signIn,
  'sign-in': AppIcon.signIn,
  'right-from-bracket': AppIcon.signOut,
  'sign-out': AppIcon.signOut,

  // Content Management
  'edit': AppIcon.edit,
  'trash': AppIcon.delete,
  'floppy-disk': AppIcon.save,
  'save': AppIcon.save,

  // Organization
  'folder-plus': AppIcon.folderPlus,
  'folder-open': AppIcon.folderOpen,
  'heart': AppIcon.heart,
  'thumbtack': AppIcon.thumbtack,

  // Settings & Configuration
  'gear': AppIcon.settings,
  'settings': AppIcon.settings,
  'cog': AppIcon.cog,
  'shield': AppIcon.shield,
  'info': AppIcon.info,

  // Help & Support
  'help': AppIcon.help,
  'question': AppIcon.question,

  // Status & Feedback
  'check': AppIcon.check,
  'triangle-exclamation': AppIcon.warning,
  'warning': AppIcon.warning,
  'circle-exclamation': AppIcon.error,
  'error': AppIcon.error,
  'circle-info': AppIcon.infoCircle,
  'info-circle': AppIcon.infoCircle,
  'exclamation': AppIcon.exclamation,

  // UI Elements
  'ellipsis': AppIcon.ellipsis,
  'ellipsis-vertical': AppIcon.ellipsisV,
  'chevron-up': AppIcon.chevronUp,
  'chevron-down': AppIcon.chevronDown,
  'chevron-left': AppIcon.chevronLeft,
  'chevron-right': AppIcon.chevronRight,
  'angle-up': AppIcon.angleUp,
  'angle-down': AppIcon.angleDown,
  'angle-left': AppIcon.angleLeft,
  'angle-right': AppIcon.angleRight,
  'angles-up': AppIcon.anglesUp,
  'angles-down': AppIcon.anglesDown,

  // Specific Features
  'clock-rotate-left': AppIcon.history,
  'history': AppIcon.history,
  'unlock': AppIcon.unlock,
  'microphone': AppIcon.microphone,

  // Display & Layout
  'list': AppIcon.list,
  'table-cells': AppIcon.grid,
  'grid': AppIcon.grid,
  'table-cells-large': AppIcon.thLarge,

  // Media
  'play': AppIcon.play,
  'pause': AppIcon.pause,
  'stop': AppIcon.stop,
  'film': AppIcon.film,

  // Arrows & Direction
  'arrow-up': AppIcon.arrowUp,
  'arrow-down': AppIcon.arrowDown,
};

/// Mapping from AppIcon enums to FontAwesome class names
const Map<AppIcon, String> _appIconToFontAwesomeMap = {
  // Programming & Technology
  AppIcon.code: 'code',
  AppIcon.laptopCode: 'laptop-code',
  AppIcon.terminal: 'terminal',
  AppIcon.bug: 'bug',
  AppIcon.cogs: 'gears',
  AppIcon.microchip: 'microchip',
  AppIcon.server: 'server',
  AppIcon.networkWired: 'network-wired',
  AppIcon.shieldAlt: 'shield-halved',
  AppIcon.key: 'key',
  AppIcon.database: 'database',
  AppIcon.table: 'table',
  AppIcon.chartBar: 'chart-bar',
  AppIcon.mobileAlt: 'mobile-screen',
  AppIcon.globe: 'globe',
  AppIcon.cloud: 'cloud',
  AppIcon.robot: 'robot',
  AppIcon.brain: 'brain',
  AppIcon.sitemap: 'sitemap',
  AppIcon.projectDiagram: 'diagram-project',
  AppIcon.fileCode: 'file-code',
  AppIcon.codeBranch: 'code-branch',
  AppIcon.codeMerge: 'code-merge',
  AppIcon.codeCompare: 'code-compare',

  // Mathematics & Statistics
  AppIcon.calculator: 'calculator',
  AppIcon.squareRootAlt: 'square-root-variable',
  AppIcon.infinity: 'infinity',
  AppIcon.percentage: 'percent',
  AppIcon.chartLine: 'chart-line',
  AppIcon.chartPie: 'chart-pie',
  AppIcon.chartArea: 'chart-area',
  AppIcon.sortNumericUp: 'sort-numeric-up',
  AppIcon.sortNumericDown: 'sort-numeric-down',
  AppIcon.equals: 'equals',
  AppIcon.plus: 'plus',
  AppIcon.minus: 'minus',
  AppIcon.times: 'xmark',
  AppIcon.divide: 'divide',
  AppIcon.superscript: 'superscript',
  AppIcon.subscript: 'subscript',
  AppIcon.sigma: 'sigma',
  AppIcon.pi: 'pi',
  AppIcon.function: 'function',
  AppIcon.integral: 'integral',
  AppIcon.triangle: 'triangle',
  AppIcon.omega: 'omega',
  AppIcon.theta: 'theta',

  // Science & Chemistry
  AppIcon.atom: 'atom',
  AppIcon.flask: 'flask',
  AppIcon.microscope: 'microscope',
  AppIcon.dna: 'dna',
  AppIcon.leaf: 'leaf',
  AppIcon.seedling: 'seedling',
  AppIcon.droplet: 'droplet',
  AppIcon.fire: 'fire',
  AppIcon.bolt: 'bolt',
  AppIcon.magnet: 'magnet',
  AppIcon.satellite: 'satellite',
  AppIcon.rocket: 'rocket',
  AppIcon.sun: 'sun',
  AppIcon.moon: 'moon',
  AppIcon.star: 'star',
  AppIcon.telescope: 'telescope',
  AppIcon.vial: 'vial',
  AppIcon.pills: 'pills',
  AppIcon.stethoscope: 'stethoscope',
  AppIcon.heartbeat: 'heart-pulse',
  AppIcon.eye: 'eye',
  AppIcon.ear: 'ear-listen',
  AppIcon.nose: 'nose',
  AppIcon.tooth: 'tooth',
  AppIcon.bone: 'bone',
  AppIcon.lungs: 'lungs',
  AppIcon.liver: 'liver',
  AppIcon.kidney: 'kidneys',
  AppIcon.stomach: 'stomach',
  AppIcon.intestines: 'intestines',

  // Study & Academic
  AppIcon.graduationCap: 'graduation-cap',
  AppIcon.book: 'book',
  AppIcon.bookOpen: 'book-open',
  AppIcon.pen: 'pen',
  AppIcon.pencilAlt: 'pencil',
  AppIcon.highlighter: 'highlighter',
  AppIcon.stickyNote: 'note-sticky',
  AppIcon.clipboard: 'clipboard',
  AppIcon.fileAlt: 'file-lines',
  AppIcon.folder: 'folder',
  AppIcon.archive: 'box-archive',
  AppIcon.calendarAlt: 'calendar',
  AppIcon.clock: 'clock',
  AppIcon.stopwatch: 'stopwatch',
  AppIcon.hourglassHalf: 'hourglass-half',
  AppIcon.bell: 'bell',
  AppIcon.flag: 'flag',
  AppIcon.trophy: 'trophy',
  AppIcon.medal: 'medal',
  AppIcon.certificate: 'certificate',
  AppIcon.award: 'award',
  AppIcon.userGraduate: 'user-graduate',
  AppIcon.chalkboardTeacher: 'chalkboard-user',
  AppIcon.chalkboard: 'chalkboard',
  AppIcon.search: 'magnifying-glass',
  AppIcon.questionCircle: 'circle-question',
  AppIcon.lightbulb: 'lightbulb',

  // Creativity & Design
  AppIcon.palette: 'palette',
  AppIcon.paintBrush: 'paintbrush',
  AppIcon.magic: 'wand-magic',
  AppIcon.sparkles: 'wand-magic-sparkles',
  AppIcon.eyeDropper: 'eye-dropper',
  AppIcon.camera: 'camera',
  AppIcon.video: 'video',
  AppIcon.music: 'music',
  AppIcon.headphones: 'headphones',
  AppIcon.gamepad: 'gamepad',
  AppIcon.dice: 'dice',
  AppIcon.puzzlePiece: 'puzzle-piece',
  AppIcon.cube: 'cube',
  AppIcon.gem: 'gem',
  AppIcon.crown: 'crown',
  AppIcon.ribbon: 'ribbon',

  // Collaboration & Communication
  AppIcon.users: 'users',
  AppIcon.userFriends: 'user-group',
  AppIcon.handshake: 'handshake',
  AppIcon.comments: 'comments',
  AppIcon.commentDots: 'comment-dots',
  AppIcon.envelope: 'envelope',
  AppIcon.phone: 'phone',
  AppIcon.videoCamera: 'video-camera',
  AppIcon.shareAlt: 'share-nodes',
  AppIcon.link: 'link',
  AppIcon.sync: 'arrows-rotate',
  AppIcon.download: 'download',
  AppIcon.upload: 'upload',
  AppIcon.print: 'print',
  AppIcon.copy: 'copy',
  AppIcon.paperPlane: 'paper-plane',
  AppIcon.inbox: 'inbox',
  AppIcon.send: 'paper-plane',
  AppIcon.bellSlash: 'bell-slash',

  // Navigation & Common Actions
  AppIcon.home: 'house',
  AppIcon.back: 'arrow-left',
  AppIcon.next: 'arrow-right',
  AppIcon.previous: 'arrow-left',
  AppIcon.close: 'xmark',
  AppIcon.menu: 'bars',
  AppIcon.filter: 'filter',
  AppIcon.sort: 'arrows-up-down',
  AppIcon.refresh: 'arrows-rotate',

  // Chat & Communication
  AppIcon.chat: 'comment',
  AppIcon.attach: 'paperclip',
  AppIcon.image: 'image',
  AppIcon.file: 'file',
  AppIcon.message: 'message',
  AppIcon.reply: 'reply',
  AppIcon.share: 'share',
  AppIcon.paperclip: 'paperclip',

  // User & Auth
  AppIcon.user: 'user',
  AppIcon.lock: 'lock',
  AppIcon.signIn: 'right-to-bracket',
  AppIcon.signOut: 'right-from-bracket',

  // Content Management
  AppIcon.edit: 'pen',
  AppIcon.delete: 'trash',
  AppIcon.trash: 'trash',
  AppIcon.save: 'floppy-disk',

  // Organization
  AppIcon.folderPlus: 'folder-plus',
  AppIcon.folderOpen: 'folder-open',
  AppIcon.heart: 'heart',
  AppIcon.thumbtack: 'thumbtack',

  // Settings & Configuration
  AppIcon.settings: 'gear',
  AppIcon.cog: 'gear',
  AppIcon.shield: 'shield',
  AppIcon.info: 'info',

  // Help & Support
  AppIcon.help: 'circle-question',
  AppIcon.question: 'question',

  // Status & Feedback
  AppIcon.check: 'check',
  AppIcon.warning: 'triangle-exclamation',
  AppIcon.error: 'circle-exclamation',
  AppIcon.infoCircle: 'circle-info',
  AppIcon.exclamation: 'exclamation',
  AppIcon.exclamationTriangle: 'triangle-exclamation',

  // UI Elements
  AppIcon.ellipsis: 'ellipsis',
  AppIcon.ellipsisH: 'ellipsis',
  AppIcon.ellipsisV: 'ellipsis-vertical',
  AppIcon.chevronUp: 'chevron-up',
  AppIcon.chevronDown: 'chevron-down',
  AppIcon.chevronLeft: 'chevron-left',
  AppIcon.chevronRight: 'chevron-right',
  AppIcon.angleUp: 'angle-up',
  AppIcon.angleDown: 'angle-down',
  AppIcon.angleLeft: 'angle-left',
  AppIcon.angleRight: 'angle-right',
  AppIcon.anglesUp: 'angles-up',
  AppIcon.anglesDown: 'angles-down',

  // Specific Features
  AppIcon.history: 'clock-rotate-left',
  AppIcon.lockKeyhole: 'lock',
  AppIcon.unlock: 'unlock',
  AppIcon.microphone: 'microphone',
  AppIcon.fileCodeIcon: 'file-code',

  // Display & Layout
  AppIcon.list: 'list',
  AppIcon.grid: 'table-cells',
  AppIcon.thLarge: 'table-cells-large',
  AppIcon.bars: 'bars',

  // Media
  AppIcon.play: 'play',
  AppIcon.pause: 'pause',
  AppIcon.stop: 'stop',
  AppIcon.film: 'film',
  AppIcon.fileText: 'file-lines',

  // File Types
  AppIcon.fileLines: 'file-lines',

  // Arrows & Direction
  AppIcon.arrowLeft: 'arrow-left',
  AppIcon.arrowRight: 'arrow-right',
  AppIcon.arrowUp: 'arrow-up',
  AppIcon.arrowDown: 'arrow-down',
  AppIcon.arrowTurnUpLeft: 'arrow-turn-up',
  AppIcon.arrowTurnUpRight: 'arrow-turn-up',
  AppIcon.arrowTurnDownLeft: 'arrow-turn-down',
  AppIcon.arrowTurnDownRight: 'arrow-turn-down',

  // Common UI
  AppIcon.xmark: 'xmark',
  AppIcon.checkCircle: 'circle-check',
  AppIcon.timesCircle: 'circle-xmark',
  AppIcon.infoCircleIcon: 'circle-info',
  AppIcon.exclamationCircle: 'circle-exclamation',
};
