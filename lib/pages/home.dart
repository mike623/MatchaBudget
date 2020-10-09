import 'package:SimpleBudget/components/drawer.dart';
import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/models/view_state.dart';
import 'package:SimpleBudget/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    // TODO: improve for performance
    return ValueListenableBuilder(
      valueListenable: listenExpend(),
      builder: (ctx, value, _) {
        return buildMain();
      },
    );
  }

  Consumer<ViewModel> buildMain() {
    return Consumer<ViewModel>(
      builder: (context, viewState, child) {
        var budgetSrv = Provider.of<BudgetSrv>(context);
        var expendsSrv = Provider.of<ExpendsSrv>(context);
        var yearMonth = viewState.cuurentDateTime;
        var allExp = expendsSrv.getAllExpendsByDateTime(yearMonth);
        var info = budgetSrv.getBudgetInfo(yearMonth, allExp['sum']);
        var budgetString = info['balance'].toString();
        var allBudget = info['allBudget'].toString();
        double percent = info['percent'];
        if (percent < 0) percent = 0;
        var percentString = (percent * 100).toStringAsPrecision(4);
        return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: blue4,
          appBar: buildAppBar(context),
          body: Column(
            children: [
              MonthDisplayChanger(
                budgetString: budgetString,
                currentDateTime: viewState.cuurentDateTime,
                onPrevMonthClick: viewState.prevMonth,
                onNextMonthClick: viewState.nextMonth,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.bottomCenter,
                    children: [
                      BudgetProgress(
                          allBudget: allBudget,
                          percentString: percentString,
                          percent: percent),
                      ExpenseList(yearMonth)
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
            showSearch(context: context, delegate: SearchPage(DateTime.now()));
          },
        ),
      ],
    );
  }
}

class BudgetProgress extends StatelessWidget {
  const BudgetProgress({
    Key key,
    @required this.allBudget,
    @required this.percentString,
    @required this.percent,
  }) : super(key: key);

  final String allBudget;
  final String percentString;
  final double percent;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(context: context, builder: (_) => BudgetInputPopup());
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Text("Monthy Budget"),
                                Container(
                                  child: Text("\$$allBudget"),
                                  margin: EdgeInsets.only(left: 5),
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
    );
  }
}

class MonthDisplayChanger extends StatelessWidget {
  final DateTime currentDateTime;

  final void Function() onNextMonthClick;

  const MonthDisplayChanger({
    Key key,
    @required this.budgetString,
    @required this.onPrevMonthClick,
    this.currentDateTime,
    this.onNextMonthClick,
  }) : super(key: key);

  final String budgetString;
  final void Function() onPrevMonthClick;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      DateFormat.MMMM().format(currentDateTime),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    )),
                FractionallySizedBox(
                  widthFactor: 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          this.onPrevMonthClick();
                        },
                        icon: Icon(Icons.chevron_left, color: grey1),
                      ),
                      Container(
                          child: Text(
                        "\$$budgetString",
                        style: TextStyle(
                            fontStyle: FontStyle.normal,
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold),
                      )),
                      IconButton(
                        onPressed: onNextMonthClick,
                        icon: Icon(Icons.chevron_right, color: grey1),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
