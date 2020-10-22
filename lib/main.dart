import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/models/index.dart';
import 'package:SimpleBudget/models/view_state.dart';
import 'package:SimpleBudget/pages/cateory_list.dart';
import 'package:SimpleBudget/pages/detail.dart';
import 'package:SimpleBudget/pages/home.dart';
import 'package:SimpleBudget/pages/input.dart';
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
        onGenerateRoute: (RouteSettings settings) {
          var routes = <String, WidgetBuilder>{
            "/detail": (_) => DetailPage(args: settings.arguments),
            "/edit": (_) => SecondRoute(args: settings.arguments),
            "/add_new": (_) => Dialog(
                  insetPadding: EdgeInsets.zero,
                  child: CatRoute(),
                ),
          };
          WidgetBuilder builder = routes[settings.name];
          if (settings.name == '/add_new') {
            return MaterialPageRoute(
                builder: (ctx) => builder(ctx), fullscreenDialog: true);
          }
          return MaterialPageRoute(builder: (ctx) => builder(ctx));
        },
      ),
    );
  }
}
