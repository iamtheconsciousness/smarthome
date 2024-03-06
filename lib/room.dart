import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smarthome/Dialog.dart';
import 'structure_model.dart';
import 'drawer_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'service_update.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';


String brokerAddress = '34.131.188.212';
int port = 8883;
String brokerUsername = 'vaibhavkumar';
String brokerPassword = 'Peace@-1O1';

String? room_name;
List<Led> typeOne=[];
List<Led> typeTwo=[];
List<Led> typeThree=[];
List<Led> typeFour=[];
List<Led> typeFive=[];




class Custom extends StatefulWidget {

  Custom(String? room,List<Led>? one,List<Led>? two,List<Led>? three,List<Led> four,List<Led> five)
  {
    room_name=room;
    typeOne=one!;
    typeTwo=two!;
    typeThree=three!;
    typeFour=four!;
    typeFive=five!;
  }

  @override
  SwitchClass createState() => new SwitchClass();
}

class SwitchClass extends State {
  SharedPreferences? logindata;
  String? username;
  String? customer_id;


  void initState() {
    // TODO: implement initState
    super.initState();
    initial();
  }

  void initial() async {

    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata?.getString('username');
      customer_id = logindata?.getString('customer_id');
      print("hi from room init state");
      print(typeOne!.length);
      print(typeTwo!.length);
      print(typeThree!.length);
      print(typeFour!.length);
      print(typeFive!.length);
      print(customer_id);
    });
  }

  void onSubscribed(String topic) {
    print('Subscription confirmed for topic $topic');
  }

  void onDisconnected() {
    print('OnDisconnected client callback - Client disconnection');
  }



  Future<void> connectAndPublish(String _topic,String message) async {

    final client = MqttServerClient.withPort('34.131.188.212', '', 8883);
    client.setProtocolV311();
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = onDisconnected;
    client.onSubscribed = onSubscribed;


    final connMess = MqttConnectMessage()
        .withClientIdentifier('Mqtt_MyClientUniqueIdQ1')
        .withWillTopic('willtopic')
        .withWillMessage('My Will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    connMess.authenticateAs(brokerUsername, brokerPassword);
    print('Mosquitto client connecting....');
    client.connectionMessage = connMess;



    try {
      await client.connect();
    } on Exception catch (e) {
      print('Client exception - $e');
      client.disconnect();
      return;
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Mosquitto client connected');
    } else {
      print(
          'ERROR Mosquitto client connection failed - disconnecting, state is ${client.connectionStatus!.state}');
      client.disconnect();
      return;
    }


    final builder1 = MqttClientPayloadBuilder();
    String? topic=_topic;

    builder1.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder1.payload!);


    await Future.delayed(Duration(seconds: 60));

    await Future.delayed(Duration(seconds: 10));
    client.disconnect();
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
      drawer: DrawerWidget(customer_id!),
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
                                        child: Text(typeOne[index].component_name!,
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
                                          print("correct button");
                                          String component_id=typeOne[index].component_id!;

                                          String? topic="Customer/"+customer_id!+"/component/"+component_id+"/state";
                                          connectAndPublish(topic,state.toString());


                                          String updateStateUrl ='http://192.168.0.112/update.php?customer_id=$customer_id&component_id=$component_id&state=$state';
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
                                child: Text(typeTwo[index].component_name!,
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
                                  String component_id=typeTwo[index].component_id!;

                                  String? topic="Customer/"+customer_id!+"/component/"+component_id+"/state";
                                  connectAndPublish(topic,state.toString());

                                  String updateStateUrl ='http://192.168.0.112/update.php?customer_id=$customer_id&component_id=$component_id&state=$state';
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
                                          return DialogBoxOne(typeTwo[index].component_id!,customer_id!).dialog(
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
                                child: Text(typeThree[index].component_name!,
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
                                  String component_id=typeThree[index].component_id!;

                                  String? topic="Customer/"+customer_id!+"/component/"+component_id+"/state";
                                  connectAndPublish(topic,state.toString());

                                  String updateStateUrl ='http://192.168.0.112/update.php?customer_id=$customer_id&component_id=$component_id&state=$state';
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
                                          return DialogBoxTwo(typeThree[index].component_id!,customer_id!).dialog(
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
                                child: Text(typeFour[index].component_name!,
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
                                  String component_id=typeFour[index].component_id!;

                                  String? topic="Customer/"+customer_id!+"/component/"+component_id+"/state";
                                  connectAndPublish(topic,state.toString());


                                  if(state==0){
                                    String updateFlagUrl ='http://192.168.0.112/update_flag.php?customer_id=$customer_id&component_id=$component_id&flag=0';
                                    update_services.getAccess(updateFlagUrl).then((tab)  async{
                                    });
                                  }
                                  String updateStateUrl ='http://192.168.0.112/update.php?customer_id=$customer_id&component_id=$component_id&state=$state';
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
                                          return DialogBoxThree(typeFour[index].component_id!,customer_id!).dialog(
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
                                child: Text(typeFive[index].component_id!,
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
                                  String component_id=typeFive[index].component_id!;

                                  String? topic="Customer/"+customer_id!+"/component/"+component_id+"/state";
                                  connectAndPublish(topic,state.toString());

                                  if(state==0){
                                    String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$customer_id&component_id=$component_id&variable=24';
                                    update_services.getAccess(updateVariableUrl).then((tab)  async{
                                    });
                                  }
                                  String updateStateUrl ='http://192.168.0.112/update.php?customer_id=$customer_id&component_id=$component_id&state=$state';
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
                                          return DialogBoxFour(typeFive[index].component_id!,customer_id!).dialog(
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

