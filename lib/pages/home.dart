import 'package:SimpleBudget/components/drawer.dart';
import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../pages/cateory_list.dart';
import '../components/expend_list.dart';
import '../components/budget_input.dart';
import '../const.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    var budgetSrv = Provider.of<BudgetSrv>(context);
    var expendsSrv = Provider.of<ExpendsSrv>(context);
    var yearMonth = DateTime(DateTime.now().year, DateTime.now().month);
    var allExp = expendsSrv.getAllExpendsByDateTime(yearMonth);
    var info = budgetSrv.getBudgetInfo(yearMonth, allExp['sum']);
    var budgetString = info['balance'].toString();
    var allBudget = info['allBudget'].toString();
    var percent = info['percent'];
    var percentString = (info['percent'] * 100).toStringAsPrecision(4);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: blue4,
      appBar: buildAppBar(context),
      drawer: MyDrawer(),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                          margin: EdgeInsets.only(bottom: 20),
                          child: Text(
                            "October",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          )),
                      Container(
                          child: Text(
                        "\$$budgetString",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold),
                      ))
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Stack(
                fit: StackFit.expand,
                alignment: Alignment.bottomCenter,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                          context: context, builder: (_) => BudgetInputPopup());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35.0),
                              topRight: Radius.circular(35.0)),
                        ),
                        margin: EdgeInsets.all(0),
                        color: grey1,
                        child: Column(
                          children: [
                            FractionallySizedBox(
                              widthFactor: 0.8,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Text("Monthy Budget"),
                                              Container(
                                                child: Text("\$$allBudget"),
                                                margin:
                                                    EdgeInsets.only(left: 5),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text("$percentString%"),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: LinearProgressIndicator(
                                        value: percent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        )),
                  ),
                  ExpenseList()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            widget.title,
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.of(context).push(new MaterialPageRoute<Null>(
                  builder: (BuildContext context) {
                    return Dialog(
                      insetPadding: EdgeInsets.zero,
                      child: CatRoute(),
                    );
                  },
                  fullscreenDialog: true));
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              showSearch(context: context, delegate: SearchPage());
            },
          ),
        ],
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ));
  }
}
