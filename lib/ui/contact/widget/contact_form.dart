import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name = '';
  String? _email = '';
  String? _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(onSaved: (newValue) => _name = newValue),
          TextFormField(onSaved: (newValue) => _email = newValue),
          TextFormField(onSaved: (newValue) => _phoneNumber = newValue),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.save();
              print(_name! + ' ' + _email! + ' ' + _phoneNumber!);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }
}
