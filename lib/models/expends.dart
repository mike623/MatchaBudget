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

  double sumOfExpends(listOfExpends) {
    var sum = listOfExpends
        .map((e) => double.parse(e.price))
        .reduce((value, element) => value + element);
    return sum;
  }

  List<Map<String, dynamic>> getGroupExpends2(box, int sort) {
    var map = getGroupExpends(box);
    var rs = map.entries.map((e) {
      var sum = sumOfExpends(e.value);
      return {"catName": e.key, "listOfExpends": e.value, "sum": sum};
    }).toList();
    if (sort == 1) {
      return rs
        ..sort((a, b) => a["sum"].toString().compareTo(b["sum"].toString()));
    } else if (sort == -1) {
      return rs
        ..sort((b, a) => a["sum"].toString().compareTo(b["sum"].toString()));
    }
    return rs;
  }

  Iterable<dynamic> searchBy(String query) {
    var v = box.values;
    return v.where((element) => element.catName != null).where((element) =>
        RegExp(query).hasMatch(element.price.toString() + element.placeDesc));
  }

  getAllExpendsByDateTime(DateTime dateTime) {
    var start = DateTime(dateTime.year, dateTime.month, 0);
    var end = DateTime(dateTime.year, dateTime.month + 1, 1);
    var listOfExpends = box.values.where((element) {
      return element.date.isAfter(start) && element.date.isBefore(end);
    });
    return {
      "dateTime": dateTime,
      "sum": listOfExpends.length == 0 ? 0 : sumOfExpends(listOfExpends),
      "listOfExpends": listOfExpends
    };
  }
}
