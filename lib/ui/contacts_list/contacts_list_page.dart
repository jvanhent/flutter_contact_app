import 'package:contacts_app/ui/contact/contact_create_page.dart';
import 'package:contacts_app/ui/contacts_list/widget/contact_tile.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsListPage extends StatefulWidget {
  @override
  _ContactsListPageState createState() => _ContactsListPageState();
}

class _ContactsListPageState extends State<ContactsListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contacts')),
      body: ScopedModelDescendant<ContactsModel>(
        builder: ((context, child, model) {
          return ListView.builder(
            itemCount: model.contacts.length,
            itemBuilder: (context, index) {
              return ContactTile(
                contactIndex: index,
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.person_add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ContactCreatePage()),
          );
        },
      ),
    );
  }
}
