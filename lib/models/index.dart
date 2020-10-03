import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';

init() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpendsAdapter());
  Hive.registerAdapter(BudgetAdapter());
  await openExpends();
  await openBudget();
}
