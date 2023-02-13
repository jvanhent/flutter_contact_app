import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/contact/contact_edit_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
        extentRatio: 0.3,
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),
        // A pane can dismiss the Slidable.
        //dismissible: DismissiblePane(onDismissed: () {}),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (_) {
              model.deleteContact(contact);
            },
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      startActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const BehindMotion(),
        // A pane can dismiss the Slidable.
        //dismissible: DismissiblePane(onDismissed: () {}),
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (bc) => this._callPhoneNumber(bc, contact.phoneNumber),
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: Icons.phone,
            label: 'Call',
          ),
          SlidableAction(
            onPressed: (bc) => this._writeEmail(bc, contact.email),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.mail,
            label: 'Email',
          ),
        ],
      ),
      child: _buildContent(contact, model, context),
    );
  }

  Future _callPhoneNumber(
    BuildContext context,
    String number,
  ) async {
    final uri = Uri.parse('tel:${number}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot make a call'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }

  Future _writeEmail(
    BuildContext context,
    String mailTo,
  ) async {
    final uri = Uri.parse('mailto:${mailTo}');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      final snackbar = SnackBar(
        content: Text('Cannot write an email'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
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
          model.changeFavoriteStatus(contact);
        },
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ContactEditPage(
            editedContact: contact,
          ),
        ));
      },
    );
  }

  Widget _buildCircleAvatar(Contact contact) {
    return Hero(
      tag: contact.hashCode,
      child: _buildAvatar(contact),
    );
  }

  CircleAvatar _buildAvatar(Contact contact) {
    return CircleAvatar(
      child: _buildAvatarContent(contact),
    );
  }

  Widget _buildAvatarContent(Contact contact) {
    if (contact.imagePath == null) {
      return Text(contact.name[0].toUpperCase());
    }
    var img = kIsWeb
        ? Image.network(contact.imagePath!, fit: BoxFit.cover)
        : Image.file(File(contact.imagePath!), fit: BoxFit.cover);

    return ClipOval(
      child: AspectRatio(
        aspectRatio: 1,
        child: img,
      ),
    );
  }
}
