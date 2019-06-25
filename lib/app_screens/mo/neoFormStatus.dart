import 'package:flutter/material.dart';
import 'package:hp_cdrs/connectionStatus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hp_cdrs/app_screens/verbal_autopsy/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hp_cdrs/common/apifunctions/sendDataAPI.dart';
import 'package:hp_cdrs/common/widgets/basicDrawer.dart';
import 'package:hp_cdrs/app_screens/verbal_autopsy/verbal_autopsy_form.dart';
import 'dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';




class neoFormsStatus extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _neoFormsStatusState();
  }
}

class _neoFormsStatusState extends State<neoFormsStatus> {

  final User  = user();
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  List <dynamic>_forms  = [];
  List jsonList = [];
  List  entries = [];
  String jsonData;

  File jsonFile;
  Directory dir;
  String fileName = "neonate.json";
  bool fileExists = false;
  Map<String, String> fileContent;

  String  _appliNumber;

  Future<String> getAppliNumber() async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    _appliNumber = pref.getString('newApplication');

    return _appliNumber;
  }

  @override
  void  initState(){
    super.initState();
    getAppliNumber();


    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      print(dir.path);
      fileExists = jsonFile.existsSync();
      print(fileExists);
      if (fileExists) this.setState(() => jsonData = jsonFile.readAsStringSync());
      if(jsonData!=null){
        jsonData  = jsonData.replaceAll('}{','}_{');
        jsonList  = jsonData.split('_');
      }
      print(jsonList);
      for(int i=0;i<jsonList.length;i++)  {
        var temp  = json.decode(jsonList[i]);
        entries.add(temp);
        print(temp);
        sendData('http://13.126.72.137/api/neonate',temp).then((status) {
          if (status == true) {
            if(i==(jsonList.length-1) && !isOffline){
              clearFile();
            }
          }
        });
      }
    });
    print(jsonList.length);


  }


  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  void createFile(Map content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content),mode: FileMode.append);
  }

  void writeToFile(Map entry) {
    print("Writing to file!");
    if (fileExists) {
      print("File exists");
      jsonFile.writeAsStringSync(json.encode(entry),mode: FileMode.append);
    } else {
      print("File does not exist!");
      createFile(entry, dir, fileName);
    }
    fileContent = json.decode(jsonFile.readAsStringSync());
    print(fileContent);
  }

  void clearFile(){
    if(fileExists)  {
      jsonFile.writeAsStringSync('');
    }
  }

  Future<bool> onBackPress(){
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) =>
            Dashboard()));
  }

  @override
  Widget build(BuildContext context) {


    return FutureBuilder(
      future: getAppliNumber(),
      builder: (BuildContext  context,AsyncSnapshot<String> snapshot) {
        if(snapshot.hasData){
          return  WillPopScope(
            onWillPop: onBackPress,
            child: Scaffold(
              appBar: AppBar(
                title:  Text('Neonate Saved Forms'),
              ),
              drawer: BasicDrawer(),
              body: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  Text(' Next Application Assigned:\n ${_appliNumber}',
                    style: TextStyle(
                      fontSize: 20.0
                    ),
                  ),
                  Flexible(
                    child: ListView.builder(
                        itemCount: entries.length,
                        itemBuilder: (BuildContext  context,  int index)  {
                          return  Card(
                            child: ListTile(
                              title: Text(entries[index]['applicationNumber']),
                              leading: Icon(Icons.contacts),
                            ),
                          );
                        }
                    ),
                  )


                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                tooltip: 'Add new Entry',
                label: Text("New Form"),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => verbalAutopsyForm(verbal_Autopsy_Obj:User,appliNumber:_appliNumber),
                    ),
                  );


                },
              ),

            ),
          );
        }
      },
    );
  }
}









