import 'package:SimpleBudget/models/expends.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../const.dart';

class DetailPage extends StatelessWidget {
  void onEditClick() {}
  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    Expends item = args['expend'];
    var dateString =
        new DateFormat.yMMMd().add_jm().format(item.date ??= DateTime.now());
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
        actions: [
          IconButton(
              icon: Icon(Icons.share, color: Colors.black87), onPressed: null),
          IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.black87,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed('/edit',
                    arguments: {'cat': item.catName, 'expend': item});
              }),
        ],
      ),
      body: Center(
          child: Stack(
        children: [
          Column(
            children: [
              Container(
                child: getCatIconByName(item.catName),
                width: 100,
              ),
              Container(height: 30),
              Text('${dateString}'),
              Container(height: 30),
              FractionallySizedBox(
                widthFactor: 0.5,
                child: Text(
                  item.placeDesc ?? 'Location',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black.withOpacity(0.5)),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(height: 30),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Center(
                  child: Text(
                    "£${item.price}",
                    style: TextStyle(fontSize: 60),
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
