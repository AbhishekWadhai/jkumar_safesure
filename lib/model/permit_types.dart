import 'dart:convert';

class PermitsType {
  String id;
  String permitsType;
  int v;
  List<String> safetyChecks;

  PermitsType({
    required this.id,
    required this.permitsType,
    required this.v,
    required this.safetyChecks,
  });

  factory PermitsType.fromJson(Map<String, dynamic> json) => PermitsType(
        id: json["_id"],
        permitsType: json["permitsType"],
        v: json["__v"],
        safetyChecks: List<String>.from(json["SafetyChecks"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "permitsType": permitsType,
        "__v": v,
        "SafetyChecks": List<dynamic>.from(safetyChecks.map((x) => x)),
      };
}
