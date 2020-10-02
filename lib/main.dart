import 'package:SimpleBudget/components/drawer.dart';
import 'package:SimpleBudget/models/budget.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import './pages/cateory_list.dart';
import './components/expend_list_title.dart';
import 'const.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpendsAdapter());
  Hive.registerAdapter(BudgetAdapter());
  await openExpends();
  await openBudget();
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

class BudgetInputPopup extends StatefulWidget {
  const BudgetInputPopup({
    Key key,
  }) : super(key: key);

  @override
  _BudgetInputPopupState createState() => _BudgetInputPopupState();
}

class _BudgetInputPopupState extends State<BudgetInputPopup> {
  String price = "0";

  DateTime yearMonth = DateTime(DateTime.now().year, DateTime.now().month);

  @override
  Widget build(BuildContext context) {
    BudgetSrv srv = Provider.of<BudgetSrv>(context);
    void onSubmit() {
      var value = Budget(yearMonth, double.parse(price));
      srv.putByMonth(yearMonth, value);
      Navigator.pop(context, true);
    }

    return SimpleDialog(
      title: Text(
        "Your Budget",
        style: TextStyle(fontSize: 20),
      ),
      contentPadding: EdgeInsets.all(10),
      children: [
        FractionallySizedBox(
          widthFactor: 0.8,
          child: TextField(
              keyboardType: TextInputType.number,
              onChanged: (v) {
                setState(() {
                  price = v;
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(prefix: Text("£"))),
        ),
        Container(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: FlatButton(
            onPressed: price != "" && int.parse(price) > 0 ? onSubmit : null,
            child: Text("DONE"),
          ),
        )
      ],
    );
  }
}

class ExpenseList extends StatefulWidget {
  const ExpenseList({
    Key key,
  }) : super(key: key);

  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  int sort = 1;
  void toggleSort() {
    setState(() {
      sort = sort * -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 90,
      left: 0,
      right: 0,
      bottom: 0,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35.0), topRight: Radius.circular(35.0)),
        ),
        margin: EdgeInsets.all(0),
        elevation: 10,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: FractionallySizedBox(
            widthFactor: 0.9,
            child: Column(
              children: [
                Expanded(
                  flex: 0,
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Text("Expense"),
                              ),
                            ],
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: sort == 1 ? 2 : 4,
                          child: IconButton(
                              icon: Icon(Icons.sort), onPressed: toggleSort),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ValueListenableBuilder(
                    valueListenable: listenExpend(),
                    builder: (context, box, widget) {
                      var srv = Provider.of<ExpendsSrv>(context);
                      var ls = srv.getGroupExpends2(box, sort);
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: ls.length,
                        itemBuilder: (context, index) {
                          var catExpendsInfo = ls.elementAt(index);
                          return ExpendListTitle(
                            catName: catExpendsInfo["catName"],
                            desc: catExpendsInfo["sum"].toString(),
                          );
                        },
                        // children: list,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
