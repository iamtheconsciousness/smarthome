// To parse this JSON data, do
//
//     final myLed = myLedFromJson(jsonString);

import 'dart:convert';

MyLed myLedFromJson(String str) => MyLed.fromJson(json.decode(str));

String myLedToJson(MyLed data) => json.encode(data.toJson());

class MyLed {
  MyLed({
    required this.room,
    required this.roomDetail,
    required this.name,
    required this.customer_id,
    required this.success,
  });

  List<String> room;
  List<RoomDetail> roomDetail;
  String name;
  String customer_id;

  int success;

  factory MyLed.fromJson(Map<String, dynamic> json) => MyLed(
    room: List<String>.from(json["room"].map((x) => x)),
    roomDetail: List<RoomDetail>.from(json["room_detail"].map((x) => RoomDetail.fromJson(x))),
    name: json["name"],
    customer_id: json["customer_id"],
    success: json["success"],
  );

  Map<String, dynamic> toJson() => {
    "room": List<dynamic>.from(room.map((x) => x)),
    "room_detail": List<dynamic>.from(roomDetail.map((x) => x.toJson())),
    "name": name,
    "customer_id": customer_id,
    "success": success,
  };
}

class RoomDetail {
  RoomDetail({
    required this.devices,
  });

  List<Device> devices;

  factory RoomDetail.fromJson(Map<String, dynamic> json) => RoomDetail(
    devices: List<Device>.from(json["devices"].map((x) => Device.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "devices": List<dynamic>.from(devices.map((x) => x.toJson())),
  };
}

class Device {
  Device({
    required this.component_id,
    required this.type,
  });

  String component_id;
  String type;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    component_id: json["component_id"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "component_id": component_id,
    "type": type,
  };
}
