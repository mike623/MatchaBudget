import 'package:SimpleBudget/models/expends.dart';
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
  await openExpends();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        FutureProvider<Box>(create: (_) => openExpends()),
        ProxyProvider<Box, ExpendsSrv>(
            update: (BuildContext context, Box box, ExpendsSrv expendsSrv) =>
                ExpendsSrv(box)),
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: blue4,
      appBar: buildAppBar(context),
      drawer: buildListView(context),
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
                        "\$5,650",
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
                  Card(
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
                                              child: Text("\$8000"),
                                              margin: EdgeInsets.only(left: 5),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Text("65%"),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: LinearProgressIndicator(
                                      value: 0.8,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                  Positioned(
                    top: 90,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35.0),
                            topRight: Radius.circular(35.0)),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              margin:
                                                  EdgeInsets.only(right: 20),
                                              child: Text("Expense"),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.sort),
                                        onPressed: () => {},
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
                                    var newList = srv.getGroupExpends(box);
                                    return ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: newList.length,
                                      itemBuilder: (context, index) {
                                        var catExpendsInfo = srv
                                            .getCatExpendsInfo(newList, index);
                                        return ExpendListTitle(
                                          catName: catExpendsInfo["catName"],
                                          desc:
                                              catExpendsInfo["sum"].toString(),
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
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ListView buildListView(BuildContext context) {
    return ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Drawer Header'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            title: Text('Item 1'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ]);
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
            onPressed: () {},
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
