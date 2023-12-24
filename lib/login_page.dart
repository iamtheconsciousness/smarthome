import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'services.dart';
import 'login_model.dart';
import 'dataBase.dart';
import 'structure_model.dart';
import 'structure_service.dart';

List<Led>? rLed;
final DbManager dbManager = new DbManager();
String readUrl='https://theautohome.xyz/read_all.php?table=';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hands On 1',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  var isLoading = false;
  final username_controller = TextEditingController();
  final password_controller = TextEditingController();
   SharedPreferences? logindata;
   bool? newuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    check_if_already_login();
  }
  void check_if_already_login() async {
    logindata = await SharedPreferences.getInstance();
    newuser = (logindata?.getBool('login') ?? true);
    print(newuser);
    if (newuser == false) {
      Navigator.pushAndRemoveUntil(
          context, new MaterialPageRoute(builder: (context) => MyDashboard()),(route) => false);
    }
  }
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    username_controller.dispose();
    password_controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Preferences"),
      ),
      body: isLoading ?Center(
        child: CircularProgressIndicator(),
      ):Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Login Form",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "To show Example of Shared Preferences",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: username_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: password_controller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                isLoading=true;
                Future.delayed(Duration(milliseconds: 2000), () {
                  // Do something
                });
                String username = username_controller.text;
                String password = password_controller.text;
                 MyLed _access;

                if (username != '' && password != '') {
                  String loginUrl='https://theautohome.xyz/login.php?user=$username&pass=$password';

                  services.getAccess(loginUrl).then((access)  {
                    _access=access;
                    if(_access.success==404){
                      isLoading=false;
                      return showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text("Incorrect Credentials"),
                          content: Text("The username or password is incorrect"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              child: Text("okay"),
                            ),
                          ],
                        ),
                      );

                    }
                    else if(_access.success==200){
                      isLoading=false;
                      logindata?.setString('table',_access.table);
                      readUrl=readUrl+_access.table;
                      struct_services.getAccess(readUrl).then((tab)  async {
                        rLed=tab;

                        dbManager.insertModel(rLed!);
                        print('Successfull');
                        logindata?.setBool('login', false);
                        logindata?.setString('username', access.name);
                        logindata?.setString('schedule_table',_access.scheduleTable);
                        logindata?.setInt('scheduleId', 1);
                        await Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) => MyDashboard()),(route) => false,);

                      });
                    }
                  });

                }
              },
              child: Text("Log-In"),
            )
          ],
        ),
      ),
    );
  }
}

