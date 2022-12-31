import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/widget/contact_form.dart';
import 'package:flutter/material.dart';

class ContactEditPage extends StatelessWidget {
  final Contact editedContact;
  final int editedContactIndex;

  ContactEditPage(
      {Key? key, required this.editedContact, required this.editedContactIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
      ),
      body: ContactForm(
        editedContact: this.editedContact,
        editedContactIndex: this.editedContactIndex,
      ),
    );
  }
}
