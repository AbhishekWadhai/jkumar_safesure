import 'dart:convert';

//import 'package:rohan_suraksha_sathi/model/projects_model.dart';

class SpecificTraining {
  String id;
  Project project;
  Createdby? createdby;
  String date;
  String time;
  List<TypeOfTopic>? typeOfTopic;
  List<String>? attendees;
  List<AttendeesName>? attendeesName;
  Createdby? instructionBy;
  String? documentaryEvidencePhoto;
  String? geotagging;
  String? commentsBox;
  int? attendance;
  int? attendanceHours;
  int v;

  SpecificTraining({
    required this.id,
    required this.project,
    required this.createdby,
    required this.date,
    required this.time,
    required this.typeOfTopic,
    required this.attendees,
    required this.attendeesName,
    required this.instructionBy,
    required this.documentaryEvidencePhoto,
    required this.geotagging,
    required this.commentsBox,
    required this.attendance,
    required this.attendanceHours,
    required this.v,
  });

  factory SpecificTraining.fromRawJson(String str) =>
      SpecificTraining.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SpecificTraining.fromJson(Map<String, dynamic> json) =>
      SpecificTraining(
        id: json["_id"],
        project: Project.fromJson(json["project"]),
        createdby: json["createdby"] == null
            ? null
            : Createdby.fromJson(json["createdby"]),
        date: json["date"],
        time: json["time"],
        typeOfTopic: List<TypeOfTopic>.from(
            json["typeOfTopic"].map((x) => TypeOfTopic.fromJson(x))),
        attendees: List<String>.from(json["attendees"].map((x) => x)),
        attendeesName: List<AttendeesName>.from(
            json["attendeesName"].map((x) => AttendeesName.fromJson(x))),
        instructionBy: json["instructionBy"] == null
            ? null
            : Createdby.fromJson(json["instructionBy"]),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        geotagging: json["geotagging"],
        commentsBox: json["commentsBox"],
        attendance: json["attendance"],
        attendanceHours: json["attendanceHours"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project.toJson(),
        "createdby": createdby?.toJson(),
        "date": date,
        "time": time,
        "typeOfTopic":
            List<dynamic>.from(typeOfTopic?.map((x) => x.toJson()) ?? []),
        "attendees": List<dynamic>.from(attendees?.map((x) => x) ?? []),
        "attendeesName":
            List<dynamic>.from(attendeesName?.map((x) => x.toJson()) ?? []),
        "instructionBy": instructionBy?.toJson(),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "geotagging": geotagging,
        "commentsBox": commentsBox,
        "attendance": attendance,
        "attendanceHours": attendanceHours,
        "__v": v,
      };
}

class Project {
  String? workpermitAllow;
  String? id;
  String? projectId;
  String? projectName;
  String? siteLocation;
  String? startDate;
  String? endDate;
  String? status;
  String? description;
  String? company;
  int v;

  Project({
    required this.workpermitAllow,
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.description,
    required this.company,
    required this.v,
  });

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) => Project(
        workpermitAllow: json["workpermitAllow"],
        id: json["_id"],
        projectId: json["projectId"],
        projectName: json["projectName"],
        siteLocation: json["siteLocation"],
        startDate: json["startDate"],
        endDate: json["endDate"],
        status: json["status"],
        description: json["description"],
        company: json["company"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "workpermitAllow": workpermitAllow,
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
      };
}

class AttendeesName {
  String? name;
  String? subcontractorName;
  String? signature;
  String? designation;
  String id;

  AttendeesName({
    required this.name,
    required this.subcontractorName,
    required this.signature,
    required this.designation,
    required this.id,
  });

  factory AttendeesName.fromRawJson(String str) =>
      AttendeesName.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AttendeesName.fromJson(Map<String, dynamic> json) => AttendeesName(
        name: json["name"],
        subcontractorName: json["subcontractorName"],
        signature: json["signature"],
        designation: json["designation"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "subcontractorName": subcontractorName,
        "signature": signature,
        "designation": designation,
        "_id": id,
      };
}

class Createdby {
  String? id;
  String? userId;
  String? name;
  String? role;
  String? emailId;
  String? password;
  String? phone;
  String? address;
  bool? isActive;
  List<dynamic> project;
  String? createdAt;
  String? updatedAt;
  int v;

  Createdby({
    required this.id,
    required this.userId,
    required this.name,
    required this.role,
    required this.emailId,
    required this.password,
    required this.phone,
    required this.address,
    required this.isActive,
    required this.project,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Createdby.fromRawJson(String str) =>
      Createdby.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Createdby.fromJson(Map<String, dynamic> json) => Createdby(
        id: json["_id"],
        userId: json["userId"],
        name: json["name"],
        role: json["role"],
        emailId: json["emailId"],
        password: json["password"],
        phone: json["phone"],
        address: json["address"],
        isActive: json["isActive"],
        project: json["project"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
        v: json["__v"],
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

class TypeOfTopic {
  String? id;
  String? topicTypes;
  int v;

  TypeOfTopic({
    required this.id,
    required this.topicTypes,
    required this.v,
  });

  factory TypeOfTopic.fromRawJson(String str) =>
      TypeOfTopic.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TypeOfTopic.fromJson(Map<String, dynamic> json) => TypeOfTopic(
        id: json["_id"],
        topicTypes: json["topicTypes"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "topicTypes": topicTypes,
        "__v": v,
      };
}
