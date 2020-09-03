import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trello_board/providers/cards_provider.dart';
import 'package:trello_board/utils/strings.dart';

// ignore: must_be_immutable
class AddColumn extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _colTitle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Column'),
      ),
      body: _body(context),
    );
  }

  Widget _body(BuildContext context) => Column(
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
            onPressed: () => _save(context),
            child: Text(Strings.ADD_COLUMN),
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
            onSaved: (v) => _colTitle = v,
            decoration: InputDecoration(
              counter: SizedBox(),
              border: InputBorder.none,
              labelText: Strings.TITLE_OF_COLUMN,
            ),
          ),
        ),
      );

  String validTitle(String value) {
    if (value.length > 3) return null;
    return "please enter a valid title";
  }

  void _save(BuildContext context) {
    if (!_formKey.currentState.validate()) return;
    _formKey.currentState.save();

    Provider.of<CardsProvider>(context, listen: false).addColumn(_colTitle);
    Navigator.of(context).pop();
  }
}
