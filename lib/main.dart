import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/models/index.dart';
import 'package:SimpleBudget/models/view_state.dart';
import 'package:SimpleBudget/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

void main() async {
  await init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<Box>(create: (_) => openExpends()),
        FutureProvider<Box<Budget>>(create: (_) => openBudget()),
        ProxyProvider<Box, ExpendsSrv>(
            update: (BuildContext context, Box box, ExpendsSrv expendsSrv) =>
                ExpendsSrv(box)),
        ProxyProvider<Box<Budget>, BudgetSrv>(
            update: (BuildContext context, Box<Budget> box, BudgetSrv srv) =>
                BudgetSrv(box)),
        ChangeNotifierProvider(
          create: (_) => ViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
            fontFamily: "Nunito"),
        home: MyHomePage(title: 'Hello!'),
      ),
    );
  }
}
