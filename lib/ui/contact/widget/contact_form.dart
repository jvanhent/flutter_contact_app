import 'package:flutter/material.dart';

class ContactForm extends StatefulWidget {
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;

  String? _email = '';
  String? _phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _name = newValue,
            validator: _validateName,
            decoration: InputDecoration(
                labelText: 'Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _email = newValue,
            validator: _validateEmail,
            decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          TextFormField(
            onSaved: (newValue) => _phoneNumber = newValue,
            validator: _validatePhoneNumber,
            decoration: InputDecoration(
                labelText: 'Phone Number',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            //style: ElevatedButton.styleFrom(foregroundColor: Colors.black),
            onPressed: () {
              if (true == _formKey.currentState?.validate()) {
                _formKey.currentState?.save();
                print('Saved: ' + _name! + ' ' + _email! + ' ' + _phoneNumber!);
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Save'),
                Icon(
                  Icons.person,
                  size: 18,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _validateName(String? name) {
    if (name == null) return 'Enter a name';
    if (name.isEmpty) return 'Enter a name';

    return null;
  }

  String? _validateEmail(String? email) {
    if (email == null) return 'Enter a email';
    if (email.isEmpty) return 'Enter a email';
    var emailRegex = RegExp( r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) return 'Invalid email';

    return null;
  }

  String? _validatePhoneNumber(String? nr) {
    if (nr == null) return 'Enter a PhoneNumber';
    if (nr.isEmpty) return 'Enter a PhoneNumber';
    var phoneRegex = RegExp( r"^\+(?:[0-9] ?){6,14}[0-9]$");
    if (!phoneRegex.hasMatch(nr)) return 'Invalid PhoneNumber';

    return null;
  }
}
