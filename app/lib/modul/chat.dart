import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.seen,
    required this.username,
    required this.to,
    required this.message,
  });

  bool seen;
  String username;
  String to;
  String message;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        seen: json["seen"],
        username: json["username"],
        to: json["to"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "seen": seen,
        "username": username,
        "to": to,
        "message": message,
      };
}