import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "Form 2",
    home: form2(),
  ));
}

class form2 extends StatefulWidget {
  @override
  _form2State createState() => _form2State();
}

class _form2State extends State<form2> {

  Widget TFF(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextFormField(
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: text,
          hintText: "No of days",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ANM Form2"),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              TFF("Inability to feed"),
              TFF("Fever"),
              TFF("Loose Stools"),
              TFF("Vomiting"),
              TFF("Fast Breathing"),
              TFF("Convulsions"),
              TFF("Appearance of Skin rashes"),
              TFF("Injury(like fractures,wounds)"),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Any other Symptom",
                      hintText: "If any",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      )
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );

  }
}
