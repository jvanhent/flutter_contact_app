import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  @override
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
          const SizedBox(height: 10),
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
            onPressed: _onSaveButtonPressed,
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
    var emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email)) return 'Invalid email';

    return null;
  }

  String? _validatePhoneNumber(String? nr) {
    if (nr == null) return 'Enter a PhoneNumber';
    if (nr.isEmpty) return 'Enter a PhoneNumber';
    var phoneRegex = RegExp(r"^\+(?:[0-9] ?){6,14}[0-9]$");
    if (!phoneRegex.hasMatch(nr)) return 'Invalid PhoneNumber';

    return null;
  }

  void _onSaveButtonPressed() {
    if (_formKey.currentState != null) {
      FormState state = _formKey.currentState!;
      if (state.validate()) {
        state.save();
        Contact newContact = Contact(
          name: _name!,
          email: _email!,
          phoneNumber: _phoneNumber!,
        );
        ContactsModel contactsModel = ScopedModel.of<ContactsModel>(context);
        contactsModel.addContact(newContact);
        print('Saved: ' + _name! + ' ' + _email! + ' ' + _phoneNumber!);
      }
    }
  }
}
