import 'package:SimpleBudget/const.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:SimpleBudget/pages/detail.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SearchPage extends SearchDelegate {
  DateTime yearMonth;
  String catName;

  SearchPage(this.yearMonth, [this.catName]);

  @override
  String get searchFieldLabel {
    final dateString = DateFormat().add_yMMM().format(yearMonth);
    return catName != null
        ? "Search $catName in $dateString"
        : "Search in $dateString";
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.chevron_left),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  _buildResult(context) {
    var result =
        Provider.of<ExpendsSrv>(context).searchBy(query, yearMonth, catName);
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (ctx, index) {
        Expends item = result.elementAt(index);
        return ListTile(
          dense: false,
          onTap: () {
            Navigator.pushNamed(context, '/detail',
                arguments: {'expend': item});
          },
          title: Text("£" + item.price.toString()),
          subtitle: Text(
            DateFormat.yMMMEd().format(item.date).toString() +
                " @ " +
                item.placeDesc.toString(),
            overflow: TextOverflow.ellipsis,
          ),
          leading: Container(
              width: 40, height: 80, child: Icon(getIconByName(item.catName))),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResult(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildResult(context);
  }
}
