// To parse this JSON data, do
//
//     final myLed = myLedFromJson(jsonString);

import 'dart:convert';

ReadTable myStructFromJson(String str) => ReadTable.fromJson(json.decode(str));

String myStructToJson(ReadTable data) => json.encode(data.toJson());

class ReadTable {
  ReadTable({
     this.led,
     this.success,
  });

  List<Led>? led;
  int? success;

  factory ReadTable.fromJson(Map<String, dynamic> json) => ReadTable(
    led: List<Led>.from(json["led"].map((x) => Led.fromJson(x))),
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "led": List<dynamic>.from(led!.map((x) => x.toJson())),
    "success": success,
  };
}

class Led {
  Led({
    this.id,
    this.state,
    this.room,
    this.variable,
    this.type,
    this.name,
  });

  String? id;
  String? state;
  String? room;
  String? variable;
  String? type;
  String? name;
  factory Led.fromJson(Map<String, dynamic> json) => Led(
    id: json["id"],
    state: json["state"],
    room: json["room"],
    variable: json["variable"],
    type: json["type"],
    name: json["name"]
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "state": state,
    "room": room,
    "variable": variable,
    "type": type,
    "name":name
  };
}


class LedRooms {
  LedRooms({
         this.room,
  });


  String? room;

  factory LedRooms.fromJson(Map<String, dynamic> json) => LedRooms(

    room: json["room"],
  );

  Map<String, dynamic> toJson() => {
        "room": room,
  };
}
