import 'package:SimpleBudget/const.dart';
import 'package:SimpleBudget/models/expends.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends SearchDelegate {
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
    var result = Provider.of<ExpendsSrv>(context).searchBy(query);
    return ListView.builder(
      itemCount: result.length,
      itemBuilder: (ctx, index) {
        Expends item = result.elementAt(index);
        return ListTile(
          dense: false,
          onTap: () {},
          title: Text(item.price.toString()),
          subtitle: Text(item.catName.toString()),
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
