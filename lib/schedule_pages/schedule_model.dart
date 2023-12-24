class S_Model {
  int? idSchedule;
  String? scheduleName;
  int? id;
  String? name;
  int? state;
  String? room;
  int? variable;
  int? type;
  String? date;
  String? time;
  int? disabled;
  String? recurring;
  int? addState;

  S_Model({required this.idSchedule, required this.scheduleName, required this.id,required this.name, required this.state, required this.room,required this.variable,
    required this.type,  required this.date, required this.time,required this.disabled, required this.recurring, this.addState});

  S_Model fromJson(json) {
    return S_Model(
        idSchedule: json['idSchedule'], scheduleName: json['scheduleName'], id: json['id'],name: json['name'], state: json['state'], room: json['room'], variable: json['variable'],
        type: json['type'], date: json['date'], time: json['time'], disabled: json['disabled'], recurring: json['recurring'], addState: json['addState']);
  }
  Map<String, dynamic> toJson() {
    return {'idSchedule': idSchedule, 'scheduleName': scheduleName, 'id': id, 'name': name,  'state': state, 'room': room, 'variable': variable,
      'type': type,  'date': date,  'time': time, 'disabled': disabled, 'recurring': recurring, 'addState': addState};
  }
}