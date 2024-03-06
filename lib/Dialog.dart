import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'service_update.dart';


Color currentColor = Colors.limeAccent;
String? _component_id, _customer_id;
int flag=0;

class DialogBoxOne {
  DialogBoxOne(String component_id,String customer_id){
    _component_id=component_id;
    _customer_id=customer_id;

}
  Widget dialog({BuildContext? context,
    Function? onPressed,
    TextEditingController? textEditingController1,
    FocusNode? input1FocusNode,
    int val=3

  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Enter Data"),
        content: Container(
        child: Slider(
                  value: val.toDouble(),
                  min: 0,
                  max: 5,
                  activeColor: Colors.blue,
                  onChanged: (double value) {
                    setState(() {
                      val = value.round();

                    });
                  }
              ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blueGrey,
            child: Text(
              "Cancel",
            ),
          ),
          MaterialButton(
            onPressed: () {
              String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=$val';
              update_services.getAccess(updateVariableUrl).then((tab)  async{
              });
              Navigator.of(context).pop();
            },
            child: Text("Set"),
            color: Colors.blue,
          )
        ],
      );
    });
  }
}

class DialogBoxTwo {
  DialogBoxTwo(String id,String table){
    _component_id=id;
    _customer_id=table;
  }
  Widget dialog({BuildContext? context,
    Function? onPressed,
    TextEditingController? textEditingController1,
    FocusNode? input1FocusNode,
    int val=5

  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Enter Data"),
        content: Container(
          child: ColorPicker(
                pickerColor: currentColor,
                onColorChanged: (Color color) => setState(() => currentColor = color),
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
            ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blueGrey,
            child: Text(
              "Cancel",
            ),
          ),
          MaterialButton(
            onPressed: () {
              int variable=currentColor.value;
              String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=$variable';
              print(updateVariableUrl);
              update_services.getAccess(updateVariableUrl).then((tab)  async{
              });
              Navigator.of(context).pop();
            },
            child: Text("Set"),
            color: Colors.blue,
          )
        ],
      );
    });
  }
}


class DialogBoxThree {
  DialogBoxThree(String id,String table){
    _component_id=id;
    _customer_id=table;
    String updateFlagUrl ='http://192.168.0.112/update_flag.php?customer_id=$_customer_id&component_id=$_component_id&flag=0';
    update_services.getAccess(updateFlagUrl).then((tab)  async{
    });
  }

  Widget dialog({BuildContext? context,
    Function? onPressed,
    TextEditingController? textEditingController1,
    FocusNode? input1FocusNode,
    String? channel

  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Enter Data"),
        content: Container(
          child: Column(
            children:[
            ToggleSwitch(
            minWidth: 50.0,
            minHeight: 30.0,
            initialLabelIndex: 1,
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

              String updateAddstateUrl ='http://192.168.0.112/update_addState.php?customer_id=$_customer_id&component_id=$_component_id&addState=$state';
              update_services.getAccess(updateAddstateUrl).then((tab)  async{
              });
            },
          ),
              TextFormField(
                controller: textEditingController1,
                keyboardType: TextInputType.number,
                focusNode: input1FocusNode,
                decoration: InputDecoration(hintText: "Enter Channel Number"),
                onChanged: (value){
                  channel=value;
                },

              ),
              ElevatedButton(
                child: new Text("Set"),
                onPressed: (){
                  setState((){
                    String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=$channel';
                    update_services.getAccess(updateVariableUrl).then((tab)  async{
                    });
                  });
                },
              ),
              ElevatedButton(
                child: new Text("+"),
                onPressed: (){
                  setState((){
                    flag++;
                    String updateFlagUrl ='http://192.168.0.112/update_flag.php?customer_id=$_customer_id&component_id=$_component_id&flag=$flag';
                    update_services.getAccess(updateFlagUrl).then((tab)  async{
                    });
                  });
                },
              ),
              ElevatedButton(
                child: new Text("-"),
                onPressed: (){
                  setState((){
                    flag--;
                    String updateFlagUrl ='http://192.168.0.112/update_flag.php?customer_id=$_customer_id&component_id=$_component_id&flag=$flag';
                    update_services.getAccess(updateFlagUrl).then((tab)  async{
                    });
                  });
                },
              )
            ]
          )

        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blueGrey,
            child: Text(
              "Cancel",
            ),
          ),
          MaterialButton(
            onPressed: () {
              String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=$channel';
              update_services.getAccess(updateVariableUrl).then((tab)  async{
              });
              Navigator.of(context).pop();
            },
            child: Text("Ok"),
            color: Colors.blue,
          )
        ],
      );
    });
  }
}


class DialogBoxFour {
  DialogBoxFour(String id,String table){
    _component_id=id;
    _customer_id=table;
    String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=24';
    update_services.getAccess(updateVariableUrl).then((tab)  async{
    });
  }
  Widget dialog({BuildContext? context,
    Function? onPressed,
    String temperature='24',
    int temp=24

  }) {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text("Enter Data"),
        content: Container(
          child: Column(
            children: [
              Text("Temperature : $temperature"),
                ElevatedButton(
                child: new Text("+"),
                onPressed: (){
                  setState((){
                    temp++;
                    temperature=temp.toString();
                    });
                },
              ),
              ElevatedButton(
                child: new Text("-"),
                onPressed: (){
                  setState((){
                    temp--;
                    temperature=temp.toString();
                  });
                },
              )

            ],
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.blueGrey,
            child: Text(
              "Cancel",
            ),
          ),
          MaterialButton(
            onPressed: () {
              String updateVariableUrl ='http://192.168.0.112/update_variable.php?customer_id=$_customer_id&component_id=$_component_id&variable=$temperature';
              update_services.getAccess(updateVariableUrl).then((tab)  async{
              });
              Navigator.of(context).pop();
            },
            child: Text("Set"),
            color: Colors.blue,
          )
        ],
      );
    });
  }
}