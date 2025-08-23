import 'dart:convert';

class Tools {
    String id;
    int v;
    String tools;

    Tools({
        required this.id,
        required this.v,
        required this.tools,
    });

    factory Tools.fromRawJson(String str) => Tools.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Tools.fromJson(Map<String, dynamic> json) => Tools(
        id: json["_id"],
        v: json["__v"],
        tools: json["tools"],
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "__v": v,
        "tools": tools,
    };
}
