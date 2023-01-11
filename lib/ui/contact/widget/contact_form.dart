import 'dart:io';

import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactForm extends StatefulWidget {
  final Contact? editedContact;

  ContactForm({Key? key, this.editedContact}) : super(key: key);

  @override
  _ContactFormState createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  String? _email = '';
  String? _phoneNumber = '';
  String? _imagePath;

  bool get isEditMode => widget.editedContact != null;
  bool get hasSelectedCustomImage => _imagePath != null;

  @override
  initState() {
    super.initState();
    this._imagePath = widget.editedContact?.imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          const SizedBox(height: 10),
          _buildContactPicture(),
          const SizedBox(height: 10),
          TextFormField(
            initialValue: widget.editedContact?.name,
            onSaved: (newValue) => _name = newValue,
            validator: _validateName,
            decoration: InputDecoration(
                labelText: 'Name',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: widget.editedContact?.email,
            onSaved: (newValue) => _email = newValue,
            validator: _validateEmail,
            decoration: InputDecoration(
                labelText: 'Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
          ),
          SizedBox(height: 10),
          TextFormField(
            initialValue: widget.editedContact?.phoneNumber,
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

  Widget _buildContactPicture() {
    final double radius = MediaQuery.of(context).size.width / 4;
    return Hero(
      tag: widget.editedContact.hashCode,
      child: GestureDetector(
        onTap: _onContactPictureTapped,
        child: CircleAvatar(
          radius: radius,
          child: _buildAvatarContent(radius),
        ),
      ),
    );
  }

  void _onContactPictureTapped() async {
    var imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (imageFile != null)
      setState(() {
        this._imagePath = imageFile.path;
      });
  }

  Widget _buildAvatarContent(double radius) {
    if (this.isEditMode || this.hasSelectedCustomImage) {
      if (this._imagePath == null)
        return Text(widget.editedContact!.name[0],
            style: TextStyle(fontSize: radius));
      return _buildOvalFromCustomImage();
    } else {
      return Icon(
        Icons.person,
        size: radius,
      );
    }
  }

  ClipOval _buildOvalFromCustomImage() {
    var img = kIsWeb
        ? Image.network(this._imagePath!, fit: BoxFit.cover)
        : Image.file(File(this._imagePath!), fit: BoxFit.cover);

    return ClipOval(
      child: AspectRatio(
        aspectRatio: 1,
        child: img,
      ),
    );
  }

  String? _validateName(String? name) {
    if (name?.isEmpty ?? false) return 'Enter a name';

    return null;
  }

  String? _validateEmail(String? email) {
    if (email?.isEmpty ?? false) return 'Enter a email';
    var emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    if (!emailRegex.hasMatch(email!)) return 'Invalid email';

    return null;
  }

  String? _validatePhoneNumber(String? nr) {
    if (nr?.isEmpty ?? false) return 'Enter a PhoneNumber';
    var phoneRegex = RegExp(r"[0-9]{6,14}");
    if (!phoneRegex.hasMatch(nr!)) return 'Invalid PhoneNumber';

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
          isFavorite: widget.editedContact?.isFavorite ?? false,
          imagePath: _imagePath,
        );
        ContactsModel contactsModel = ScopedModel.of<ContactsModel>(context);
        if (this.isEditMode) {
          newContact.id = widget.editedContact?.id;
          contactsModel.updateContact(newContact);
        } else {
          contactsModel.addContact(newContact);
        }

        print('Saved: ' + _name! + ' ' + _email! + ' ' + _phoneNumber!);
        Navigator.of(context).pop();
      }
    }
  }
}
