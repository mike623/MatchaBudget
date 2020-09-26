import 'package:flutter/material.dart';
import 'components.dart';

const grey1 = const Color(0xfff3f5fb);
const grey2 = const Color(0xfff3f5fb);
const purple1 = const Color(0xffb4c5f8);
const purple2 = const Color(0xff9aace7);
const purple3 = const Color(0xff949ab1);
const blue1 = const Color(0xff6da2df);
const blue2 = const Color(0xfff3f5fb);
const blue3 = const Color(0xff0867ec);
const blue4 = const Color(0xff39c6fb);

const randc1 = const Color(0xff39c6fb);
const randc2 = const Color(0xff3965fb);
const randc3 = const Color(0xff6e39fb);
const randc4 = const Color(0xffcf39fb);
const randc5 = const Color(0xfffb39c6);
const randc6 = const Color(0xfffb3965);

const CAT_SHOPPING = CatIconText(
  name: 'Shopping',
  icon: Icons.shopping_cart,
  bgColor: randc1,
);
const CAT_EAT = CatIconText(
  name: 'Eat',
  icon: Icons.fastfood,
  bgColor: randc2,
);
const CAT_TRANS = CatIconText(
  name: 'Transport',
  icon: Icons.directions_car,
  bgColor: randc3,
);
const CAT_CLOTHS = CatIconText(
  name: 'Cloths',
  icon: Icons.local_offer,
  bgColor: randc4,
);
const CAT_EN = CatIconText(
  name: 'Entertainment',
  icon: Icons.local_play,
  bgColor: randc5,
);

const CAT_LIST = [CAT_SHOPPING, CAT_EAT, CAT_TRANS, CAT_CLOTHS, CAT_EN];

CatIconText getCatIconTextByName(name) {
  return CAT_LIST.firstWhere((element) => element.name == name);
}

CatIcon getCatIconByName(name) {
  var cat = CAT_LIST.firstWhere((element) => element.name == name);
  return CatIcon(
    icon: cat.icon,
    bgColor: cat.bgColor,
  );
}
