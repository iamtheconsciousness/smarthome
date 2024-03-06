import 'package:flutter/material.dart';
import 'package:smarthome/schedule_pages/postAPIService.dart';
import 'package:smarthome/schedule_pages/schedule_form.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../drawer_widget.dart';
import 'schedule_model.dart';
import 'schedule_database.dart';
import 'scheduleCard.dart';

final postRequestService = PostRequestService('http://192.168.0.112');


class ScheduleMain extends StatefulWidget {
  @override
  _ScheduleMain createState() => _ScheduleMain();
}

class _ScheduleMain extends State<ScheduleMain> {
  final DbManagerSc dbManager = new DbManagerSc();

  S_Model? model;
  List<S_Model>? modelList;
  TextEditingController input1 = TextEditingController();
  TextEditingController input2 = TextEditingController();
  FocusNode? input1FocusNode;
  FocusNode? input2FocusNode;
  SharedPreferences? userData;
  String? username;
  String? customer_id;
  int? scheduleIdMainPage;

  @override
  void initState()  {
    input1FocusNode = FocusNode();
    input2FocusNode = FocusNode();
    getUserData();
    super.initState();
  }

  void getUserData() async {
    userData = await SharedPreferences.getInstance();
    scheduleIdMainPage=userData!.getInt('scheduleId');
    print("interrupt");
    setState(() {
      customer_id = userData!.getString('customer_id');
    });
  }


  @override
  void dispose() {
    input1FocusNode!.dispose();
    input2FocusNode!.dispose();
    super.dispose();
  }

  void onEnter(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sqlite Demo'),
      ),
      drawer: DrawerWidget(customer_id!),
      floatingActionButton: FloatingActionButton(
        onPressed: ()
    {
      print("set Clicked");

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduleForm(scheduleIdMainPage!,true,null,null,null,null,0,4286357222,'FFFFFFF',DateTime.now().toString(),DateTime.now().toString(),"morning",0))
      ).then((value) { setState(() {
        scheduleIdMainPage=userData!.getInt('scheduleId');
        print("Post set Clicked");
      });});


        },
    child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: FutureBuilder(
        future: dbManager.getModelList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            modelList = snapshot.data as List<S_Model>?;
            return ListView.builder(
              itemCount: modelList!.length,
              itemBuilder: (context, index) {
                S_Model? _model = modelList![index];
                return ItemCard(
                  model: _model,
                  input1: input1,
                  input2: input2,
                  onDeletePress: () async {
                    final body = {
                      'customer_id': customer_id,
                      'schedule_id': _model.schedule_id,
                    };
                    final response = await postRequestService.post(
                        'delete_schedule.php', body);
                    print("Delete");
                    dbManager.deleteModel(_model);
                    setState(() {});
                  },
                  onEditPress: () {
                    print("Edit");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ScheduleForm(_model.schedule_id!,false,_model.room!,_model.component_name!,_model.type.toString(),_model.schedule_name!,_model.state!,_model.variable!,_model.recurring,_model.date!,_model.time!,_model.schedule_name!,_model.add_state))
                    ).then((value) { setState(() {});});
                  },
                );
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

