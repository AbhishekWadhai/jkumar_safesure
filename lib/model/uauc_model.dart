import 'dart:convert';

class UaUc {
  String? id;
  Project? project;
  AssignedTo? createdby;
  String? area;
  String? date;
  String? time;
  AssignedTo? observer;
  String? observation;
  String? photo;
  List<Hazard>? hazards;
  String? causes;
  RiskValue? riskValue;
  String? suggestedActions;
  AssignedTo? assignedTo;
  String? status;
  String? comment;
  String? correctivePreventiveAction;
  String? actionTakenPhoto;
  AssignedTo? actionTakenBy;
  String? geotagging;
  int? v;

  UaUc({
    this.id,
    this.project,
    this.createdby,
    this.area,
    this.date,
    this.time,
    this.observer,
    this.observation,
    this.photo,
    this.hazards,
    this.causes,
    this.riskValue,
    this.suggestedActions,
    this.assignedTo,
    this.status,
    this.comment,
    this.correctivePreventiveAction,
    this.actionTakenPhoto,
    this.actionTakenBy,
    this.geotagging,
    this.v,
  });

  factory UaUc.fromRawJson(String str) => UaUc.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UaUc.fromJson(Map<String, dynamic> json) => UaUc(
        id: json["_id"] as String?,
        project:
            json["project"] == null ? null : Project.fromJson(json["project"]),
        createdby: json["createdby"] == null
            ? null
            : AssignedTo.fromJson(json["createdby"]),
        area: json["area"] as String?,
        date: json["date"] as String?,
        time: json["time"] as String?,
        observer: json["observer"] == null
            ? null
            : AssignedTo.fromJson(json["observer"]),
        observation: json["observation"] as String?,
        photo: json["photo"] as String?,
        hazards: json["hazards"] == null
            ? null
            : List<Hazard>.from(
                (json["hazards"] as List).map((x) => Hazard.fromJson(x))),
        causes: json["causes"] as String?,
        riskValue: json["riskValue"] == null
            ? null
            : RiskValue.fromJson(json["riskValue"]),
        suggestedActions: json["suggestedActions"] as String?,
        assignedTo: json["assignedTo"] == null
            ? null
            : AssignedTo.fromJson(json["assignedTo"]),
        status: json["status"] as String?,
        comment: json["comment"] as String?,
        correctivePreventiveAction:
            json["correctivePreventiveAction"] as String?,
        actionTakenPhoto: json["actionTakenPhoto"] as String?,
        actionTakenBy: json["actionTakenBy"] == null
            ? null
            : AssignedTo.fromJson(json["actionTakenBy"]),
        geotagging: json["geotagging"] as String?,
        v: json["__v"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project?.toJson(),
        "createdby": createdby?.toJson(),
        "area": area,
        "date": date,
        "time": time,
        "observer": observer?.toJson(),
        "observation": observation,
        "photo": photo,
        "hazards": hazards?.map((x) => x.toJson()).toList(),
        "causes": causes,
        "riskValue": riskValue?.toJson(),
        "suggestedActions": suggestedActions,
        "assignedTo": assignedTo?.toJson(),
        "status": status,
        "comment": comment,
        "actionTakenBy": actionTakenBy?.toJson(),
        "actionTakenPhoto": actionTakenPhoto,
        "correctivePreventiveAction": correctivePreventiveAction,
        "geotagging": geotagging,
        "__v": v,
      };
}

class AssignedTo {
  String? id;
  String? userId;
  String? name;
  String? role;
  String? emailId;
  String? password;
  String? phone;
  String? address;
  bool? isActive;
  List<dynamic>? project;
  String? createdAt;
  String? updatedAt;
  int? v;

  AssignedTo({
    this.id,
    this.userId,
    this.name,
    this.role,
    this.emailId,
    this.password,
    this.phone,
    this.address,
    this.isActive,
    this.project,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory AssignedTo.fromRawJson(String str) =>
      AssignedTo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AssignedTo.fromJson(Map<String, dynamic> json) => AssignedTo(
        id: json["_id"] as String?,
        userId: json["userId"] as String?,
        name: json["name"] as String?,
        role: json["role"] as String?,
        emailId: json["emailId"] as String?,
        password: json["password"] as String?,
        phone: json["phone"] as String?,
        address: json["address"] as String?,
        isActive: json["isActive"] as bool?,
        project: json["project"],
        createdAt: json["createdAt"] as String?,
        updatedAt: json["updatedAt"] as String?,
        v: json["__v"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "name": name,
        "role": role,
        "emailId": emailId,
        "password": password,
        "phone": phone,
        "address": address,
        "isActive": isActive,
        "project": project,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Hazard {
  String? id;
  String? hazards;
  int? v;

  Hazard({
    this.id,
    this.hazards,
    this.v,
  });

  factory Hazard.fromRawJson(String str) => Hazard.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Hazard.fromJson(Map<String, dynamic> json) => Hazard(
        id: json["_id"] as String?,
        hazards: json["hazards"] as String?,
        v: json["__v"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "hazards": hazards,
        "__v": v,
      };
}

class Project {
  String? id;
  String? projectId;
  String? projectName;
  String? siteLocation;
  String? startDate;
  String? endDate;
  String? status;
  String? description;
  String? company;
  int? v;
  String? workpermitAllow;

  Project({
    this.id,
    this.projectId,
    this.projectName,
    this.siteLocation,
    this.startDate,
    this.endDate,
    this.status,
    this.description,
    this.company,
    this.v,
    this.workpermitAllow,
  });

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        id: json["_id"] as String?,
        projectId: json["projectId"] as String?,
        projectName: json["projectName"] as String?,
        siteLocation: json["siteLocation"] as String?,
        startDate: json["startDate"] as String?,
        endDate: json["endDate"] as String?,
        status: json["status"] as String?,
        description: json["description"] as String?,
        company: json["company"] as String?,
        v: json["__v"] as int?,
        workpermitAllow: json["workpermitAllow"] as String?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "projectId": projectId,
        "projectName": projectName,
        "siteLocation": siteLocation,
        "startDate": startDate,
        "endDate": endDate,
        "status": status,
        "description": description,
        "company": company,
        "__v": v,
        "workpermitAllow": workpermitAllow,
      };
}

class RiskValue {
  String? id;
  int? value;
  String? severity;
  String? alertTimeline;
  List<String>? escalationAlert;
  String? repeatWarning;
  int? v;

  RiskValue({
    this.id,
    this.value,
    this.severity,
    this.alertTimeline,
    this.escalationAlert,
    this.repeatWarning,
    this.v,
  });

  factory RiskValue.fromRawJson(String str) =>
      RiskValue.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory RiskValue.fromJson(Map<String, dynamic> json) => RiskValue(
        id: json["_id"] as String?,
        value: json["value"] as int?,
        severity: json["severity"] as String?,
        alertTimeline: json["alertTimeline"] as String?,
        escalationAlert: json["escalationAlert"] == null
            ? null
            : List<String>.from(
                (json["escalationAlert"] as List).map((x) => x as String)),
        repeatWarning: json["repeatWarning"] as String?,
        v: json["__v"] as int?,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
        "severity": severity,
        "alertTimeline": alertTimeline,
        "escalationAlert": escalationAlert,
        "repeatWarning": repeatWarning,
        "__v": v,
      };
}
