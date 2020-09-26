import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../const.dart';

class SecondRoute extends StatefulWidget {
  final String cat;

  @override
  _SecondRouteState createState() => _SecondRouteState();
  const SecondRoute({Key key, this.cat}) : super(key: key);
}

class _SecondRouteState extends State<SecondRoute> {
  DateTime date = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();

  void dateValueChange(DateTime datetime) {
    return setState(() {
      date = datetime;
    });
  }

  void timeValueChange(TimeOfDay value) {
    return setState(() {
      timeOfDay = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    var dateString = new DateFormat.yMMMd().format(date ??= DateTime.now());
    print(timeOfDay);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop()),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: getCatIconByName(widget.cat),
                width: 100,
              ),
              Container(height: 15),
              FlatButton(
                onPressed: () async {
                  await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2001),
                          lastDate: DateTime(2022))
                      .then(dateValueChange);
                  await showTimePicker(
                          context: context, initialTime: TimeOfDay.now())
                      .then(timeValueChange);
                },
                child: Text('$dateString ${timeOfDay.format(context)}'),
              ),
              Container(height: 15),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 60,
                  ),
                  decoration: InputDecoration(
                    prefixIcon: Text(
                      "£",
                      style: TextStyle(fontSize: 60),
                    ),
                    hintText: '22,50',
                    border: InputBorder.none,
                    prefixIconConstraints:
                        BoxConstraints(minWidth: 0, minHeight: 0),
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(bottom: 30),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlatButton(
                color: blue4,
                onPressed: () =>
                    {Navigator.popUntil(context, ModalRoute.withName('/'))},
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: blue2)),
                child: Text(
                  'Done',
                  style: TextStyle(fontSize: 30, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
