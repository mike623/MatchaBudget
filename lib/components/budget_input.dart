import 'package:SimpleBudget/models/budget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) {
                setState(() {
                  price = double.parse(v).toString();
                });
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(prefix: Text("£"))),
        ),
        Container(height: 20),
        FractionallySizedBox(
          widthFactor: 0.5,
          child: FlatButton(
            onPressed:
                price != "" && double.parse(price) > 0.0 ? onSubmit : null,
            child: Text("DONE"),
          ),
        )
      ],
    );
  }
}
