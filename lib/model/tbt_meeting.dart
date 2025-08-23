import 'dart:convert';

import 'projects_model.dart';

class TbtMeeting {
  String? id;
  Project? project;
  TbtGivenBy? createdby;
  String? date;
  String? time;
  List<String>? attendees;
  String? attendeesNos;
  List<TypeOfTopic>? typeOfTopic;
  String? documentaryEvidencePhoto;
  TbtGivenBy? tbtGivenBy;
  String? geotagging;
  String? commentsBox;
  double? attendeesHours;
  int v;

  TbtMeeting({
    required this.id,
    required this.project,
    required this.createdby,
    required this.date,
    required this.time,
    required this.attendees,
    required this.attendeesNos,
    required this.typeOfTopic,
    required this.documentaryEvidencePhoto,
    required this.tbtGivenBy,
    required this.geotagging,
    required this.commentsBox,
    required this.attendeesHours,
    required this.v,
  });

  factory TbtMeeting.fromRawJson(String str) =>
      TbtMeeting.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TbtMeeting.fromJson(Map<String, dynamic> json) => TbtMeeting(
        id: json["_id"],
        project:
            json["project"] == null ? null : Project.fromJson(json["project"]),
        createdby: json["createdby"] == null
            ? null
            : TbtGivenBy.fromJson(json["createdby"]),
        date: json["date"],
        time: json["time"],
        attendees: json["attendees"] == null
            ? null
            : List<String>.from(json["attendees"].map((x) => x.toString())),
        attendeesNos: json["attendeesNos"],
        typeOfTopic: List<TypeOfTopic>.from(
            json["typeOfTopic"].map((x) => TypeOfTopic.fromJson(x))),
        documentaryEvidencePhoto: json["documentaryEvidencePhoto"],
        tbtGivenBy: json["TbtGivenBy"] == null
            ? null
            : TbtGivenBy.fromJson(json["TbtGivenBy"]),
        geotagging: json["geotagging"],
        commentsBox: json["commentsBox"],
        attendeesHours: json["attendeesHours"]?.toDouble(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project?.toJson(),
        "createdby": createdby?.toJson(),
        "date": date,
        "time": time,
        "attendees": attendees,
        "attendeesNos": attendeesNos,
        "typeOfTopic":
            List<dynamic>.from(typeOfTopic?.map((x) => x.toJson()) ?? []),
        "documentaryEvidencePhoto": documentaryEvidencePhoto,
        "TbtGivenBy": tbtGivenBy?.toJson(),
        "geotagging": geotagging,
        "commentsBox": commentsBox,
        "attendeesHours": attendeesHours,
        "__v": v,
      };
}

class TbtGivenBy {
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
  int v;

  TbtGivenBy({
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

  factory TbtGivenBy.fromRawJson(String str) =>
      TbtGivenBy.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TbtGivenBy.fromJson(Map<String, dynamic> json) => TbtGivenBy(
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
  String id;
  String topicTypes;
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
