import 'dart:convert';

class Roles {
  String id;
  String roleName;
  String description;
  List<String> permissions;
  int v;

  Roles({
    required this.id,
    required this.roleName,
    required this.description,
    required this.permissions,
    required this.v,
  });

  factory Roles.fromRawJson(String str) => Roles.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Roles.fromJson(Map<String, dynamic> json) => Roles(
        id: json["_id"],
        roleName: json["roleName"],
        description: json["description"],
        permissions: List<String>.from(json["permissions"].map((x) => x)),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "roleName": roleName,
        "description": description,
        "permissions": List<dynamic>.from(permissions.map((x) => x)),
        "__v": v,
      };
}
