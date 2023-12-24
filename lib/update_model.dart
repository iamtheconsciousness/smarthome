// To parse this JSON data, do
//
//     final update = updateFromJson(jsonString);

import 'dart:convert';

Update updateFromJson(String str) => Update.fromJson(json.decode(str));

String updateToJson(Update data) => json.encode(data.toJson());

class Update {
  Update({
    required this.success,
  });

  int success;

  factory Update.fromJson(Map<String, dynamic> json) => Update(
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
  };
}
