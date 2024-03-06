class S_Model {
  int? schedule_id;
  String? schedule_name;
  int? component_id;
  String? component_name;
  int? state;
  String? room;
  int? variable;
  int? type;
  String? date;
  String? time;
  int? disabled;
  String? recurring;
  int? add_state;

  S_Model({required this.schedule_id, required this.schedule_name, required this.component_id,required this.component_name, required this.state, required this.room,required this.variable,
    required this.type,  required this.date, required this.time,required this.disabled, required this.recurring, this.add_state});

  S_Model fromJson(json) {
    return S_Model(
        schedule_id: json['schedule_id'], schedule_name: json['schedule_name'], component_id: json['component_id'],component_name: json['component_name'], state: json['state'], room: json['room'], variable: json['variable'],
        type: json['type'], date: json['date'], time: json['time'], disabled: json['disabled'], recurring: json['recurring'], add_state: json['add_state']);
  }
  Map<String, dynamic> toJson() {
    return {'schedule_id': schedule_id, 'schedule_name': schedule_name, 'component_id': component_id, 'component_name': component_name,  'state': state, 'room': room, 'variable': variable,
      'type': type,  'date': date,  'time': time, 'disabled': disabled, 'recurring': recurring, 'add_state': add_state};
  }
}