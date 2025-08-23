class Strings {
  static String get rohanEkam => "Rohan Ekam";
  static String get permit => "Permit";
  static String get workPermit => "Work Permit";
  static String get tbtMeeting => "TBT Meetings";
  static String get safetyInduction => "Safety Induction";
  static String get uaucs => "UA & UC";
  static String get incidentReport => "Incident Reports";
  static String get safetyTraining => "Safety Training";
  static String get specificTraining => "Job Specific Training";
  static String get training => "Training";
  static String get safetyReport => "Safety Report";
  static String get reporting => "Reporting";
  static List<String> fileTypes = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'bmp',
    'webp',
    'heic',
    'heif',
    'tiff',
    'tif',
    'pdf',
    'doc',
    'docx',
    'odt',
    'rtf',
    'txt',
    'md',
    'xls',
    'xlsx',
    'ods',
    'csv',
    'tsv'
  ];
  static String fcmToken = "";
  static String userId = "";
  static String roleName = "";
  static String userName = "";
  static String locationName = "";
  static dynamic project;
  static dynamic userDetails;
  static dynamic notifications;
  static List<dynamic> permisssions = [];
  static List<dynamic> projects = [];
  static List<dynamic> mappedProjects = [];
  static List<dynamic> permitsType = [];
  static List<dynamic> users = [];
  static List<dynamic> safetyUsers = [];
  static List<dynamic> managementUser = [];
  static List<dynamic> exeUsers = [];
  static List<dynamic> topics = [];
  static List<dynamic> riskRatings = [];
  static List<dynamic> tools = [];
  static List<dynamic> equipments = [];
  static List<dynamic> hazards = [];
  static List<dynamic> ppes = [];
  static List<dynamic> trades = [];
  static List<dynamic> workpermit = [];
  static List<dynamic> meetings = [];
  static List<dynamic> specific = [];
  static List<dynamic> uauc = [];
  static List<dynamic> induction = [];
  static List<dynamic> safetyreport = [];
  static List<dynamic> workpermitPageFild = [];

  static final Map<String, dynamic> endpointToList = {
    "projects": projects,
    "mappedProjects": mappedProjects,
    "permitstype": permitsType,
    "user": users,
    "safetyuser": safetyUsers,
    "managementuser": managementUser,
    "exeuser": exeUsers,
    "permission": permisssions,
    "userid": userId,
    "topic": topics,
    "RiskRating": riskRatings,
    "tools": tools,
    "equipments": equipments,
    "hazards": hazards,
    "ppe": ppes,
    "trade": trades,
    "project": project,
    "userDetails": userDetails,
    "workpermit": workpermit,
    "meeting": meetings,
    "specific": specific,
    "uauc": uauc,
    "induction": induction,
    "safetyreport": safetyreport,
  };
}
