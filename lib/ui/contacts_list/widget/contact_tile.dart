import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactTile extends StatelessWidget {
  final int contactIndex;

  const ContactTile({
    super.key,
    required this.contactIndex,
  });

  @override
  Widget build(BuildContext context) {
    final model = ScopedModel.of<ContactsModel>(context);
    final Contact contact = model.contacts[contactIndex];
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.email),
      trailing: IconButton(
        icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border),
        color: contact.isFavorite ? Colors.amber : Colors.grey,
        onPressed: () {
          model.changeFavoriteStatus(contactIndex);
        },
      ),
    );
  }
}
