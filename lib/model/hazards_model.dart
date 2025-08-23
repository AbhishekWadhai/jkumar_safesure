import 'dart:convert';

class Hazards {
    String id;
    String hazards;
    int v;

    Hazards({
        required this.id,
        required this.hazards,
        required this.v,
    });

    factory Hazards.fromRawJson(String str) => Hazards.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Hazards.fromJson(Map<String, dynamic> json) => Hazards(
        id: json["_id"],
        hazards: json["hazards"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "hazards": hazards,
        "__v": v,
    };
}
