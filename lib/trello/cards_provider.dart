import 'package:flutter/material.dart';
import 'package:trello_board/models/card.dart';
import 'package:trello_board/trello/card/card.dart';

class CardsProvider extends ChangeNotifier {
  Map<String, List<TCard>> _cards = Map();

  CardsProvider() {
    for (int i = 1; i <= 10; i++) {
      _cards["$i"] = List.generate(
        4,
        (index) {
          final cId = "Card-$i-$index";
          return TCard(
            key: Key(cId),
            data: TCardModel(
              id: cId,
              task: "This is a task for card, col: $i, id: $index ",
              columnId: "$i",
              likes: index,
              views: index * 2,
            ),
          );
        },
      );
    }
  }

  Map<String, List<TCard>> get cards => _cards;

  void reorder(String column, int oldI, int newI) {
    var list = _cards[column];
    // todo: there seem to be a bug re-ordering items to end
    if (newI >= list.length) {
      newI = newI % (list.length - 1);
    }
    var oldChild = list[oldI];
    list.removeAt(oldI);
    list.insert(newI, oldChild);
    _cards[column] = list;
    notifyListeners();
  }

  void replace(String prevColId, String currentColId, String cardId) {
    var oldList = _cards[prevColId];
    var cardToBeRemoved =
        oldList.firstWhere((element) {
          return element.data.id == cardId;
        });
    print("Before removing ${oldList.length}");
    oldList.remove(cardToBeRemoved);
    print("After removing ${oldList.length}");

    var newList = _cards[currentColId];
    var cardData = cardToBeRemoved.data;
    cardData.columnId = currentColId;
    var cardWidget = TCard(
      key: Key("Card-${currentColId}-${newList.length}"),
      data: cardData,
    );
    newList.add(cardWidget);
    notifyListeners();
  }

  set cards(Map<String, List<TCard>> value) {
    _cards = value;
    notifyListeners();
  }
}
