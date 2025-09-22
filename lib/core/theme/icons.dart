import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'tokens.dart';

/// Icon mapping for FontAwesome icons used in the app
/// Based on the inventory from web_design files and folder.js
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
  message,
  reply,
  copy,
  share,
  link,
  paperclip,
  paperPlane,
  envelope,
  inbox,

  // User & Auth
  user,
  lock,
  signIn,
  signOut,
  robot,

  // Content Management
  edit,
  delete,
  trash,
  archive,
  download,
  upload,
  save,
  clipboard,

  // Organization
  folder,
  folderPlus,
  plus,
  minus,
  star,
  heart,
  fire,
  rocket,
  thumbtack,

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

  // Specific Features
  graduationCap,
  code,
  sitemap,
  brain,
  history,
  lockKeyhole,
  terminal,
  bug,
  cogs,
  microchip,
  laptopCode,
  fileCodeIcon,
  server,
  networkWired,
  key,
  unlock,

  // Display & Layout
  list,
  grid,
  thLarge,
  bars,

  // Media
  play,
  pause,
  stop,
  music,
  video,
  fileText,
  camera,
  film,

  // Mathematics & Science
  calculator,
  mathPlus,
  mathMinus,
  times,
  divide,
  equals,
  percentage,
  infinity,
  pi,
  sigma,
  function,
  chartLine,
  chartBar,
  chartPie,
  chartArea,
  sortNumericUp,
  sortNumericDown,
  sortAmountUp,
  sortAmountDown,
  squareRootAlt,
  flask,
  atom,
  dna,
  microscope,
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

  // Study & Education
  chalkboardTeacher,
  chalkboard,
  pencilAlt,
  pen,
  highlighter,
  stickyNote,
  folderOpen,

  // Creativity & Arts
  paintBrush,
  guitar,
  piano,
  theaterMasks,
  magic,
  gem,
  crown,
  trophy,
  medal,
  award,
  certificate,
  ribbon,
  flag,

  // Collaboration & Social
  users,
  userFriends,
  handshake,
  commentAlt,
  bellSlash,
  calendarAlt,
  clock,
  stopwatch,
  hourglassHalf,

  // External & Links
  external,
  externalLink,

  // File Types
  fileLines,
  fileAlt,
  fileCode,

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
  questionCircle,
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
      case AppIcon.message:
        return FontAwesomeIcons.message;
      case AppIcon.reply:
        return FontAwesomeIcons.reply;
      case AppIcon.copy:
        return FontAwesomeIcons.copy;
      case AppIcon.share:
        return FontAwesomeIcons.share;
      case AppIcon.link:
        return FontAwesomeIcons.link;
      case AppIcon.paperclip:
        return FontAwesomeIcons.paperclip;
      case AppIcon.paperPlane:
        return FontAwesomeIcons.paperPlane;
      case AppIcon.envelope:
        return FontAwesomeIcons.envelope;
      case AppIcon.inbox:
        return FontAwesomeIcons.inbox;

      // User & Auth
      case AppIcon.user:
        return FontAwesomeIcons.user;
      case AppIcon.lock:
        return FontAwesomeIcons.lock;
      case AppIcon.signIn:
        return FontAwesomeIcons.rightToBracket;
      case AppIcon.signOut:
        return FontAwesomeIcons.rightFromBracket;
      case AppIcon.robot:
        return FontAwesomeIcons.robot;

      // Content Management
      case AppIcon.edit:
        return FontAwesomeIcons.pen;
      case AppIcon.delete:
        return FontAwesomeIcons.trash;
      case AppIcon.trash:
        return FontAwesomeIcons.trash;
      case AppIcon.archive:
        return FontAwesomeIcons.boxArchive;
      case AppIcon.download:
        return FontAwesomeIcons.download;
      case AppIcon.upload:
        return FontAwesomeIcons.upload;
      case AppIcon.save:
        return FontAwesomeIcons.floppyDisk;
      case AppIcon.clipboard:
        return FontAwesomeIcons.clipboard;

      // Organization
      case AppIcon.folder:
        return FontAwesomeIcons.folder;
      case AppIcon.folderPlus:
        return FontAwesomeIcons.folderPlus;
      case AppIcon.plus:
        return FontAwesomeIcons.plus;
      case AppIcon.minus:
        return FontAwesomeIcons.minus;
      case AppIcon.star:
        return FontAwesomeIcons.star;
      case AppIcon.heart:
        return FontAwesomeIcons.heart;
      case AppIcon.fire:
        return FontAwesomeIcons.fire;
      case AppIcon.rocket:
        return FontAwesomeIcons.rocket;
      case AppIcon.thumbtack:
        return FontAwesomeIcons.thumbtack;

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

      // Specific Features
      case AppIcon.graduationCap:
        return FontAwesomeIcons.graduationCap;
      case AppIcon.code:
        return FontAwesomeIcons.code;
      case AppIcon.sitemap:
        return FontAwesomeIcons.sitemap;
      case AppIcon.brain:
        return FontAwesomeIcons.brain;
      case AppIcon.history:
        return FontAwesomeIcons.clockRotateLeft;
      case AppIcon.lockKeyhole:
        return FontAwesomeIcons.lock;
      case AppIcon.terminal:
        return FontAwesomeIcons.terminal;
      case AppIcon.bug:
        return FontAwesomeIcons.bug;
      case AppIcon.cogs:
        return FontAwesomeIcons.gears;
      case AppIcon.microchip:
        return FontAwesomeIcons.microchip;
      case AppIcon.laptopCode:
        return FontAwesomeIcons.laptopCode;
      case AppIcon.fileCodeIcon:
        return FontAwesomeIcons.fileCode;
      case AppIcon.server:
        return FontAwesomeIcons.server;
      case AppIcon.networkWired:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.key:
        return FontAwesomeIcons.key;
      case AppIcon.unlock:
        return FontAwesomeIcons.unlock;

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
      case AppIcon.music:
        return FontAwesomeIcons.music;
      case AppIcon.video:
        return FontAwesomeIcons.video;
      case AppIcon.fileText:
        return FontAwesomeIcons.fileLines;
      case AppIcon.camera:
        return FontAwesomeIcons.camera;
      case AppIcon.film:
        return FontAwesomeIcons.film;

      // Mathematics & Science
      case AppIcon.calculator:
        return FontAwesomeIcons.calculator;
      case AppIcon.mathPlus:
        return FontAwesomeIcons.plus;
      case AppIcon.mathMinus:
        return FontAwesomeIcons.minus;
      case AppIcon.times:
        return FontAwesomeIcons.xmark;
      case AppIcon.divide:
        return FontAwesomeIcons.divide;
      case AppIcon.equals:
        return FontAwesomeIcons.equals;
      case AppIcon.percentage:
        return FontAwesomeIcons.percent;
      case AppIcon.infinity:
        return FontAwesomeIcons.infinity;
      case AppIcon.pi:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.sigma:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.function:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.chartLine:
        return FontAwesomeIcons.chartLine;
      case AppIcon.chartBar:
        return FontAwesomeIcons.chartBar;
      case AppIcon.chartPie:
        return FontAwesomeIcons.chartPie;
      case AppIcon.chartArea:
        return FontAwesomeIcons.chartArea;
      case AppIcon.sortNumericUp:
        return FontAwesomeIcons.sortNumericUp;
      case AppIcon.sortNumericDown:
        return FontAwesomeIcons.sortNumericDown;
      case AppIcon.sortAmountUp:
        return FontAwesomeIcons.sortAmountUp;
      case AppIcon.sortAmountDown:
        return FontAwesomeIcons.sortAmountDown;
      case AppIcon.squareRootAlt:
        return FontAwesomeIcons.squareRootVariable;
      case AppIcon.flask:
        return FontAwesomeIcons.flask;
      case AppIcon.atom:
        return FontAwesomeIcons.atom;
      case AppIcon.dna:
        return FontAwesomeIcons.dna;
      case AppIcon.microscope:
        return FontAwesomeIcons.microscope;
      case AppIcon.telescope:
        return FontAwesomeIcons.question; // fallback
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

      // Study & Education
      case AppIcon.chalkboardTeacher:
        return FontAwesomeIcons.chalkboardUser;
      case AppIcon.chalkboard:
        return FontAwesomeIcons.chalkboard;
      case AppIcon.pencilAlt:
        return FontAwesomeIcons.pencil;
      case AppIcon.pen:
        return FontAwesomeIcons.pen;
      case AppIcon.highlighter:
        return FontAwesomeIcons.highlighter;
      case AppIcon.stickyNote:
        return FontAwesomeIcons.noteSticky;
      case AppIcon.folderOpen:
        return FontAwesomeIcons.folderOpen;

      // Creativity & Arts
      case AppIcon.paintBrush:
        return FontAwesomeIcons.paintbrush;
      case AppIcon.guitar:
        return FontAwesomeIcons.guitar;
      case AppIcon.piano:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.theaterMasks:
        return FontAwesomeIcons.masksTheater;
      case AppIcon.magic:
        return FontAwesomeIcons.wandMagic;
      case AppIcon.gem:
        return FontAwesomeIcons.gem;
      case AppIcon.crown:
        return FontAwesomeIcons.crown;
      case AppIcon.trophy:
        return FontAwesomeIcons.trophy;
      case AppIcon.medal:
        return FontAwesomeIcons.medal;
      case AppIcon.award:
        return FontAwesomeIcons.award;
      case AppIcon.certificate:
        return FontAwesomeIcons.certificate;
      case AppIcon.ribbon:
        return FontAwesomeIcons.ribbon;
      case AppIcon.flag:
        return FontAwesomeIcons.flag;

      // Collaboration & Social
      case AppIcon.users:
        return FontAwesomeIcons.users;
      case AppIcon.userFriends:
        return FontAwesomeIcons.userFriends;
      case AppIcon.handshake:
        return FontAwesomeIcons.handshake;
      case AppIcon.commentAlt:
        return FontAwesomeIcons.comment;
      case AppIcon.bellSlash:
        return FontAwesomeIcons.bellSlash;
      case AppIcon.calendarAlt:
        return FontAwesomeIcons.calendar;
      case AppIcon.clock:
        return FontAwesomeIcons.clock;
      case AppIcon.stopwatch:
        return FontAwesomeIcons.stopwatch;
      case AppIcon.hourglassHalf:
        return FontAwesomeIcons.hourglassHalf;

      // External & Links
      case AppIcon.external:
        return FontAwesomeIcons.arrowUpRightFromSquare;
      case AppIcon.externalLink:
        return FontAwesomeIcons.arrowUpRightFromSquare;

      // File Types
      case AppIcon.fileLines:
        return FontAwesomeIcons.fileLines;
      case AppIcon.fileAlt:
        return FontAwesomeIcons.fileLines;
      case AppIcon.fileCode:
        return FontAwesomeIcons.fileCode;

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
        return FontAwesomeIcons.question; // fallback
      case AppIcon.arrowTurnUpRight:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.arrowTurnDownLeft:
        return FontAwesomeIcons.question; // fallback
      case AppIcon.arrowTurnDownRight:
        return FontAwesomeIcons.question; // fallback

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
      case AppIcon.questionCircle:
        return FontAwesomeIcons.circleQuestion;
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
  'house': AppIcon.home,
  'arrow-left': AppIcon.back,
  'arrow-right': AppIcon.next,
  'xmark': AppIcon.close,
  'bars': AppIcon.menu,
  'magnifying-glass': AppIcon.search,
  'filter': AppIcon.filter,
  'arrows-up-down': AppIcon.sort,
  'arrows-rotate': AppIcon.refresh,
  'comment': AppIcon.chat,
  'comments': AppIcon.comments,
  'comment-dots': AppIcon.commentDots,
  'paper-plane': AppIcon.send,
  'paperclip': AppIcon.attach,
  'microphone': AppIcon.microphone,
  'image': AppIcon.image,
  'file': AppIcon.file,
  'message': AppIcon.message,
  'reply': AppIcon.reply,
  'copy': AppIcon.copy,
  'share': AppIcon.share,
  'link': AppIcon.link,
  'envelope': AppIcon.envelope,
  'inbox': AppIcon.inbox,
  'user': AppIcon.user,
  'lock': AppIcon.lock,
  'right-to-bracket': AppIcon.signIn,
  'right-from-bracket': AppIcon.signOut,
  'robot': AppIcon.robot,
  'pen': AppIcon.edit,
  'trash': AppIcon.delete,
  'box-archive': AppIcon.archive,
  'download': AppIcon.download,
  'upload': AppIcon.upload,
  'floppy-disk': AppIcon.save,
  'clipboard': AppIcon.clipboard,
  'folder': AppIcon.folder,
  'folder-plus': AppIcon.folderPlus,
  'plus': AppIcon.plus,
  'minus': AppIcon.minus,
  'star': AppIcon.star,
  'heart': AppIcon.heart,
  'fire': AppIcon.fire,
  'rocket': AppIcon.rocket,
  'thumbtack': AppIcon.thumbtack,
  'gear': AppIcon.settings,
  'palette': AppIcon.palette,
  'bell': AppIcon.bell,
  'shield': AppIcon.shield,
  'database': AppIcon.database,
  'info': AppIcon.info,
  'circle-question': AppIcon.help,
  'question': AppIcon.question,
  'book': AppIcon.book,
  'lightbulb': AppIcon.lightbulb,
  'check': AppIcon.check,
  'triangle-exclamation': AppIcon.warning,
  'circle-exclamation': AppIcon.error,
  'circle-info': AppIcon.infoCircleIcon,
  'exclamation': AppIcon.exclamation,
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
  'graduation-cap': AppIcon.graduationCap,
  'code': AppIcon.code,
  'sitemap': AppIcon.sitemap,
  'brain': AppIcon.brain,
  'clock-rotate-left': AppIcon.history,
  'terminal': AppIcon.terminal,
  'bug': AppIcon.bug,
  'gears': AppIcon.cogs,
  'microchip': AppIcon.microchip,
  'laptop-code': AppIcon.laptopCode,
  'file-code': AppIcon.fileCodeIcon,
  'server': AppIcon.server,
  'net-wired': AppIcon.networkWired,
  'key': AppIcon.key,
  'unlock': AppIcon.unlock,
  'list': AppIcon.list,
  'table-cells': AppIcon.grid,
  'table-cells-large': AppIcon.thLarge,
  'play': AppIcon.play,
  'pause': AppIcon.pause,
  'stop': AppIcon.stop,
  'music': AppIcon.music,
  'video': AppIcon.video,
  'file-lines': AppIcon.fileText,
  'camera': AppIcon.camera,
  'film': AppIcon.film,
  'calculator': AppIcon.calculator,
  'divide': AppIcon.divide,
  'equals': AppIcon.equals,
  'percent': AppIcon.percentage,
  'infinity': AppIcon.infinity,
  'pi': AppIcon.pi,
  'sigma': AppIcon.sigma,
  'function': AppIcon.function,
  'chart-line': AppIcon.chartLine,
  'chart-bar': AppIcon.chartBar,
  'chart-pie': AppIcon.chartPie,
  'chart-area': AppIcon.chartArea,
  'sort-numeric-up': AppIcon.sortNumericUp,
  'sort-numeric-down': AppIcon.sortNumericDown,
  'sort-amount-up': AppIcon.sortAmountUp,
  'sort-amount-down': AppIcon.sortAmountDown,
  'square-root-variable': AppIcon.squareRootAlt,
  'flask': AppIcon.flask,
  'atom': AppIcon.atom,
  'dna': AppIcon.dna,
  'microscope': AppIcon.microscope,
  'telescope': AppIcon.telescope,
  'vial': AppIcon.vial,
  'pills': AppIcon.pills,
  'stethoscope': AppIcon.stethoscope,
  'heart-pulse': AppIcon.heartbeat,
  'eye': AppIcon.eye,
  'ear-listen': AppIcon.ear,
  'nose': AppIcon.nose,
  'tooth': AppIcon.tooth,
  'bone': AppIcon.bone,
  'lungs': AppIcon.lungs,
  'liver': AppIcon.liver,
  'kidneys': AppIcon.kidney,
  'stomach': AppIcon.stomach,
  'intestines': AppIcon.intestines,
  'chalkboard-user': AppIcon.chalkboardTeacher,
  'chalkboard': AppIcon.chalkboard,
  'pencil': AppIcon.pencilAlt,
  'highlighter': AppIcon.highlighter,
  'note-sticky': AppIcon.stickyNote,
  'folder-open': AppIcon.folderOpen,
  'paintbrush': AppIcon.paintBrush,
  'guitar': AppIcon.guitar,
  'piano-keyboard': AppIcon.piano,
  'masks-theater': AppIcon.theaterMasks,
  'wand-magic': AppIcon.magic,
  'gem': AppIcon.gem,
  'crown': AppIcon.crown,
  'trophy': AppIcon.trophy,
  'medal': AppIcon.medal,
  'award': AppIcon.award,
  'certificate': AppIcon.certificate,
  'ribbon': AppIcon.ribbon,
  'flag': AppIcon.flag,
  'user-friends': AppIcon.userFriends,
  'handshake': AppIcon.handshake,
  'bell-slash': AppIcon.bellSlash,
  'calendar': AppIcon.calendarAlt,
  'stopwatch': AppIcon.stopwatch,
  'hourglass-half': AppIcon.hourglassHalf,
  'arrow-up-right-from-square': AppIcon.external,
  'circle-check': AppIcon.checkCircle,
  'circle-xmark': AppIcon.timesCircle,
  'exclamation-circle': AppIcon.exclamationCircle,
};

/// Mapping from AppIcon enums to FontAwesome class names
const Map<AppIcon, String> _appIconToFontAwesomeMap = {
  AppIcon.home: 'house',
  AppIcon.back: 'arrow-left',
  AppIcon.next: 'arrow-right',
  AppIcon.close: 'xmark',
  AppIcon.menu: 'bars',
  AppIcon.search: 'magnifying-glass',
  AppIcon.filter: 'filter',
  AppIcon.sort: 'arrows-up-down',
  AppIcon.refresh: 'arrows-rotate',
  AppIcon.chat: 'comment',
  AppIcon.comments: 'comments',
  AppIcon.commentDots: 'comment-dots',
  AppIcon.send: 'paper-plane',
  AppIcon.attach: 'paperclip',
  AppIcon.microphone: 'microphone',
  AppIcon.image: 'image',
  AppIcon.file: 'file',
  AppIcon.message: 'message',
  AppIcon.reply: 'reply',
  AppIcon.copy: 'copy',
  AppIcon.share: 'share',
  AppIcon.link: 'link',
  AppIcon.envelope: 'envelope',
  AppIcon.inbox: 'inbox',
  AppIcon.user: 'user',
  AppIcon.lock: 'lock',
  AppIcon.signIn: 'right-to-bracket',
  AppIcon.signOut: 'right-from-bracket',
  AppIcon.robot: 'robot',
  AppIcon.edit: 'pen',
  AppIcon.delete: 'trash',
  AppIcon.trash: 'trash',
  AppIcon.archive: 'box-archive',
  AppIcon.download: 'download',
  AppIcon.upload: 'upload',
  AppIcon.save: 'floppy-disk',
  AppIcon.clipboard: 'clipboard',
  AppIcon.folder: 'folder',
  AppIcon.folderPlus: 'folder-plus',
  AppIcon.plus: 'plus',
  AppIcon.minus: 'minus',
  AppIcon.star: 'star',
  AppIcon.heart: 'heart',
  AppIcon.fire: 'fire',
  AppIcon.rocket: 'rocket',
  AppIcon.thumbtack: 'thumbtack',
  AppIcon.settings: 'gear',
  AppIcon.cog: 'gear',
  AppIcon.palette: 'palette',
  AppIcon.bell: 'bell',
  AppIcon.shield: 'shield',
  AppIcon.database: 'database',
  AppIcon.info: 'info',
  AppIcon.help: 'circle-question',
  AppIcon.question: 'question',
  AppIcon.book: 'book',
  AppIcon.lightbulb: 'lightbulb',
  AppIcon.check: 'check',
  AppIcon.warning: 'triangle-exclamation',
  AppIcon.error: 'circle-exclamation',
  AppIcon.exclamation: 'exclamation',
  AppIcon.exclamationTriangle: 'triangle-exclamation',
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
  AppIcon.graduationCap: 'graduation-cap',
  AppIcon.code: 'code',
  AppIcon.sitemap: 'sitemap',
  AppIcon.brain: 'brain',
  AppIcon.history: 'clock-rotate-left',
  AppIcon.lockKeyhole: 'lock',
  AppIcon.terminal: 'terminal',
  AppIcon.bug: 'bug',
  AppIcon.cogs: 'gears',
  AppIcon.microchip: 'microchip',
  AppIcon.laptopCode: 'laptop-code',
  AppIcon.fileCodeIcon: 'file-code',
  AppIcon.server: 'server',
  AppIcon.networkWired: 'net-wired',
  AppIcon.key: 'key',
  AppIcon.unlock: 'unlock',
  AppIcon.list: 'list',
  AppIcon.grid: 'table-cells',
  AppIcon.thLarge: 'table-cells-large',
  AppIcon.bars: 'bars',
  AppIcon.play: 'play',
  AppIcon.pause: 'pause',
  AppIcon.stop: 'stop',
  AppIcon.music: 'music',
  AppIcon.video: 'video',
  AppIcon.fileText: 'file-lines',
  AppIcon.camera: 'camera',
  AppIcon.film: 'film',
  AppIcon.calculator: 'calculator',
  AppIcon.times: 'xmark',
  AppIcon.divide: 'divide',
  AppIcon.equals: 'equals',
  AppIcon.percentage: 'percent',
  AppIcon.infinity: 'infinity',
  AppIcon.pi: 'pi',
  AppIcon.sigma: 'sigma',
  AppIcon.function: 'function',
  AppIcon.chartLine: 'chart-line',
  AppIcon.chartBar: 'chart-bar',
  AppIcon.chartPie: 'chart-pie',
  AppIcon.chartArea: 'chart-area',
  AppIcon.sortNumericUp: 'sort-numeric-up',
  AppIcon.sortNumericDown: 'sort-numeric-down',
  AppIcon.sortAmountUp: 'sort-amount-up',
  AppIcon.sortAmountDown: 'sort-amount-down',
  AppIcon.squareRootAlt: 'square-root-variable',
  AppIcon.flask: 'flask',
  AppIcon.atom: 'atom',
  AppIcon.dna: 'dna',
  AppIcon.microscope: 'microscope',
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
  AppIcon.chalkboardTeacher: 'chalkboard-user',
  AppIcon.chalkboard: 'chalkboard',
  AppIcon.pencilAlt: 'pencil',
  AppIcon.pen: 'pen',
  AppIcon.highlighter: 'highlighter',
  AppIcon.stickyNote: 'note-sticky',
  AppIcon.folderOpen: 'folder-open',
  AppIcon.paintBrush: 'paintbrush',
  AppIcon.guitar: 'guitar',
  AppIcon.piano: 'piano-keyboard',
  AppIcon.theaterMasks: 'masks-theater',
  AppIcon.magic: 'wand-magic',
  AppIcon.gem: 'gem',
  AppIcon.crown: 'crown',
  AppIcon.trophy: 'trophy',
  AppIcon.medal: 'medal',
  AppIcon.award: 'award',
  AppIcon.certificate: 'certificate',
  AppIcon.ribbon: 'ribbon',
  AppIcon.flag: 'flag',
  AppIcon.users: 'users',
  AppIcon.userFriends: 'user-friends',
  AppIcon.handshake: 'handshake',
  AppIcon.commentAlt: 'comment',
  AppIcon.bellSlash: 'bell-slash',
  AppIcon.calendarAlt: 'calendar',
  AppIcon.clock: 'clock',
  AppIcon.stopwatch: 'stopwatch',
  AppIcon.hourglassHalf: 'hourglass-half',
  AppIcon.external: 'arrow-up-right-from-square',
  AppIcon.fileLines: 'file-lines',
  AppIcon.fileAlt: 'file-lines',
  AppIcon.arrowLeft: 'arrow-left',
  AppIcon.arrowRight: 'arrow-right',
  AppIcon.arrowUp: 'arrow-up',
  AppIcon.arrowDown: 'arrow-down',
  AppIcon.arrowTurnUpLeft: 'arrow-turn-up-left',
  AppIcon.arrowTurnUpRight: 'arrow-turn-up-right',
  AppIcon.arrowTurnDownLeft: 'arrow-turn-down-left',
  AppIcon.arrowTurnDownRight: 'arrow-turn-down-right',
  AppIcon.xmark: 'xmark',
  AppIcon.checkCircle: 'circle-check',
  AppIcon.timesCircle: 'circle-xmark',
  AppIcon.infoCircleIcon: 'circle-info',
  AppIcon.exclamationCircle: 'circle-exclamation',
  AppIcon.questionCircle: 'circle-question',
  AppIcon.paperclip: 'paperclip',
  AppIcon.paperPlane: 'paper-plane',
};
