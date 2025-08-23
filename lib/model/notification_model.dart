import 'dart:convert';

class NotificationModel {
  bool success;
  List<Notification> notifications;

  NotificationModel({
    required this.success,
    required this.notifications,
  });

  factory NotificationModel.fromRawJson(String str) =>
      NotificationModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        success: json["success"],
        notifications: List<Notification>.from(
            json["notifications"].map((x) => Notification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "notifications":
            List<dynamic>.from(notifications.map((x) => x.toJson())),
      };
}

class Notification {
  String id;
  String userId;
  String title;
  String message;
  bool isRead;
  String? source;
  String createdAt;
  int v;

  Notification({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.isRead,
    this.source,
    required this.createdAt,
    required this.v,
  });

  factory Notification.fromRawJson(String str) =>
      Notification.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Notification.fromJson(Map<String, dynamic> json) => Notification(
        id: json["_id"],
        userId: json["userId"],
        title: json["title"],
        message: json["message"],
        isRead: json["isRead"],
        source: json["source"],
        createdAt: json["createdAt"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "title": title,
        "message": message,
        "isRead": isRead,
        "source": source,
        "createdAt": createdAt,
        "__v": v,
      };
}
