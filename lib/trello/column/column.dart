import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/models/card.dart';
import 'package:trello_board/trello/cards_provider.dart';

class TColumn extends StatelessWidget {
  final String columnId;

  const TColumn({Key key, this.columnId}) : super(key: key);

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
          columnId: columnId,
        ),
      ),
    );
  }
}

class TDragTarget extends StatelessWidget {
  final String columnId;

  const TDragTarget({Key key, this.columnId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);
    return DragTarget<TCardModel>(
      onWillAccept: (data) {
        // ignore if it's same column
        return data.columnId != columnId;
      },
      onAccept: (data) {
        provider.replace(data.columnId, columnId, data.id);
        print(data);
      },
      builder: (context, accept, reject) {
        return TReorderableList(
          columnId: columnId,
        );
      },
    );
  }
}

class TReorderableList extends StatelessWidget {
  final String columnId;

  const TReorderableList({Key key, this.columnId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);
    return Scrollbar(
      child: ReorderableListView(
        header: TRListHeader(
          columnId: columnId,
        ),
        scrollController: ScrollController(debugLabel: "$columnId"),
        scrollDirection: Axis.vertical,
        onReorder: (c, p) {
          print("$c $p");
          provider.reorder(columnId, c, p);
        },
        children: provider.cards[columnId],
      ),
    );
  }
}

class TRListHeader extends StatelessWidget {
  final String columnId;

  const TRListHeader({Key key, this.columnId}) : super(key: key);

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
                'Column $columnId',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
