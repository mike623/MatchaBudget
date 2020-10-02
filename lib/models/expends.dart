import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'expends.g.dart';

@HiveType(typeId: 1)
class Expends {
  Expends(this.date, this.price, this.placeId, this.catName, this.placeDesc);

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  String price;

  @HiveField(2)
  String placeId;

  @HiveField(3)
  String catName;

  @HiveField(4)
  String placeDesc;
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

class ExpendsSrv {
  Box box;

  ExpendsSrv(this.box);

  void log() async {
    print(box.values.toList());
  }

  Map<dynamic, List<dynamic>> getGroupExpends(box) {
    Map<dynamic, dynamic> raw = box.toMap();
    var list = raw.values.toList().where((element) => element.catName != null);
    var newList = groupBy(list, (obj) => obj.catName);
    return newList;
  }

  sumOfExpends(listOfExpends) {
    var sum = listOfExpends
        .map((e) => double.parse(e.price))
        .reduce((value, element) => value + element);
    return sum;
  }

  List<Map<String, dynamic>> getGroupExpends2(box, int sort) {
    Map<dynamic, dynamic> raw = box.toMap();
    return raw.entries.map((e) {
      var sum = sumOfExpends(e.value);
      return {"catName": e.key, "listOfExpends": e.value, "sum": sum};
    }).toList()
      ..sort((a, b) => a["price"].toString().compareTo(b["price"].toString()));
  }

  Map getCatExpendsInfo(newList, index) {
    var catName = newList.keys.elementAt(index);
    var listOfExpends = newList.values.elementAt(index);
    var sum = listOfExpends
        .map((e) => double.parse(e.price))
        .reduce((value, element) => value + element);
    var result = {
      "catName": catName,
      "listOfExpends": listOfExpends,
      "sum": sum
    };
    return result;
  }

  Iterable<dynamic> searchBy(String query) {
    var v = box.values;
    return v.where((element) => element.catName != null).where((element) =>
        RegExp(query).hasMatch(element.price.toString() + element.placeDesc));
  }
}
