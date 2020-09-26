import 'package:SimpleBudget/pages/input.dart';
import 'package:flutter/material.dart';

class CatIconBtn extends StatelessWidget {
  final CatIconText icon;

  final onPress;

  const CatIconBtn({
    Key key,
    this.icon,
    this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: FractionallySizedBox(
        widthFactor: 0.3,
        child: FlatButton(
          padding: EdgeInsets.zero,
          onPressed: () => onPress(icon.name),
          child: this.icon,
        ),
      ),
    );
  }
}

class CatIcon extends StatelessWidget {
  final bgColor;
  final IconData icon;

  const CatIcon({
    Key key,
    this.icon,
    this.bgColor = Colors.indigo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: bgColor.withOpacity(0.5)),
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}

class CatIconText extends StatelessWidget {
  final name;
  final IconData icon;
  final bgColor;

  final showText;

  const CatIconText({
    Key key,
    this.name,
    this.icon,
    this.bgColor = Colors.indigo,
    this.showText = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CatIcon(
          icon: icon,
          bgColor: bgColor,
        ),
        Text(
          name,
        )
      ],
    );
  }
}
