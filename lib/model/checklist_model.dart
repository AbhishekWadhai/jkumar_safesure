import 'package:sure_safe/model/projects_model.dart';
import 'package:sure_safe/model/user_model.dart';

class ChecklistModel {
  String id;
  Project project;
  String date;
  User checkedBy;
  String location;
  String shift;
  List<ChecklistItem> checklistItems;
  String overallRemarks;
  String signature;
  String createdAt;
  int v;

  ChecklistModel({
    required this.id,
    required this.project,
    required this.date,
    required this.checkedBy,
    required this.location,
    required this.shift,
    required this.checklistItems,
    required this.overallRemarks,
    required this.signature,
    required this.createdAt,
    required this.v,
  });

  factory ChecklistModel.fromJson(Map<String, dynamic> json) => ChecklistModel(
        id: json["_id"],
        project: json["project"],
        date: json["date"],
        checkedBy: json["checkedBy"],
        location: json["location"],
        shift: json["shift"],
        checklistItems: List<ChecklistItem>.from(
            json["checklistItems"].map((x) => ChecklistItem.fromJson(x))),
        overallRemarks: json["overallRemarks"],
        signature: json["signature"],
        createdAt: json["createdAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "project": project,
        "date": date,
        "checkedBy": checkedBy,
        "location": location,
        "shift": shift,
        "checklistItems":
            List<dynamic>.from(checklistItems.map((x) => x.toJson())),
        "overallRemarks": overallRemarks,
        "signature": signature,
        "createdAt": createdAt,
        "__v": v,
      };
}

class ChecklistItem {
  String title;
  String status;
  String remarks;
  String photoEvidence;
  String id;

  ChecklistItem({
    required this.title,
    required this.status,
    required this.remarks,
    required this.photoEvidence,
    required this.id,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) => ChecklistItem(
        title: json["title"],
        status: json["status"],
        remarks: json["remarks"],
        photoEvidence: json["photoEvidence"],
        id: json["_id"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "status": status,
        "remarks": remarks,
        "photoEvidence": photoEvidence,
        "_id": id,
      };
}
