import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'expends.g.dart';

@HiveType(typeId: 1)
class Expends {
  Expends(this.date, this.price, this.placeId, this.catName);

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String price;

  @HiveField(2)
  String placeId;

  @HiveField(3)
  String catName;
}

var addExpend = (Expends d) async {
  var expends = await Hive.openBox('expends');
  expends.add(d);
};

var listExpend = () async {
  var expends = await Hive.openBox('expends');
  return expends.values;
};
var deleteExpend = (key) async {
  var expends = await Hive.openBox('expends');
  return expends.delete(key);
};

var listenExpend = () {
  return Hive.box('expends').listenable();
};

var openExpends = () async {
  return await Hive.openBox('expends');
};
