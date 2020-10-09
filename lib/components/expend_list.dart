import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/pages/search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/expend_list_title.dart';

class ExpenseList extends StatefulWidget {
  final yearMonth;

  const ExpenseList(
    this.yearMonth, {
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
    final DateTime yearMonth = widget.yearMonth;
    var srv = Provider.of<ExpendsSrv>(context);
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
                      var ls = srv.getGroupExpends2(yearMonth, sort);
                      return ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: ls.length,
                        itemBuilder: (context, index) {
                          var catExpendsInfo = ls.elementAt(index);
                          return InkWell(
                            onTap: () {
                              showSearch(
                                  context: context,
                                  delegate: SearchPage(
                                      yearMonth, catExpendsInfo["catName"]));
                            },
                            child: ExpendListTitle(
                              catName: catExpendsInfo["catName"],
                              desc: catExpendsInfo["sum"].toString(),
                            ),
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
