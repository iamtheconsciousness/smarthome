import 'package:flutter/material.dart';
import 'package:smarthome/schedule_pages/schedule.dart';
import 'structure_service.dart';
import 'structure_model.dart';
import 'room.dart';
import 'dataBase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

var type=[1,2,3];
List<Led> roomData=[];
List<Led> typeOne=[];
List<Led> typeTwo=[];
List<Led> typeThree=[];
List<Led> typeFour=[];
List<Led> typeFive=[];
String? customer_id;

int? i;
final DbManager dbManager = new DbManager();
SharedPreferences? logindata;

class DrawerWidget extends StatelessWidget {
  DrawerWidget(String _customer_id){
  customer_id=_customer_id;
  }


  Widget build(BuildContext context){
    return Drawer(
      child: FutureBuilder(
        future: dbManager.getDistRooms(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print("has data");
            List<Led> modelList = snapshot.data as List<Led>;
            print("length");
            print(modelList.length);
            return ListView.builder(
                itemCount: modelList.length,
                itemBuilder: (context, index) {
                  print("length");
                  print(modelList.length);

                  Led _room = modelList[index];
                  return TextButton(
                    child: Text(_room.room!),
                    onPressed: () {
                      if(_room.room!='Schedule' && _room.room!='Home Page') {
                        String rName=_room.room!;
                        String screenDataUrl ='http://192.168.0.112/get_room.php?customer_id=$customer_id&room=$rName';
                        print(screenDataUrl);

                        struct_services.getAccess(screenDataUrl).then((tab)  async{
                          roomData=tab!;
                          typeOne=[];
                          typeTwo=[];
                          typeThree=[];
                          typeFour=[];
                          typeFive=[];

                          if(roomData.isNotEmpty) {
                            int idxOne=0,idxTwo=0,idxThree=0,idxFour=0,idxFive=0;
                            for ( i = 0; i! < roomData.length; i=i!+1) {

                              if (roomData[i!].type == "1") {


                                typeOne.insert(idxOne,roomData[i!]);
                                idxOne++;
                              }
                              else if(roomData[i!].type == "2")
                              {
                                typeTwo.insert(idxTwo,roomData[i!]);
                                idxTwo++;
                              }
                              else if(roomData[i!].type == "3")
                              {
                                print(roomData[i!].room);
                                print(roomData[i!].component_name);
                                print(roomData[i!].state);
                                print(roomData[i!].component_id);
                                print(roomData[i!].variable);
                                print(roomData[i!].type);

                                typeThree.insert(idxThree,roomData[i!]);
                                idxThree++;
                              }
                              else if(roomData[i!].type == "4")
                              {
                                typeFour.insert(idxFour,roomData[i!]);
                                idxFour++;
                              }
                              else if(roomData[i!].type == "5")
                              {
                                typeFive.insert(idxFive,roomData[i!]);
                                idxFive++;
                              }

                            }
                            print('maaaaaaain');
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Custom(_room.room!,typeOne,typeTwo,typeThree,typeFour,typeFive)),(route) => false,
                            );
                          }
                        });

                      }
                      else if(_room.room=='Schedule'){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ScheduleMain()),(route) => false,
                        );
                      }
                      else if(_room.room=='Home Page'){
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyDashboard()),(route) => false,
                        );
                      }

                    },
                  );
                });
          }
          else
          {
            print("dont have data");

          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),

    );
  }
}
