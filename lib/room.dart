import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smarthome/Dialog.dart';
import 'structure_model.dart';
import 'drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_update.dart';


String? room_name;
List<Led> typeOne=[];
List<Led> typeTwo=[];
List<Led> typeThree=[];
List<Led> typeFour=[];
List<Led> typeFive=[];


class Custom extends StatefulWidget {

  Custom(String room, List<Led> one,two,three,four,five)
  {
    room_name=room;

    typeOne=one;
    typeTwo=two;
    typeThree=three;
    typeFour=four;
    typeFive=five;


  }

  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  SharedPreferences? logindata;
  String? username;
  String? table;


  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }
  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata?.getString('username');
      table = logindata?.getString('table');


    });
  }


  int val=5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Hello'),
      ),
      drawer: DrawerWidget(table!),
      body :
      SafeArea(
       child:SingleChildScrollView(
        child: Column(
              children : [
                     ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: typeOne.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Container(
                                        child: Text(typeOne[index].name!,
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(16.0),

                                      child: ToggleSwitch(
                                        minWidth: 50.0,
                                        minHeight: 30.0,
                                        initialLabelIndex: int.parse(typeOne[index].state!),
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
                                        onToggle: (state) {
                                          String id=typeOne[index].id!;
                                          String updateStateUrl ='https://theautohome.xyz/update.php?table=$table&id=$id&state=$state';
                                          update_services.getAccess(updateStateUrl).then((tab)  async{

                                          });

                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }
                        ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: typeTwo.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(typeTwo[index].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),

                              child: ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 30.0,
                                initialLabelIndex: int.parse(typeTwo[index].state!),
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
                                onToggle: (state) {
                                  String id=typeTwo[index].id!;
                                  String updateStateUrl ='https://theautohome.xyz/update.php?table=$table&id=$id&state=$state';
                                  update_services.getAccess(updateStateUrl).then((tab)  async{
                                  });
                                },
                              ),
                            ),
                            Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .all<Color>(Colors.blue),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (context) {
                                          return DialogBoxOne(typeTwo[index].id!,table!).dialog(
                                            context: context,
                                          );
                                        });
                                  },
                                  child: Icon(Icons.more_vert),
                                )
                            )
                          ],
                        ),
                      );
                    }
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: typeThree.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(typeThree[index].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),

                              child: ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 30.0,
                                initialLabelIndex: int.parse(typeThree[index].state!),
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
                                onToggle: (state) {
                                  String id=typeThree[index].id!;
                                  String updateStateUrl ='https://theautohome.xyz/update.php?table=$table&id=$id&state=$state';
                                  update_services.getAccess(updateStateUrl).then((tab)  async{
                                  });
                                },
                              ),
                            ),
                            Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .all<Color>(Colors.blue),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (context) {
                                          return DialogBoxTwo(typeThree[index].id!,table!).dialog(
                                            context: context,
                                          );
                                        });
                                  },
                                  child: Icon(Icons.more_vert),
                                )
                            )
                          ],
                        ),
                      );
                    }
                ),

                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: typeFour.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(typeFour[index].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),

                              child: ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 30.0,
                                initialLabelIndex: int.parse(typeFour[index].state!),
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
                                onToggle: (state) {
                                  String id=typeFour[index].id!;
                                  if(state==0){
                                    String updateFlagUrl ='https://theautohome.xyz/update_flag.php?table=$table&id=$id&flag=0';
                                    update_services.getAccess(updateFlagUrl).then((tab)  async{
                                    });
                                  }
                                  String updateStateUrl ='https://theautohome.xyz/update.php?table=$table&id=$id&state=$state';
                                  print(updateStateUrl);
                                  update_services.getAccess(updateStateUrl).then((tab)  async{
                                  });
                                  },
                              ),
                            ),
                            Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .all<Color>(Colors.blue),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (context) {
                                          return DialogBoxThree(typeFour[index].id!,table!).dialog(
                                            context: context,
                                          );
                                        });
                                  },
                                  child: Icon(Icons.more_vert),
                                )
                            )
                          ],
                        ),
                      );
                    }
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: typeFive.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Container(
                                child: Text(typeFive[index].name!,
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                )
                            ),
                            Container(
                              padding: EdgeInsets.all(16.0),

                              child: ToggleSwitch(
                                minWidth: 50.0,
                                minHeight: 30.0,
                                initialLabelIndex: int.parse(typeFive[index].state!),
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
                                onToggle: (state) {
                                  String id=typeFive[index].id!;
                                  if(state==0){
                                    String updateVariableUrl ='https://theautohome.xyz/update_variable.php?table=$table&id=$id&variable=24';
                                    update_services.getAccess(updateVariableUrl).then((tab)  async{
                                    });
                                  }
                                  String updateStateUrl ='https://theautohome.xyz/update.php?table=$table&id=$id&state=$state';
                                  update_services.getAccess(updateStateUrl).then((tab)  async{
                                  });
                                  },
                              ),
                            ),
                            Container(
                                child: TextButton(
                                  style: ButtonStyle(
                                    foregroundColor: MaterialStateProperty
                                        .all<Color>(Colors.blue),
                                  ),
                                  onPressed: () {
                                    showDialog(context: context,
                                        builder: (context) {
                                          return DialogBoxFour(typeFive[index].id!,table!).dialog(
                                            context: context,
                                          );
                                        });
                                  },
                                  child: Icon(Icons.more_vert),
                                )
                            )
                          ],
                        ),
                      );
                    }
                ),
              ]
            ),
          )

          ),

        );
      }
    }

