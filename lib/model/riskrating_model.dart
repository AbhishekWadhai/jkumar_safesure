import 'dart:convert';

class RiskRating {
    String id;
    int value;
    String severity;
    String alertTimeline;
    String repeatWarning;
    int v;
    List<String>? escalationAlert;

    RiskRating({
        required this.id,
        required this.value,
        required this.severity,
        required this.alertTimeline,
        required this.repeatWarning,
        required this.v,
        this.escalationAlert,
    });

    factory RiskRating.fromRawJson(String str) => RiskRating.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory RiskRating.fromJson(Map<String, dynamic> json) => RiskRating(
        id: json["_id"],
        value: json["value"],
        severity: json["severity"],
        alertTimeline: json["alertTimeline"],
        repeatWarning: json["repeatWarning"],
        v: json["__v"],
        escalationAlert: json["escalationAlert"] == null ? [] : List<String>.from(json["escalationAlert"]!.map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "value": value,
        "severity": severity,
        "alertTimeline": alertTimeline,
        "repeatWarning": repeatWarning,
        "__v": v,
        "escalationAlert": escalationAlert == null ? [] : List<dynamic>.from(escalationAlert!.map((x) => x)),
    };
}
