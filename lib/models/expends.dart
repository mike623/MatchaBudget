import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

part 'expends.g.dart';

@HiveType(typeId: 1)
class Expends {
  Expends(this.date, this.price, this.placeId, this.catName, this.placeDesc,
      this.id);

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

  @HiveField(5)
  int id;

  getFormattedDate() {
    return new DateFormat()
        .add_yMMMd()
        .add_jm()
        .format(this.date ??= DateTime.now());
  }

  isInRange(start, end) {
    return this.date.isAfter(start) && this.date.isBefore(end);
  }
}

var addExpend = (id, Expends d) async {
  var expends = await Hive.openBox('expends');
  expends.put(id, d);
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

  double sumOfExpends(listOfExpends) {
    var sum = listOfExpends
        .map((e) => double.parse(e.price))
        .reduce((value, element) => value + element);
    return sum;
  }

  List<Map<String, dynamic>> getGroupExpends2(DateTime yearMonth, int sort) {
    final range = getMonthRange(yearMonth);
    var start = range['start'];
    var end = range['end'];
    final filteredList =
        box.values.where((element) => element.isInRange(start, end));
    var list =
        filteredList.toList().where((element) => element.catName != null);
    var map = groupBy(list, (obj) => obj.catName);
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
    final range = getMonthRange(dateTime);
    var start = range['start'];
    var end = range['end'];
    var listOfExpends = box.values.where((element) {
      return element.isInRange(start, end);
    });
    return {
      "dateTime": dateTime,
      "sum": listOfExpends.length == 0 ? 0.0 : sumOfExpends(listOfExpends),
      "listOfExpends": listOfExpends
    };
  }

  updateExpend(id, Expends expend) {
    return box.put(id, expend);
  }

  getNewId() {
    return box.values.length + 1;
  }

  remove(int id) {
    return box.delete(id);
  }

  Map getMonthRange(dateTime) {
    var start = DateTime(dateTime.year, dateTime.month, 0);
    var end = DateTime(dateTime.year, dateTime.month + 1, 1);
    return {
      "start": start,
      "end": end,
    };
  }
}
