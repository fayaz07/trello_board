import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/trello/card/card.dart';
import 'package:trello_board/trello/cards_provider.dart';
import 'package:trello_board/trello/dashboard.dart';

void main() => runApp(TrelloCards());

class TrelloCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [


        ChangeNotifierProvider(
          create: (_) => CardsProvider(),
        ),

      ],
      child: MaterialApp(
        home: Dashboard(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
