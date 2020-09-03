import 'package:flutter/material.dart';
import 'package:trello_board/models/card.dart';
import 'package:trello_board/models/column.dart';
import 'package:trello_board/trello/card/card.dart';

class CardsProvider extends ChangeNotifier {
  Map<String, TColumnModel> _columns = Map();
  Map<String, List<TCard>> _cards = Map();

  void addColumn(String title) {
    final colId = "${_columns.length + 1}";
    _columns[colId] = TColumnModel(id: colId, title: title);
    _cards[colId] = <TCard>[];
    notifyListeners();
  }

  void addCard(String colId, String task) {
    if (!_cards.containsKey(colId)) throw "Column doesn't exists";
    var colCards = _cards[colId];
    colCards.add(TCard(
        key: Key("Card-$colId-${colCards.length + 1}"),
        data: TCardModel(
            id: "${colCards.length + 1}",
            views: 0,
            likes: 0,
            columnId: colId,
            task: task)));
    _cards.update(colId, (value) => colCards);
    notifyListeners();
  }

  void reorder(String column, int oldI, int newI) {
    var list = _cards[column];
    if (newI == list.length) {
      newI = newI - 1;
    }
    var oldChild = list[oldI];
    list.removeAt(oldI);
    list.insert(newI, oldChild);
    _cards[column] = list;
    notifyListeners();
  }

  void replace(String prevColId, String currentColId, String cardId) {
    var oldList = _cards[prevColId];
    var cardToBeRemoved = oldList.firstWhere((element) {
      return element.data.id == cardId;
    });
    print("Before removing ${oldList.length}");
    oldList.remove(cardToBeRemoved);
    print("After removing ${oldList.length}");

    var newList = _cards[currentColId];
    var cardData = cardToBeRemoved.data;
    cardData.columnId = currentColId;
    var cardWidget = TCard(
      key: Key("Card-$currentColId-${newList.length}"),
      data: cardData,
    );
    newList.add(cardWidget);
    notifyListeners();
  }

  Map<String, List<TCard>> get cards => _cards;

  set cards(Map<String, List<TCard>> value) {
    _cards = value;
    notifyListeners();
  }

  Map<String, TColumnModel> get columns => _columns;

  set columns(Map<String, TColumnModel> value) {
    _columns = value;
    notifyListeners();
  }
}
