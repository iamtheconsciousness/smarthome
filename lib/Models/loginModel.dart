// To parse this JSON data, do
//
//     final myLed = myLedFromJson(jsonString);

import 'dart:convert';

ReadLogin myStructFromJson(String str) => ReadLogin.fromJson(json.decode(str));

String myStructToJson(ReadLogin data) => json.encode(data.toJson());

class ReadLogin {
  ReadLogin({
    required this.access,
    this.success,
    this.refresh
  });

  String? access;
  String? refresh;
  int? success;

  factory ReadLogin.fromJson(Map<String, dynamic> json) => ReadLogin(
    access: json["access_token"],
    refresh: json["refresh_token"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "access_token": access,
    "refresh_token":refresh,
    "success": success
  };
}