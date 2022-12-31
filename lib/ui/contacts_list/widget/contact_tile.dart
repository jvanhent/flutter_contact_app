import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return Slidable(
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const StretchMotion(),
        // A pane can dismiss the Slidable.
        //dismissible: DismissiblePane(onDismissed: () {}),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) {
              model.deleteContact(contactIndex);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: _buildContent(contact, model, context),
    );
  }

  ListTile _buildContent(
    Contact contact,
    ContactsModel model,
    BuildContext context,
  ) {
    return ListTile(
      title: Text(contact.name),
      subtitle: Text(contact.email),
      leading: _buildCircleAvatar(contact),
      trailing: IconButton(
        icon: Icon(contact.isFavorite ? Icons.star : Icons.star_border),
        color: contact.isFavorite ? Colors.amber : Colors.grey,
        onPressed: () {
          model.changeFavoriteStatus(contactIndex);
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ContactEditPage(
              editedContact: contact, editedContactIndex: this.contactIndex),
        ));
      },
    );
  }

  Widget _buildCircleAvatar(Contact contact) {
    return Hero(
      tag: contact.hashCode,
      child: CircleAvatar(
        child: Text(contact.name[0].toUpperCase()),
      ),
    );
  }
}
