import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:trello_board/models/card.dart';
import 'package:trello_board/models/column.dart';

final columnsFirestore = FirebaseFirestore.instance.collection("columns");
// final cardsFirestore = FirebaseFirestore.instance.collection("cards");

class CardsProvider extends ChangeNotifier {
  Map<String, TColumnModel> _columns = Map();
  Map<String, List<TCardModel>> _cards = Map();

  bool _loading = true;

  bool get loading => _loading;

  set loading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _fetchColumns() {
    print("fetching columns");
    if (_columns.length == 0) {
      columnsFirestore.get().then((QuerySnapshot snapshot) {
        if (snapshot.docs.length > 0) {
          for (var s in snapshot.docs) {
            var col = TColumnModel.fromJSON(s.data());
            col.id = s.id;
            _columns[col.id] = col;
            final cards = TCardModel.parseJSONList(s.data()["cards"]);
            _cards[col.id] = cards;
          }
          print("After fetching columns ${_columns.length}");
          _loading = false;
          notifyListeners();
        }
      });
    }
  }

  CardsProvider() {
    _fetchColumns();
  }

  Future<void> addColumn(String title) async {
    var column = TColumnModel(title: title);
    DocumentReference doc = await columnsFirestore.add(column.toJSON());
    column.id = doc.id;
    _columns[column.id] = column;
    _cards[column.id] = <TCardModel>[];
    notifyListeners();
  }

  Future<void> addCard(String colId, String task) async {
    if (!_cards.containsKey(colId))
      throw "Column with id $colId doesn't exists, $columns";
    var colCards = _cards[colId];
    print("adding card to $colId");
    var card = TCardModel(
      views: 0,
      likes: 0,
      columnId: colId,
      id: colCards.length + 1,
      task: task,
    );
    colCards.add(card);

    // card.id = doc.id;
    _cards.update(colId, (value) => colCards);
    notifyListeners();
    await updateCardsInFirestore(colId, colCards);
  }

  Future<void> updateCardsInFirestore(
      String colId, List<TCardModel> colCards) async {
    await columnsFirestore
        .doc(colId)
        .update({"cards": TCardModel.toJSONList(colCards)});
  }

  Future<void> reorder(String column, int oldI, int newI) async {
    var list = _cards[column];
    if (newI == list.length) {
      newI = newI - 1;
    }
    var oldChild = list[oldI];
    list.removeAt(oldI);
    list.insert(newI, oldChild);
    _cards[column] = list;
    notifyListeners();
    // await cardsFirestore
    await updateCardsInFirestore(column, list);
  }

  Future<void> replace(String prevColId, String currentColId, int cardId) async {
    var oldList = _cards[prevColId];
    var cardToBeRemoved = oldList.firstWhere((element) {
      return element.id == cardId;
    });
    print("Before removing ${oldList.length}");
    oldList.remove(cardToBeRemoved);
    updateCardsInFirestore(prevColId, oldList);
    print("After removing ${oldList.length}");

    var newList = _cards[currentColId];
    var cardData = cardToBeRemoved;
    cardData.columnId = currentColId;
    newList.add(cardData);
    updateCardsInFirestore(currentColId, newList);
    notifyListeners();
  }

  Map<String, List<TCardModel>> get cards => _cards;

  set cards(Map<String, List<TCardModel>> value) {
    _cards = value;
    notifyListeners();
  }

  Map<String, TColumnModel> get columns => _columns;

  set columns(Map<String, TColumnModel> value) {
    _columns = value;
    notifyListeners();
  }
}
