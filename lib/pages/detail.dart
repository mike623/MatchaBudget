import 'package:SimpleBudget/models/expends.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../const.dart';

class DetailPage extends StatelessWidget {
  Map args;

  DetailPage({this.args});
  void onEditClick() {}
  @override
  Widget build(BuildContext context) {
    final expendSrv = Provider.of<ExpendsSrv>(context);
    Expends item = args['expend'];
    onDelete() {
      Navigator.of(context).popAndPushNamed('/');
      expendSrv.remove(item.id);
    }

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
              icon: Icon(Icons.share, color: Colors.black54), onPressed: null),
          NavPopUp(item: item, onDelete: onDelete),
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

class NavPopUp extends StatelessWidget {
  final Function onDelete;

  const NavPopUp({
    Key key,
    @required this.item,
    @required this.onDelete,
  }) : super(key: key);

  final Expends item;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(Icons.more_vert, color: Colors.black54),
      itemBuilder: (context) => [
        PopupMenuItem(
            value: 1,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/edit',
                      arguments: {'cat': item.catName, 'expend': item});
                },
                child: Align(
                    alignment: Alignment.centerLeft, child: Text('Edit')))),
        PopupMenuItem(
            value: 2,
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                            title: Text("Delete Expend"),
                            content: Text("Are you sure to delete?"),
                            actions: [
                              FlatButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("Cancel")),
                              FlatButton(
                                  onPressed: onDelete,
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(color: red),
                                  ))
                            ],
                          ));
                },
                child: Align(
                    alignment: Alignment.centerLeft, child: Text('Delete')))),
      ],
    );
  }
}
