import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:smarthome/schedule_pages/postAPIService.dart';
import 'package:smarthome/schedule_pages/schedule_database.dart';
import 'package:smarthome/schedule_pages/schedule_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekday_selector/weekday_selector.dart';
import '../dataBase.dart';
import '../structure_model.dart';
import 'package:toggle_switch/toggle_switch.dart';
final postRequestService = PostRequestService('http://theautohome.xyz');

List<Led>? rooms;
List<Led>? items;
List _room = [];
List _items = [];
List tempItem = [];
Led? selectedLed;
String? scheduleName;
String? selectedType;
String? selectedName;
String? selectedRoom;
String? selectedItem;
int? state;
int? addState;
int variable = 3;
String week = '';
Color currentColor = Colors.limeAccent;
TextEditingController? textEditingController1;
TextEditingController? textEditingController2;
SharedPreferences? sP;
int? scheduleId;

FocusNode? input1FocusNode;
List<bool> values = List.filled(7, false);
TextEditingController? _controller3;
String dateValue = '';
String timeValue = '';
bool? queryType;

class ScheduleForm extends StatefulWidget {

  ScheduleForm(
      int _scheduleId,
      bool _queryType,
      String? _selectedRoom,
      String? _selectedItem,
      String? _selectedType,
      String? _selectedName,
      int? _state,
      int? _variable,
      String? _week,
      String? _dateValue,
      String? _timeValue,
      String? _scheduleName,
      int? _addState) {
    if(queryType == false){
      print("entered form");
    }
    scheduleName = _scheduleName;
    queryType = _queryType;
    selectedRoom = _selectedRoom;
    selectedItem = _selectedItem;
    selectedType = _selectedType;
    selectedName = _selectedName;
    state = _state;
    addState = _addState;
    scheduleId = _scheduleId;
    print("ScheduleID on Load : $scheduleId");
    print("Query type on Load : $queryType");
      if(queryType == false){
        variable=_variable!;
        print(_variable);
        print(selectedType);
      }

    dateValue = _dateValue!;
    timeValue = _timeValue!;
    print("Time on load $timeValue");
    print("week : $_week");

    if (_week! != "no") {
      for (int i = 0; i < 7; i++) {
        if (_week![i] == 'T') {
          values[i] = true;
        } else if (_week[i] == 'F') {
          values[i] = false;
        }
      }
    }
    textEditingController2 = TextEditingController(text: _scheduleName);
    textEditingController1 = TextEditingController(text: variable.toString());
    print('Hi 3');
    _room = [];
  }

  Function? onPressed;
  @override
  _ScheduleForm createState() => _ScheduleForm();
}

class _ScheduleForm extends State<ScheduleForm> {
  DbManager dbRoom = DbManager();
  DbManagerSc dbSchedule = DbManagerSc();
  String tempDate= DateTime.parse(dateValue).day.toString()+"-"+DateTime.parse(dateValue).month.toString()+"-"+DateTime.parse(dateValue).year.toString();
  String tempTime= DateTime.parse(timeValue).hour.toString()+':'+DateTime.parse(timeValue).minute.toString();

  void initState() {
    _controller3 = TextEditingController(text: DateTime.now().toString());
    print(DateTime.now().toString());
    getLists();
    super.initState();
  }

  Future getLists() async {
    tempItem = [];
    _items=[];
    sP = await SharedPreferences.getInstance();
    rooms = await dbRoom.getDistRooms();
    _room = [];
    for (int i = 0; i < rooms!.length; i++) {
      _room.add(rooms![i].room);
    }
    setState(() {});
    items = await dbRoom.getRoomWise(selectedRoom!);
    for (int i = 0; i < items!.length; i++) {
      tempItem.add(items![i].name);
    }
    _items = tempItem;
    if (queryType == false) {
      for (Led temp in items!) {
        if (temp.name == selectedItem) {
          selectedLed = temp;
          selectedType = temp.type;
          selectedName = temp.name;
          print("debug1");
          break;
        }
      }
    }
  }

  Future getItems() async {
    tempItem = [""];
    selectedItem = null;
    items = await dbRoom.getRoomWise(selectedRoom!);
    for (int i = 0; i < items!.length; i++) {
      print(items![i].name);
      tempItem.add(items![i].name);
    }
    selectedLed = null;
    setState(() {
      _items = tempItem;
    });
  }

  void openDatePicker(BuildContext context){
    BottomPicker.date(
      title:  "Date",
      titleStyle:  const TextStyle(
          fontWeight:  FontWeight.bold,
          fontSize:  15,
          color:  Colors.blue
      ),
      initialDateTime : DateTime.parse(dateValue),
      onSubmit: (index) {
        print("Hi from date onSubmit");

        dateValue=index.toString();
        tempDate= index.day.toString()+"-"+index.month.toString()+"-"+index.year.toString();
        week = 'no';
        for (int i = 0; i < 7; i++) {
          values[i] = false;
        }
        setState(() {
          print(tempDate);
        });
      },
      bottomPickerTheme: BottomPickerTheme.temptingAzure,
    ).show(context);
  }

  void openTimePicker (BuildContext context){
    BottomPicker.time(
      title: 'Time',
      titleStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.blue,
      ),
      bottomPickerTheme: BottomPickerTheme.blue,
      use24hFormat: false,
      initialTime: Time(
          minutes: DateTime.parse(timeValue).minute,
          hours: DateTime.parse(timeValue).hour
      ),
      onChange: (index){
      },
      onSubmit : (index) {
        print("Hi from time onSubmit");
        timeValue = index.toString();
        print(timeValue);
        tempTime = "${index.hour} : ${index.minute}";
        print(timeValue);
        setState(() {
          print(tempTime);
        });
      },
    ).show(context);
  }

  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Schedule'),
        ),
        body: Center(
            child: SafeArea(
          child: SingleChildScrollView(
              child: Column(children: [
            TextFormField(
              controller: textEditingController2,
              keyboardType: TextInputType.text,
              focusNode: input1FocusNode,
              decoration: const InputDecoration(hintText: "Enter Schedule Name"),
              onChanged: (value) {
                scheduleName = value;
              },
            ),
            if (_room.isNotEmpty)
              DropdownButton(
                hint: const Text('Select Room'),
                value: selectedRoom,
                items: _room.map((room) {
                  return DropdownMenuItem(value: room, child: Text(room));
                }).toList(),
                onChanged: (newRoom) {
                  setState(() {
                    selectedRoom = newRoom as String?;
                    _items.clear();
                    getItems();
                  });
                },
              ),
            if(_items.isNotEmpty)
            DropdownButton(
              hint: const Text('Select component'),
              value: selectedItem,
              items: _items.map((item) {
                return DropdownMenuItem(value: item, child: Text(item));
              }).toList(),
              onChanged: (newItem) {
                setState(() {
                  print("component part called");
                  selectedItem = newItem as String?;
                  for (Led temp in items!) {
                    if (temp.name == selectedItem) {
                      selectedLed = temp;
                      selectedType = temp.type;
                      selectedName = temp.name;
                      print("debug1");
                      switch (int.parse(selectedType!)) {
                        case 1:
                          break;
                        case 2:
                          break;
                        case 3:
                          break;
                        case 4:
                          break;
                        case 5:
                          break;
                        default:
                      }


                    }
                  }
                });
              },
            ),
            if (selectedType == '1')
              Column(mainAxisAlignment: MainAxisAlignment.center, children:   [
                Container(
                    child: Text(
                  selectedName!,
                  style: const TextStyle(
                    color: Colors.yellow,
                  ),
                )),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ToggleSwitch(
                    minWidth: 50.0,
                    minHeight: 30.0,
                    initialLabelIndex: state,
                    cornerRadius: 10.0,
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    icons: [
                      FontAwesomeIcons.lightbulb,
                      FontAwesomeIcons.solidLightbulb,
                    ],
                    iconSize: 30.0,
                    activeBgColors: [
                      [Colors.black45, Colors.black26],
                      [Colors.yellow, Colors.orange]
                    ],
                    animate: true,
                    // with just animate set to true, default curve = Curves.easeIn
                    curve: Curves.bounceInOut,
                    // animate must be set to true when using custom curve
                    onToggle: (val) {
                      state = val;
                      print("ScheduleID on switch click : $scheduleId");
                    },
                  ),
                ),
                WeekdaySelector(
                  onChanged: (int day) {
                    week="";
                    setState(() {
                      _controller3!.text = '';

                      // DateTime.sunday constant integer value is 7.
                      final index = day % 7;

                      values[index] = !values[index];
                      print(values[0]);
                    });
                  },
                  values: values,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    openDatePicker(context);
                  },
                  child:  Text(tempDate),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    print("inside onpress timer");
                    openTimePicker(context);
                    print("after onpress timer");
                  },
                  child:  Text(tempTime),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      onPressed: () {
                        _items.clear();
                        _room.clear();
                        Navigator.of(context).pop();
                      },
                      color: Colors.blueGrey,
                      child: const Text(
                        "Cancel",
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        print("ScheduleID on Set Press : $scheduleId");
                        if (queryType == true) {
                          scheduleId = (scheduleId!+1)!;
                          print("ScheduleID post increament : $scheduleId");
                          sP!.setInt('scheduleId', scheduleId!);
                          print("Audit");
                        }
                        if (week != 'no') {
                          week = "";
                          for (int i = 0; i < 7; i++) {
                            if (values[i] == true) {
                              week = week + 'T';
                            } else if (values[i] == false) {
                              week = week + 'F';
                            }
                          }
                          if(week == "FFFFFFF") {
                            week="no";
                          }
                        }
                        print("update state : $state");
                        print("ScheduleID before set : $scheduleId");
                        print("week on insert : $week");
                        print(selectedItem);
                        print(_items.length);
                        print(selectedLed);

                        S_Model tempModel = S_Model(
                            idSchedule: scheduleId!,
                            scheduleName: scheduleName!,
                            id: int.parse(selectedLed!.id!),
                            name: selectedLed!.name,
                            state: state,
                            room: selectedLed!.room,
                            variable: variable,
                            type: int.parse(selectedLed!.type!),
                            date: dateValue,
                            time: timeValue,
                            disabled: 0,
                            recurring: week);

                        final body = {
                          'table': 'schedule',
                          'idSchedule': scheduleId,
                          'scheduleName': scheduleName,
                          'id': selectedLed!.id,
                          'name': selectedLed!.name,
                          'state': state,
                          'room': selectedLed!.room,
                          'variable': variable,
                          'type': selectedLed!.type,
                          'flag': '1',
                          'date': dateValue,
                          'time': timeValue,
                          'disabled': 0,
                          'recurring': week,
                        };

                        if (queryType == true) {
                          print(queryType);
                          print("Insert");
                          print(dateValue);
                          print(timeValue);
                          print(scheduleId);
                          dbSchedule.insertModel(tempModel);
                          final response = await postRequestService.post(
                              'insert_schedule.php', body);
                          print(response.statusCode);
                          if (response.statusCode == 200) {
                            print("Post success response");
                            print(response.body.toString());
                            // The post was created successfullyz
                          } else {
                            print("Post failure response");
                            print(response.body.toString());
                            // An error occurred
                          }
                        } else if (queryType == false) {
                          print(queryType);
                          print("update");
                          print(scheduleName);
                          print(dateValue);
                          print(timeValue);
                          print(scheduleId);
                          dbSchedule.updateModel(tempModel);
                          final response = await postRequestService.post(
                              'update_schedule.php', body);
                              print(response.statusCode);
                          if (response.statusCode == 200) {
                            print("Post success response");
                            dbSchedule.updateModel(tempModel);
                            print(response.body.toString());
                            // The post was created successfullyz
                          } else {
                            print("Post failure response");
                            print(response.body.toString());
                            // An error occurred
                          }
                        }

                        setState(() {});
                        _items.clear();
                        _room.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text("Set"),
                      color: Colors.blue,
                    )
                  ],
                ),
              ]),
            if (selectedType == '2')
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        child: Text(
                      selectedName!,
                      style: const TextStyle(
                        color: Colors.yellow,
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: ToggleSwitch(
                        minWidth: 50.0,
                        minHeight: 30.0,
                        initialLabelIndex: state,
                        cornerRadius: 10.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        icons: [
                          FontAwesomeIcons.lightbulb,
                          FontAwesomeIcons.solidLightbulb,
                        ],
                        iconSize: 30.0,
                        activeBgColors: [
                          [Colors.black45, Colors.black26],
                          [Colors.yellow, Colors.orange]
                        ],
                        animate: true,
                        // with just animate set to true, default curve = Curves.easeIn
                        curve: Curves.bounceInOut,
                        // animate must be set to true when using custom curve
                        onToggle: (val) {
                          state = val;
                        },
                      ),
                    ),
                    Slider(
                        value: variable.toDouble(),
                        min: 0,
                        max: 5,
                        activeColor: Colors.blue,
                        onChanged: (double value) {
                          setState(() {
                            variable = value.round();
                          });
                        }),
                    WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          print(dateValue);
                          _controller3!.text = '';

                          // DateTime.sunday constant integer value is 7.
                          final index = day % 7;
                          // We "flip" the value in this example, but you may also
                          // perform validation, a DB write, an HTTP call or anything
                          // else before you actually flip the value,
                          // it's up to your app's needs.
                          values[index] = !values[index];
                        });
                      },
                      values: values,
                    ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openDatePicker(context);
                          },
                          child:  Text(tempDate),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openTimePicker(context);
                          },
                          child:  Text(tempTime),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                print("ScheduleID on Set Press : $scheduleId");
                                if (queryType == true) {
                                  scheduleId = (scheduleId!+1);
                                  print("ScheduleID post increament : $scheduleId");
                                  sP!.setInt('scheduleId', scheduleId!);
                                  print("Audit");
                                }
                                if (week != 'no') {
                                  for (int i = 0; i < 7; i++) {
                                    if (values[i] == true) {
                                      week = week + 'T';
                                    } else if (values[i] == false) {
                                      week = week + 'F';
                                    }
                                  }
                                }
                                print("update state : $state");
                                print("ScheduleID before set : $scheduleId");

                                S_Model tempModel = S_Model(
                                    idSchedule: scheduleId,
                                    scheduleName: scheduleName,
                                    id: int.parse(selectedLed!.id!),
                                    name: selectedLed!.name,
                                    state: state,
                                    room: selectedLed!.room,
                                    variable: variable,
                                    type: int.parse(selectedLed!.type!),
                                    date: dateValue,
                                    time: timeValue,
                                    disabled: 1,
                                    recurring: week);

                                final body = {
                                  'table': 'schedule',
                                  'idSchedule': scheduleId,
                                  'scheduleName': scheduleName,
                                  'id': selectedLed!.id,
                                  'name': selectedLed!.name,
                                  'state': state,
                                  'room': selectedLed!.room,
                                  'variable': variable,
                                  'type': selectedLed!.type,
                                  'flag': '1',
                                  'date': dateValue,
                                  'time': timeValue,
                                  'disabled': 1,
                                  'recurring': week,
                                };

                                if (queryType == true) {
                                  print(queryType);
                                  print("Insert");
                                  print(dateValue);
                                  print(scheduleId);
                                  dbSchedule.insertModel(tempModel);
                                  final response = await postRequestService.post(
                                      'insert_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                } else if (queryType == false) {
                                  print(queryType);
                                  print("update");
                                  print(scheduleName);
                                  print(dateValue);
                                  print(timeValue);
                                  print(scheduleId);
                                  dbSchedule.updateModel(tempModel);
                                  final response = await postRequestService.post(
                                      'update_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                }

                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Set"),
                              color: Colors.blue,
                            )
                          ],
                        ),
                  ])),
            if (selectedType == '3')
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        child: Text(
                      selectedName!,
                      style: const TextStyle(
                        color: Colors.yellow,
                      ),
                    )),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      child: ToggleSwitch(
                        minWidth: 50.0,
                        minHeight: 30.0,
                        initialLabelIndex: state,
                        cornerRadius: 10.0,
                        activeFgColor: Colors.white,
                        inactiveBgColor: Colors.grey,
                        inactiveFgColor: Colors.white,
                        totalSwitches: 2,
                        icons: [
                          FontAwesomeIcons.lightbulb,
                          FontAwesomeIcons.solidLightbulb,
                        ],
                        iconSize: 30.0,
                        activeBgColors: [
                          [Colors.black45, Colors.black26],
                          [Colors.yellow, Colors.orange]
                        ],
                        animate: true,
                        // with just animate set to true, default curve = Curves.easeIn
                        curve: Curves.bounceInOut,
                        // animate must be set to true when using custom curve
                        onToggle: (val) {
                          state = val;
                        },
                      ),
                    ),
                    ColorPicker(
                      pickerColor: currentColor,
                      onColorChanged: (Color color) =>
                          setState(() => currentColor = color),
                      colorPickerWidth: 250.0,
                      pickerAreaHeightPercent: 0.7,
                      enableAlpha: true,
                      displayThumbColor: true,
                      showLabel: true,
                      paletteType: PaletteType.hsl,
                      pickerAreaBorderRadius: const BorderRadius.only(
                        topLeft: const Radius.circular(2.0),
                        topRight: const Radius.circular(2.0),
                      ),
                    ),
                    WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          _controller3!.text = '';

                          // DateTime.sunday constant integer value is 7.
                          final index = day % 7;
                          // We "flip" the value in this example, but you may also
                          // perform validation, a DB write, an HTTP call or anything
                          // else before you actually flip the value,
                          // it's up to your app's needs.
                          values[index] = !values[index];
                        });
                      },
                      values: values,
                    ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openDatePicker(context);
                          },
                          child:  Text(tempDate),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openTimePicker(context);
                          },
                          child:  Text(tempTime),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                print("ScheduleID on Set Press : $scheduleId");
                                if (queryType == true) {
                                  scheduleId=scheduleId!+1;
                                  print("ScheduleID post increament : $scheduleId");
                                  sP!.setInt('scheduleId', scheduleId!);
                                  print("Audit");
                                }
                                if (week != 'no') {
                                  for (int i = 0; i < 7; i++) {
                                    if (values[i] == true) {
                                      week = week + 'T';
                                    } else if (values[i] == false) {
                                      week = week + 'F';
                                    }
                                  }
                                }
                                print("update state : $state");
                                print("ScheduleID before set : $scheduleId");

                                S_Model tempModel = S_Model(
                                    idSchedule: scheduleId,
                                    scheduleName: scheduleName,
                                    id: int.parse(selectedLed!.id!),
                                    name: selectedLed!.name,
                                    state: state,
                                    room: selectedLed!.room,
                                    variable: variable!,
                                    type: int.parse(selectedLed!.type!),
                                    date: dateValue,
                                    time: timeValue,
                                    disabled: 1,
                                    recurring: week);

                                final body = {
                                  'table': 'schedule',
                                  'idSchedule': scheduleId,
                                  'scheduleName': scheduleName,
                                  'id': selectedLed!.id,
                                  'name': selectedLed!.name,
                                  'state': state,
                                  'room': selectedLed!.room,
                                  'variable': variable,
                                  'type': selectedLed!.type,
                                  'flag': '1',
                                  'date': dateValue,
                                  'time': timeValue,
                                  'disabled': 1,
                                  'recurring': week,
                                };

                                if (queryType == true) {
                                  print(queryType);
                                  print("Insert");
                                  print(dateValue);
                                  print(scheduleId);
                                  dbSchedule.insertModel(tempModel);
                                  final response = await postRequestService.post(
                                      'insert_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                } else if (queryType == false) {
                                  print(queryType);
                                  print("update");
                                  print(scheduleName);
                                  print(dateValue);
                                  print(timeValue);
                                  print(scheduleId);
                                  dbSchedule.updateModel(tempModel);
                                  final response = await postRequestService.post(
                                      'update_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                }

                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Set"),
                              color: Colors.blue,
                            )
                          ],
                        ),
                  ])),
            if (selectedType == '4')
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        child: Text(
                      selectedName!,
                      style: const TextStyle(
                        color: Colors.yellow,
                      ),
                    )),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ToggleSwitch(
                            minWidth: 50.0,
                            minHeight: 30.0,
                            initialLabelIndex: state,
                            cornerRadius: 10.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            icons: [
                              FontAwesomeIcons.lightbulb,
                              FontAwesomeIcons.solidLightbulb,
                            ],
                            iconSize: 30.0,
                            activeBgColors: [
                              [Colors.black45, Colors.black26],
                              [Colors.yellow, Colors.orange]
                            ],
                            animate: true,
                            // with just animate set to true, default curve = Curves.easeIn
                            curve: Curves.bounceInOut,
                            // animate must be set to true when using custom curve
                            onToggle: (val) {
                              state = val;
                            },
                          ),
                        ),
                      ToggleSwitch(
                      minWidth: 50.0,
                      minHeight: 30.0,
                      initialLabelIndex: addState,
                      cornerRadius: 10.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.grey,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      icons: [
                      FontAwesomeIcons.volumeMute,
                      FontAwesomeIcons.volumeUp,
                      ],
                      iconSize: 30.0,
                      activeBgColors: [[Colors.yellow, Colors.orange], [Colors.yellow, Colors.orange]],
                      animate: true, // with just animate set to true, default curve = Curves.easeIn
                      curve: Curves.bounceInOut, // animate must be set to true when using custom curve
                      onToggle: (state) {
                        addState=state;
                      },
                      ),
                    TextFormField(
                      controller: textEditingController1,
                      keyboardType: TextInputType.number,
                      focusNode: input1FocusNode,
                      decoration:
                      const InputDecoration(hintText: "Enter Channel Number"),
                      onChanged: (value) {
                        variable = int.parse(value);
                        print("Channel Number : $variable");
                      },
                    ),
                    WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          _controller3!.text = '';
                          // DateTime.sunday constant integer value is 7.
                          final index = day % 7;
                          // We "flip" the value in this example, but you may also
                          // perform validation, a DB write, an HTTP call or anything
                          // else before you actually flip the value,
                          // it's up to your app's needs.
                          values[index] = !values[index];
                        });
                      },
                      values: values,
                    ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openDatePicker(context);
                          },
                          child:  Text(tempDate),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openTimePicker(context);
                          },
                          child:  Text(tempTime),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                print("ScheduleID on Set Press : $scheduleId");
                                if (queryType == true) {
                                  scheduleId=scheduleId!+1;
                                  print("ScheduleID post increament : $scheduleId");
                                  sP!.setInt('scheduleId', scheduleId!);
                                  print("Audit");
                                }
                                if (week != 'no') {
                                  for (int i = 0; i < 7; i++) {
                                    if (values[i] == true) {
                                      week = week + 'T';
                                    } else if (values[i] == false) {
                                      week = week + 'F';
                                    }
                                  }
                                }
                                print("update state : $state");
                                print("ScheduleID before set : $scheduleId");

                                S_Model tempModel = S_Model(
                                    idSchedule: scheduleId,
                                    scheduleName: scheduleName,
                                    id: int.parse(selectedLed!.id!),
                                    name: selectedLed!.name,
                                    state: state,
                                    room: selectedLed!.room,
                                    variable: variable,
                                    type: int.parse(selectedLed!.type!),
                                    date: dateValue,
                                    time: timeValue,
                                    disabled: 1,
                                    recurring: week,
                                    addState: addState);

                                final body = {
                                  'table': 'schedule',
                                  'idSchedule': scheduleId,
                                  'scheduleName': scheduleName,
                                  'id': selectedLed!.id,
                                  'name': selectedLed!.name,
                                  'state': state,
                                  'room': selectedLed!.room,
                                  'variable': variable,
                                  'type': selectedLed!.type,
                                  'flag': '1',
                                  'date': dateValue,
                                  'time': timeValue,
                                  'disabled': 1,
                                  'recurring': week,
                                  'addState' : addState
                                };

                                if (queryType == true) {
                                  print(queryType);
                                  print("Insert");
                                  print(dateValue);
                                  print(scheduleId);
                                  dbSchedule.insertModel(tempModel);
                                  final response = await postRequestService.post(
                                      'insert_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                } else if (queryType == false) {
                                  print(queryType);
                                  print("update");
                                  print(scheduleName);
                                  print(dateValue);
                                  print(timeValue);
                                  print(scheduleId);
                                  dbSchedule.updateModel(tempModel);
                                  final response = await postRequestService.post(
                                      'update_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                }

                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Set"),
                              color: Colors.blue,
                            )
                          ],
                        ),
                  ])),
            if (selectedType == '5')
              Container(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Container(
                        child: Text(
                      selectedName!,
                      style: const TextStyle(
                        color: Colors.yellow,
                      ),
                    )),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ToggleSwitch(
                            minWidth: 50.0,
                            minHeight: 30.0,
                            initialLabelIndex: state,
                            cornerRadius: 10.0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: Colors.grey,
                            inactiveFgColor: Colors.white,
                            totalSwitches: 2,
                            icons: [
                              FontAwesomeIcons.lightbulb,
                              FontAwesomeIcons.solidLightbulb,
                            ],
                            iconSize: 30.0,
                            activeBgColors: [
                              [Colors.black45, Colors.black26],
                              [Colors.yellow, Colors.orange]
                            ],
                            animate: true,
                            // with just animate set to true, default curve = Curves.easeIn
                            curve: Curves.bounceInOut,
                            // animate must be set to true when using custom curve
                            onToggle: (val) {
                              state = val;
                            },
                          ),
                        ),
                    TextFormField(
                      controller: textEditingController1,
                      keyboardType: TextInputType.number,
                      focusNode: input1FocusNode,
                      decoration:
                          const InputDecoration(hintText: "Enter Temperature"),
                      onChanged: (value) {
                        variable = int.parse(value);
                        print("temperature value : $variable");
                      },
                    ),
                    WeekdaySelector(
                      onChanged: (int day) {
                        setState(() {
                          _controller3!.text = '';

                          // DateTime.sunday constant integer value is 7.
                          final index = day % 7;
                          // We "flip" the value in this example, but you may also
                          // perform validation, a DB write, an HTTP call or anything
                          // else before you actually flip the value,
                          // it's up to your app's needs.
                          values[index] = !values[index];
                        });
                      },
                      values: values,
                    ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openDatePicker(context);
                          },
                          child:  Text(tempDate),
                        ),
                        TextButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            openTimePicker(context);
                          },
                          child:  Text(tempTime),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blueGrey,
                              child: const Text(
                                "Cancel",
                              ),
                            ),
                            MaterialButton(
                              onPressed: () async {
                                print("ScheduleID on Set Press : $scheduleId");
                                if (queryType == true) {
                                  scheduleId=scheduleId!+1;
                                  print("ScheduleID post increament : $scheduleId");
                                  sP!.setInt('scheduleId', scheduleId!);
                                  print("Audit");
                                }
                                if (week != 'no') {
                                  for (int i = 0; i < 7; i++) {
                                    if (values[i] == true) {
                                      week = week + 'T';
                                    } else if (values[i] == false) {
                                      week = week + 'F';
                                    }
                                  }
                                }
                                print("update state : $state");
                                print("ScheduleID before set : $scheduleId");

                                S_Model tempModel = S_Model(
                                    idSchedule: scheduleId,
                                    scheduleName: scheduleName,
                                    id: int.parse(selectedLed!.id!),
                                    name: selectedLed!.name,
                                    state: state,
                                    room: selectedLed!.room,
                                    variable: variable,
                                    type: int.parse(selectedLed!.type!),
                                    date: dateValue,
                                    time: timeValue,
                                    disabled: 1,
                                    recurring: week);

                                final body = {
                                  'table': 'schedule',
                                  'idSchedule': scheduleId,
                                  'scheduleName': scheduleName,
                                  'id': selectedLed!.id,
                                  'name': selectedLed!.name,
                                  'state': state,
                                  'room': selectedLed!.room,
                                  'variable': variable,
                                  'type': selectedLed!.type,
                                  'flag': '1',
                                  'date': dateValue,
                                  'time': timeValue,
                                  'disabled': 1,
                                  'recurring': week,
                                };

                                if (queryType == true) {
                                  print(queryType);
                                  print("Insert");
                                  print(dateValue);
                                  print(scheduleId);
                                  dbSchedule.insertModel(tempModel);
                                  final response = await postRequestService.post(
                                      'insert_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                } else if (queryType == false) {
                                  print(queryType);
                                  print("update");
                                  print(scheduleName);
                                  print(dateValue);
                                  print(timeValue);
                                  print(scheduleId);
                                  dbSchedule.updateModel(tempModel);
                                  final response = await postRequestService.post(
                                      'update_schedule.php', body);

                                  if (response.statusCode == 201) {
                                    print("Post success response");
                                    // The post was created successfullyz
                                  } else {
                                    print("Post failure response");
                                    print(response.body.toString());
                                    // An error occurred
                                  }
                                }

                                setState(() {});
                                Navigator.of(context).pop();
                              },
                              child: const Text("Set"),
                              color: Colors.blue,
                            )
                          ],
                        ),
                  ]))
          ])),
        )));
  }
}
