import 'package:SimpleBudget/const.dart';
import 'package:flutter/material.dart';

class ExpendListTitle extends StatelessWidget {
  final catName;
  final desc;

  const ExpendListTitle({
    Key key,
    this.catName = "",
    this.desc = ""
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: 2, right: 2),
      leading: Stack(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: purple1,
            value: 0.8,
          ),
          Positioned.fill(
            child: Align(
              child: Icon(
                getIconByName(catName),
                size: 16,
              ),
              alignment: Alignment.center,
            ),
          )
        ],
      ),
      title: Text(catName),
      subtitle: Text(desc),
    );
  }
}
