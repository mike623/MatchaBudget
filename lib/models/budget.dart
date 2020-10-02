import 'package:collection/collection.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'budget.g.dart';

@HiveType(typeId: 2)
class Budget {
  Budget(this.date, this.currentBudget);

  @HiveField(0)
  DateTime date;

  @HiveField(1)
  double currentBudget;
}

var openBudget = () async {
  return await Hive.openBox<Budget>('budget');
};

class BudgetSrv {
  Box<Budget> box;

  BudgetSrv(this.box);

  Budget findByMonth(DateTime yearMonth) {
    return box.get(yearMonth.toString());
  }

  putByMonth(DateTime yearMonth, Budget value) {
    box.put(yearMonth.toString(), value);
  }

  getBudgetInfo(DateTime yearMonth, double expendsSum) {
    var allBudget = findByMonth(yearMonth).currentBudget;
    var budget = allBudget - expendsSum ?? 0;
    return {
      "percent": (budget / allBudget),
      "balance": budget,
      "allBudget": allBudget,
    };
  }
}
