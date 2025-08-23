import 'dart:convert';

class Ppe {
    String id;
    String ppes;
    int v;

    Ppe({
        required this.id,
        required this.ppes,
        required this.v,
    });

    factory Ppe.fromRawJson(String str) => Ppe.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Ppe.fromJson(Map<String, dynamic> json) => Ppe(
        id: json["_id"],
        ppes: json["ppes"],
        v: json["__v"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "ppes": ppes,
        "__v": v,
    };
}
