import 'package:flutter/material.dart';
import 'package:trello_board/trello/column/column.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            10,
            (index) => TColumn(
              columnId: "${index + 1}",
            ),
          ),
        ),
      ),
    );
  }
}
