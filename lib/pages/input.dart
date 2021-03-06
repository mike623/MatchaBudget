import 'dart:async';

import 'package:SimpleBudget/models/expends.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class SecondRoute extends StatefulWidget {
  final String cat;

  final Map args;

  @override
  _SecondRouteState createState() => _SecondRouteState();
  const SecondRoute({Key key, this.cat, this.args}) : super(key: key);
}

class _SecondRouteState extends State<SecondRoute> {
  KeyboardVisibilityNotification _keyboardVisibility =
      new KeyboardVisibilityNotification();
  int _keyboardVisibilitySubscriberId;
  bool _keyboardState;
  String cat;
  DateTime date = DateTime.now();
  String price;
  Prediction place;
  Expends expend;
  void dateValueChange(DateTime datetime) {
    return setState(() {
      date = datetime;
    });
  }

  void timeValueChange(TimeOfDay value) {
    return setState(() {
      var finalDate = new DateTime(
          date.year, date.month, date.day, value.hour, value.minute);
      date = finalDate;
    });
  }

  void onPriceChanged(String value) {
    setState(() {
      price = value;
    });
  }

  FutureOr<Prediction> onPlaceSet(Prediction value) {
    setState(() {
      place = value;
    });
  }

  @protected
  void initState() {
    super.initState();

    _keyboardState = _keyboardVisibility.isKeyboardVisible;

    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
      onChange: (bool visible) {
        setState(() {
          _keyboardState = visible;
        });
      },
    );

    expend = widget.args['expend'];
    if (expend != null) {
      price = expend.price;
      cat = expend.catName;
      date = expend.date;
      place = Prediction(expend.placeDesc, "", [], 0, expend.placeId, "", [],
          [], StructuredFormatting("", [], ""));
    } else {
      cat = widget.args['cat'];
    }
  }

  @override
  Widget build(BuildContext context) {
    var expendsSrv = Provider.of<ExpendsSrv>(context);
    bool isValid = formValid();
    var dateString =
        new DateFormat.yMMMd().add_jm().format(date ??= DateTime.now());
    void onSubmit(cat) {
      if (expend != null) {
        expend.date = date;
        expend.price = price;
        expend.placeId = place.placeId;
        expend.catName = cat;
        expend.placeDesc = place.description;
        expendsSrv.updateExpend(expend.id, expend);
      } else {
        var id = expendsSrv.getNewId();
        addExpend(id,
            Expends(date, price, place.placeId, cat, place.description, id));
      }

      Navigator.popUntil(context, ModalRoute.withName('/'));
    }

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
                child: getCatIconByName(cat),
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
                child: Text('$dateString'),
              ),
              FlatButton(
                onPressed: () async {
                  Position position = await getCurrentPosition();
                  if (position == null) return;
                  var location =
                      Location(position.latitude, position.longitude);
                  await PlacesAutocomplete.show(
                          context: context,
                          apiKey: kGoogleApiKey,
                          mode: Mode.fullscreen, // Mode.overlay
                          language: "en",
                          radius: 1000,
                          location: location,
                          components: [Component(Component.country, "gb")])
                      .then(onPlaceSet);
                },
                child: FractionallySizedBox(
                  widthFactor: 0.5,
                  child: Text(
                    place?.description ?? 'Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  ),
                ),
              ),
              Container(height: 15),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: TextField(
                  controller: TextEditingController(text: price),
                  onChanged: this.onPriceChanged,
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
              child: Visibility(
                visible: !_keyboardState,
                child: FlatButton(
                  color: blue4,
                  disabledColor: Colors.grey.shade300,
                  onPressed: isValid ? () => onSubmit(cat) : null,
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
            ),
          )
        ],
      )),
    );
  }

  bool formValid() {
    return price != null && price != "" && place != null;
  }
}
