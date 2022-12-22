import 'package:flutter/material.dart';
import 'package:contacts_app/ui/contact/widget/contact_form.dart';

class ContactCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create'),
      ),
      body: ContactForm(),
    );
  }

}
