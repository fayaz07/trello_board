import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/providers/cards_provider.dart';
import 'package:trello_board/trello/column/add_column.dart';
import 'package:trello_board/trello/column/column.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);

    List<Widget> columns = List.generate(
      provider.columns.length,
      (index) => TColumn(
        colData: provider.columns.values.toList()[index],
      ),
    );
    columns.add(AddColumnButton());
    return Scaffold(
      appBar: AppBar(
        title: Text('Your dashboard'),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: columns,
        ),
      ),
    );
  }
}

class AddColumnButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 32.0),
      child: Align(
        alignment: Alignment.topCenter,
        child: RaisedButton(
          color: Colors.white,
          elevation: 4.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => AddColumn()));
          },
          child: Text(
            'Add column'.toUpperCase(),
            style: Theme.of(context).textTheme.button,
          ),
        ),
      ),
    );
  }
}
