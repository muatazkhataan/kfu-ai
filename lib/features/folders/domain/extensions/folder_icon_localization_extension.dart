import 'package:flutter/material.dart';
import '../models/folder_icon.dart';
import '../../../../core/localization/l10n.dart';

/// Extension for FolderIcon localization
extension FolderIconLocalizationExtension on FolderIcon {
  /// Get localized icon name
  /// Falls back to Arabic name if translation not found
  String getLocalizedName(BuildContext context) {
    final l10n = context.l10n;
    
    // Try to get translation using icon id
    // Use a switch statement for common icons, fallback to name for others
    try {
      return _getIconNameTranslation(l10n, id) ?? name;
    } catch (e) {
      return name; // Fallback to Arabic name
    }
  }

  /// Helper method to get icon name translation
  String? _getIconNameTranslation(dynamic l10n, String iconId) {
    try {
      // Use a switch statement for the most common icons
      // Return null for others (which will use fallback to Arabic name)
      return _getCommonIconTranslation(l10n, iconId);
    } catch (e) {
      return null; // Use fallback
    }
  }

  /// Get translation for common icons
  /// This method maps icon IDs to their translation keys
  /// For icons not in this list, it returns null to use the Arabic name as fallback
  String? _getCommonIconTranslation(dynamic l10n, String iconId) {
    switch (iconId) {
      // General category icons
      case 'folder_general':
        return l10n.iconFolderGeneral;
      case 'folder_star':
        return l10n.iconFolderStar;
      case 'folder_heart':
        return l10n.iconFolderHeart;
      case 'folder_home':
        return l10n.iconFolderHome;
      case 'folder_thumbtack':
        return l10n.iconFolderThumbtack;
      case 'folder_folder_plus':
        return l10n.iconFolderPlus;
      case 'folder_folder_open':
        return l10n.iconFolderOpen;
      
      // Programming category icons
      case 'folder_code':
      case 'icon_code':
        return l10n.iconCode;
      case 'icon_laptop_code':
        return l10n.iconLaptopCode;
      case 'icon_terminal':
        return l10n.iconTerminal;
      case 'icon_bug':
        return l10n.iconBug;
      case 'icon_cogs':
        return l10n.iconCogs;
      case 'icon_microchip':
        return l10n.iconMicrochip;
      case 'icon_server':
        return l10n.iconServer;
      case 'icon_network_wired':
        return l10n.iconNetworkWired;
      case 'icon_shield_alt':
        return l10n.iconShieldAlt;
      case 'icon_key':
        return l10n.iconKey;
      case 'icon_database':
      case 'folder_database':
        return l10n.iconDatabase;
      case 'icon_table':
        return l10n.iconTable;
      case 'icon_chart_bar':
        return l10n.iconChartBar;
      case 'icon_mobile_alt':
        return l10n.iconMobileAlt;
      case 'icon_globe':
        return l10n.iconGlobe;
      case 'icon_cloud':
        return l10n.iconCloud;
      case 'icon_robot':
        return l10n.iconRobot;
      case 'icon_brain':
      case 'folder_brain':
        return l10n.iconBrain;
      case 'icon_sitemap':
      case 'folder_sitemap':
        return l10n.iconSitemap;
      case 'icon_project_diagram':
        return l10n.iconProjectDiagram;
      case 'icon_file_code':
        return l10n.iconFileCode;
      case 'icon_code_branch':
        return l10n.iconCodeBranch;
      case 'icon_code_merge':
        return l10n.iconCodeMerge;
      case 'icon_code_compare':
        return l10n.iconCodeCompare;
      
      // Mathematics category icons
      case 'icon_calculator':
        return l10n.iconCalculator;
      case 'icon_square_root_alt':
        return l10n.iconSquareRootAlt;
      case 'icon_infinity':
        return l10n.iconInfinity;
      case 'icon_percentage':
        return l10n.iconPercentage;
      case 'icon_chart_line':
        return l10n.iconChartLine;
      case 'icon_chart_pie':
        return l10n.iconChartPie;
      case 'icon_chart_area':
        return l10n.iconChartArea;
      case 'icon_sort_numeric_up':
        return l10n.iconSortNumericUp;
      case 'icon_sort_numeric_down':
        return l10n.iconSortNumericDown;
      case 'icon_equals':
        return l10n.iconEquals;
      case 'icon_plus':
        return l10n.iconPlus;
      case 'icon_minus':
        return l10n.iconMinus;
      case 'icon_times':
        return l10n.iconTimes;
      case 'icon_divide':
        return l10n.iconDivide;
      case 'icon_superscript':
        return l10n.iconSuperscript;
      case 'icon_subscript':
        return l10n.iconSubscript;
      case 'icon_sigma':
        return l10n.iconSigma;
      case 'icon_pi':
        return l10n.iconPi;
      case 'icon_function':
        return l10n.iconFunction;
      case 'icon_integral':
        return l10n.iconIntegral;
      case 'icon_triangle':
        return l10n.iconTriangle;
      case 'icon_omega':
        return l10n.iconOmega;
      case 'icon_theta':
        return l10n.iconTheta;
      
      // Science category icons
      case 'icon_atom':
        return l10n.iconAtom;
      case 'icon_flask':
        return l10n.iconFlask;
      case 'icon_microscope':
        return l10n.iconMicroscope;
      case 'icon_dna':
        return l10n.iconDna;
      case 'icon_leaf':
        return l10n.iconLeaf;
      case 'icon_seedling':
        return l10n.iconSeedling;
      case 'icon_droplet':
        return l10n.iconDroplet;
      case 'icon_fire':
        return l10n.iconFire;
      case 'icon_bolt':
        return l10n.iconBolt;
      case 'icon_magnet':
        return l10n.iconMagnet;
      case 'icon_satellite':
        return l10n.iconSatellite;
      case 'icon_rocket':
        return l10n.iconRocket;
      case 'icon_sun':
        return l10n.iconSun;
      case 'icon_moon':
        return l10n.iconMoon;
      case 'icon_star':
        return l10n.iconStar;
      case 'icon_telescope':
        return l10n.iconTelescope;
      case 'icon_vial':
        return l10n.iconVial;
      case 'icon_pills':
        return l10n.iconPills;
      case 'icon_stethoscope':
        return l10n.iconStethoscope;
      case 'icon_heartbeat':
        return l10n.iconHeartbeat;
      case 'icon_eye':
        return l10n.iconEye;
      case 'icon_ear':
        return l10n.iconEar;
      case 'icon_nose':
        return l10n.iconNose;
      case 'icon_tooth':
        return l10n.iconTooth;
      case 'icon_bone':
        return l10n.iconBone;
      case 'icon_lungs':
        return l10n.iconLungs;
      case 'icon_liver':
        return l10n.iconLiver;
      case 'icon_kidney':
        return l10n.iconKidney;
      case 'icon_stomach':
        return l10n.iconStomach;
      case 'icon_intestines':
        return l10n.iconIntestines;
      
      // Study category icons
      case 'icon_graduation_cap':
      case 'folder_graduation_cap':
        return l10n.iconGraduationCap;
      case 'icon_book':
        return l10n.iconBook;
      case 'icon_book_open':
        return l10n.iconBookOpen;
      case 'icon_pen':
        return l10n.iconPen;
      case 'icon_pencil_alt':
        return l10n.iconPencilAlt;
      case 'icon_highlighter':
        return l10n.iconHighlighter;
      case 'icon_sticky_note':
        return l10n.iconStickyNote;
      case 'icon_clipboard':
        return l10n.iconClipboard;
      case 'icon_file_alt':
        return l10n.iconFileAlt;
      case 'icon_archive':
      case 'folder_archive':
        return l10n.iconArchive;
      case 'icon_calendar_alt':
        return l10n.iconCalendarAlt;
      case 'icon_clock':
        return l10n.iconClock;
      case 'icon_stopwatch':
        return l10n.iconStopwatch;
      case 'icon_hourglass_half':
        return l10n.iconHourglassHalf;
      case 'icon_bell':
        return l10n.iconBell;
      case 'icon_flag':
        return l10n.iconFlag;
      case 'icon_trophy':
        return l10n.iconTrophy;
      case 'icon_medal':
        return l10n.iconMedal;
      case 'icon_certificate':
        return l10n.iconCertificate;
      case 'icon_award':
        return l10n.iconAward;
      case 'icon_user_graduate':
        return l10n.iconUserGraduate;
      case 'icon_chalkboard_teacher':
        return l10n.iconChalkboardTeacher;
      case 'icon_chalkboard':
        return l10n.iconChalkboard;
      case 'icon_search':
        return l10n.iconSearch;
      case 'icon_question_circle':
        return l10n.iconQuestionCircle;
      case 'icon_lightbulb':
        return l10n.iconLightbulb;
      case 'icon_inbox':
      case 'folder_inbox':
        return l10n.iconInbox;
      
      // Creativity category icons
      case 'icon_palette':
        return l10n.iconPalette;
      case 'icon_paint_brush':
        return l10n.iconPaintBrush;
      case 'icon_magic':
        return l10n.iconMagic;
      case 'icon_sparkles':
        return l10n.iconSparkles;
      case 'icon_eye_dropper':
        return l10n.iconEyeDropper;
      case 'icon_camera':
        return l10n.iconCamera;
      case 'icon_video':
        return l10n.iconVideo;
      case 'icon_music':
        return l10n.iconMusic;
      case 'icon_headphones':
        return l10n.iconHeadphones;
      case 'icon_gamepad':
        return l10n.iconGamepad;
      case 'icon_dice':
        return l10n.iconDice;
      case 'icon_puzzle_piece':
        return l10n.iconPuzzlePiece;
      case 'icon_cube':
        return l10n.iconCube;
      case 'icon_gem':
        return l10n.iconGem;
      case 'icon_crown':
        return l10n.iconCrown;
      case 'icon_ribbon':
        return l10n.iconRibbon;
      
      // Collaboration category icons
      case 'icon_users':
        return l10n.iconUsers;
      case 'icon_user_friends':
        return l10n.iconUserFriends;
      case 'icon_handshake':
        return l10n.iconHandshake;
      case 'icon_comments':
        return l10n.iconComments;
      case 'icon_comment_dots':
        return l10n.iconCommentDots;
      case 'icon_envelope':
        return l10n.iconEnvelope;
      case 'icon_phone':
        return l10n.iconPhone;
      case 'icon_video_camera':
        return l10n.iconVideoCamera;
      case 'icon_share_alt':
        return l10n.iconShareAlt;
      case 'icon_link':
        return l10n.iconLink;
      case 'icon_sync':
        return l10n.iconSync;
      case 'icon_download':
        return l10n.iconDownload;
      case 'icon_upload':
        return l10n.iconUpload;
      case 'icon_print':
        return l10n.iconPrint;
      case 'icon_copy':
        return l10n.iconCopy;
      case 'icon_paper_plane':
        return l10n.iconPaperPlane;
      case 'icon_send':
        return l10n.iconSend;
      case 'icon_bell_slash':
        return l10n.iconBellSlash;
      case 'icon_chat':
        return l10n.iconChat;
      case 'icon_message':
        return l10n.iconMessage;
      case 'icon_reply':
        return l10n.iconReply;
      case 'icon_share':
        return l10n.iconShare;
      case 'icon_attach':
        return l10n.iconAttach;
      case 'icon_image':
        return l10n.iconImage;
      case 'icon_file':
        return l10n.iconFile;
      case 'icon_paperclip':
        return l10n.iconPaperclip;
      
      // System category icons
      case 'icon_settings':
        return l10n.iconSettings;
      case 'icon_cog':
        return l10n.iconCog;
      case 'icon_shield':
        return l10n.iconShield;
      case 'icon_info':
        return l10n.iconInfo;
      case 'icon_help':
        return l10n.iconHelp;
      case 'icon_question':
        return l10n.iconQuestion;
      case 'icon_check':
        return l10n.iconCheck;
      case 'icon_warning':
        return l10n.iconWarning;
      case 'icon_error':
        return l10n.iconError;
      case 'icon_info_circle':
        return l10n.iconInfoCircle;
      case 'icon_exclamation':
        return l10n.iconExclamation;
      case 'icon_exclamation_triangle':
        return l10n.iconExclamationTriangle;
      case 'icon_user':
        return l10n.iconUser;
      case 'icon_lock':
        return l10n.iconLock;
      case 'icon_sign_in':
        return l10n.iconSignIn;
      case 'icon_sign_out':
        return l10n.iconSignOut;
      case 'icon_edit':
        return l10n.iconEdit;
      case 'icon_delete':
        return l10n.iconDelete;
      case 'icon_trash':
        return l10n.iconTrash;
      case 'icon_save':
        return l10n.iconSave;
      case 'icon_history':
        return l10n.iconHistory;
      case 'icon_lock_keyhole':
        return l10n.iconLockKeyhole;
      case 'icon_unlock':
        return l10n.iconUnlock;
      case 'icon_microphone':
        return l10n.iconMicrophone;
      case 'icon_file_code_icon':
        return l10n.iconFileCodeIcon;
      case 'icon_list':
        return l10n.iconList;
      case 'icon_grid':
        return l10n.iconGrid;
      case 'icon_th_large':
        return l10n.iconThLarge;
      case 'icon_bars':
        return l10n.iconBars;
      case 'icon_menu':
        return l10n.iconMenu;
      case 'icon_filter':
        return l10n.iconFilter;
      case 'icon_sort':
        return l10n.iconSort;
      case 'icon_refresh':
        return l10n.iconRefresh;
      case 'icon_back':
        return l10n.iconBack;
      case 'icon_next':
        return l10n.iconNext;
      case 'icon_previous':
        return l10n.iconPrevious;
      case 'icon_close':
        return l10n.iconClose;
      case 'icon_ellipsis':
        return l10n.iconEllipsis;
      case 'icon_ellipsis_h':
        return l10n.iconEllipsisH;
      case 'icon_ellipsis_v':
        return l10n.iconEllipsisV;
      case 'icon_chevron_up':
        return l10n.iconChevronUp;
      case 'icon_chevron_down':
        return l10n.iconChevronDown;
      case 'icon_chevron_left':
        return l10n.iconChevronLeft;
      case 'icon_chevron_right':
        return l10n.iconChevronRight;
      case 'icon_angle_up':
        return l10n.iconAngleUp;
      case 'icon_angle_down':
        return l10n.iconAngleDown;
      case 'icon_angle_left':
        return l10n.iconAngleLeft;
      case 'icon_angle_right':
        return l10n.iconAngleRight;
      case 'icon_angles_up':
        return l10n.iconAnglesUp;
      case 'icon_angles_down':
        return l10n.iconAnglesDown;
      case 'icon_up_right_and_down_left_from_center':
        return l10n.iconUpRightAndDownLeftFromCenter;
      case 'icon_down_left_and_up_right_to_center':
        return l10n.iconDownLeftAndUpRightToCenter;
      case 'icon_play':
        return l10n.iconPlay;
      case 'icon_pause':
        return l10n.iconPause;
      case 'icon_stop':
        return l10n.iconStop;
      case 'icon_film':
        return l10n.iconFilm;
      case 'icon_file_text':
        return l10n.iconFileText;
      case 'icon_file_lines':
        return l10n.iconFileLines;
      case 'icon_arrow_left':
        return l10n.iconArrowLeft;
      case 'icon_arrow_right':
        return l10n.iconArrowRight;
      case 'icon_arrow_up':
        return l10n.iconArrowUp;
      case 'icon_arrow_down':
        return l10n.iconArrowDown;
      case 'icon_arrow_turn_up_left':
        return l10n.iconArrowTurnUpLeft;
      case 'icon_arrow_turn_up_right':
        return l10n.iconArrowTurnUpRight;
      case 'icon_arrow_turn_down_left':
        return l10n.iconArrowTurnDownLeft;
      case 'icon_arrow_turn_down_right':
        return l10n.iconArrowTurnDownRight;
      case 'icon_xmark':
        return l10n.iconXmark;
      case 'icon_check_circle':
        return l10n.iconCheckCircle;
      case 'icon_times_circle':
        return l10n.iconTimesCircle;
      case 'icon_info_circle_icon':
        return l10n.iconInfoCircleIcon;
      case 'icon_exclamation_circle':
        return l10n.iconExclamationCircle;
      
      default:
        return null; // Use fallback to Arabic name
    }
  }
}
