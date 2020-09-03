import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/models/card.dart';
import 'package:trello_board/models/column.dart';
import 'package:trello_board/providers/cards_provider.dart';
import 'package:trello_board/trello/card/add_card.dart';
import 'package:trello_board/trello/card/card.dart';

class TColumn extends StatelessWidget {
  final TColumnModel colData;

  const TColumn({Key key, this.colData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      margin: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 8.0,
      child: SizedBox(
        width: 250.0,
        child: TDragTarget(
          colData: colData,
        ),
      ),
    );
  }
}

class TDragTarget extends StatelessWidget {
  final TColumnModel colData;

  const TDragTarget({Key key, this.colData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);
    return DragTarget<TCardModel>(
      onWillAccept: (data) {
        // ignore if it's same column
        return data.columnId != colData.id;
      },
      onAccept: (data) {
        provider.replace(data.columnId, colData.id, data.id);
        print(data);
      },
      builder: (context, accept, reject) {
        return TReorderableList(
          colData: colData,
        );
      },
    );
  }
}

class TReorderableList extends StatelessWidget {
  final TColumnModel colData;

  const TReorderableList({Key key, this.colData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);
    return Scrollbar(
      child: ReorderableListView(
        header: TRListHeader(
          colData: colData,
        ),
        scrollController: ScrollController(debugLabel: "${colData.id}"),
        scrollDirection: Axis.vertical,
        onReorder: (c, p) {
          print("$c $p");
          provider.reorder(colData.id, c, p);
        },
        children: List.generate(
          provider.cards[colData.id]?.length ?? 0,
          (index) {
            final card = provider.cards[colData.id][index];

            return TCard(
              key: Key("Card-${card.columnId}-${index + 1}"),
              data: card,
            );
          },
        ),
      ),
    );
  }
}

class TRListHeader extends StatelessWidget {
  final TColumnModel colData;

  const TRListHeader({Key key, this.colData}) : super(key: key);

  void addCard(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => AddCard(colData.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.greenAccent,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                '${colData.title}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
            IconButton(icon: Icon(Icons.add), onPressed: () => addCard(context))
          ],
        ),
      ),
    );
  }
}
