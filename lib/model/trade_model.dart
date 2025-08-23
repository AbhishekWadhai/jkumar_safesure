import 'dart:convert';

class Trade {
  String id;
  String tradeTypes;
  int v;

  Trade({
    required this.id,
    required this.tradeTypes,
    required this.v,
  });

  factory Trade.fromRawJson(String str) => Trade.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Trade.fromJson(Map<String, dynamic> json) => Trade(
        id: json["_id"],
        tradeTypes: json["tradeTypes"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "tradeTypes": tradeTypes,
        "__v": v,
      };
}
