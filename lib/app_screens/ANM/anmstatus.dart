import 'package:flutter/material.dart';
import 'package:hp_cdrs/connectionStatus.dart';
import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:hp_cdrs/app_screens/ANM/user.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hp_cdrs/common/apifunctions/sendDataAPI.dart';
import 'package:hp_cdrs/common/widgets/basicDrawer.dart';
import 'package:hp_cdrs/app_screens/ANM/anm1.dart';

void main() {
  runApp(MaterialApp(
    title: "ANM Form",
    home: Scaffold(
      body: ANMStatus(),
    ),
  ));
}

class ANMStatus extends StatefulWidget {
  final User newEntry;
  ANMStatus({Key key, @required this.newEntry}):super(key: key);
  @override
  State<StatefulWidget> createState() {
    return _ANMStatusState();
  }
}

class _ANMStatusState extends State<ANMStatus> {

  Future<bool> onBackPress() async{
    return false;
  }

  final user  = User();
  StreamSubscription _connectionChangeStream;
  bool isOffline = false;

  List <dynamic>_forms  = [];
  List entries = [];
  List jsonList = [];
  String jsonData;

  File jsonFile;
  Directory dir;
  String fileName = "anm.json";
  bool fileExists = false;
  Map<String, String> fileContent;

  @override
  void  initState(){
    super.initState();


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
        sendData('http://13.235.43.83/api/fbi',temp).then((status) {
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

  void createFile(User content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content),mode: FileMode.append);
  }

  void writeToFile(User entry) {
    print("Writing to file!");
    if (fileExists) {
      print("File exists");
      jsonFile.writeAsStringSync(json.encode(entry),mode: FileMode.append);
    } else {
      print("File does not exist!");
      createFile(entry, dir, fileName);
    }
    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
    print(fileContent);
  }

  void clearFile(){
    if(fileExists){
      jsonFile.writeAsStringSync('');
    }
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop : onBackPress,
      child: Scaffold(
        appBar: AppBar(
          title:  Text('ANM Saved Forms'),
        ),
        drawer: BasicDrawer(),
        body: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (BuildContext  context,  int index)  {
              return  Card(
                child: ListTile(
                  title: Text("Name: "+entries[index]['name']),
                  leading: Icon(Icons.contacts),
                ),
              );
            }
        ),
        floatingActionButton: FloatingActionButton.extended(
          label: Text("New Form"),
          icon: Icon(Icons.add),
          tooltip: 'Add new Entry',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ANMWorker(user: user),
              ),
            );


          },
        ),

      ),
    );
  }
}