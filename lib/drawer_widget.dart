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

int? i;
final DbManager dbManager = new DbManager();
SharedPreferences? logindata;
String? table;

class DrawerWidget extends StatelessWidget {
  DrawerWidget(String tab){
    table=tab;
    print('hi');
    print(tab);

  }


    Widget build(BuildContext context){
      return Drawer(
          child: FutureBuilder(
          future: dbManager.getDistRooms(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Led> modelList = snapshot.data as List<Led>;
              return ListView.builder(
                  itemCount: modelList.length,
                  itemBuilder: (context, index) {
                    Led _room = modelList[index];
                    return TextButton(
                      child: Text(_room.room!),
                      onPressed: () {
                        if(_room.room!='Schedule' && _room.room!='Home Page') {
                          String rName=_room.room!;

                          String screenDataUrl ='https://theautohome.xyz/get_room.php?room=$rName&table=$table';
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
                              print(typeOne.length);
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
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),

      );
    }
  }
