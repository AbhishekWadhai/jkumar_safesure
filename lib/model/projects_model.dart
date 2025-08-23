import 'dart:convert';

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
  int v;

  Project({
    required this.id,
    required this.projectId,
    required this.projectName,
    required this.siteLocation,
    required this.startDate,
    required this.endDate,
    required this.status,
    this.description,
    required this.company,
    required this.v,
  });

  factory Project.fromRawJson(String str) => Project.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Project.fromJson(Map<String, dynamic> json) => Project(
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
