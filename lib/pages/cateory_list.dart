import 'package:SimpleBudget/main.dart';
import 'package:SimpleBudget/pages/input.dart';
import 'package:flutter/material.dart';

import '../components.dart';
import '../const.dart';

class CatRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop()),
      ),
      body: Container(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  child: Text(
                    "Expense Category",
                    style: TextStyle(fontSize: 20),
                  ),
                  alignment: Alignment.center,
                ),
                Container(height: 40),
                CatList(list: CAT_LIST),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CatList extends StatelessWidget {
  const CatList({
    Key key,
    this.list,
  }) : super(key: key);
  final List<CatIconText> list;

  @override
  Widget build(BuildContext context) {
    onPress(catName) {
      print(catName);
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              child: SecondRoute(cat: catName),
            );
          },
          fullscreenDialog: true));
    }

    return Expanded(
      flex: 1,
      child: SingleChildScrollView(
        child: Column(
          children: [
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Container(
                  alignment: Alignment.topCenter,
                  child: Wrap(
                    children: list
                        .map((e) => CatIconBtn(
                              onPress: onPress,
                              icon: e,
                            ))
                        .toList(),
                  )),
            ),
            Container(
              height: 100,
            )
          ],
        ),
      ),
    );
  }
}
