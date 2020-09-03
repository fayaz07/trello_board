import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/providers/cards_provider.dart';
import 'package:trello_board/utils/strings.dart';

// ignore: must_be_immutable
class AddCard extends StatelessWidget {
  String columnId;

  AddCard(this.columnId);

  final _formKey = GlobalKey<FormState>();
  String _cardTask = "";

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CardsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Card'),
      ),
      body: provider.loading
          ? Center(child: CircularProgressIndicator())
          : _body(context, provider),
    );
  }

  Widget _body(BuildContext context, CardsProvider provider) => Column(
        children: [
          Card(
            elevation: 4.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            margin: const EdgeInsets.all(16.0),
            child: _form(),
          ),
          SizedBox(height: 16.0),
          RaisedButton(
            elevation: 4.0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4.0)),
            onPressed: () => _save(context, provider),
            child: Text(Strings.ADD_CARD),
          )
        ],
      );

  Widget _form() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Form(
          key: _formKey,
          child: TextFormField(
            maxLength: 36,
            validator: validTitle,
            onSaved: (v) => _cardTask = v,
            decoration: InputDecoration(
              counter: SizedBox(),
              border: InputBorder.none,
              labelText: Strings.TITLE_OF_CARD,
            ),
          ),
        ),
      );

  String validTitle(String value) {
    if (value.length > 3) return null;
    return "please enter a valid task";
  }

  Future<void> _save(BuildContext context, CardsProvider provider) async {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();
    provider.loading = true;
    await provider.addCard(columnId, _cardTask);
    provider.loading = false;
    Navigator.of(context).pop();
  }
}
