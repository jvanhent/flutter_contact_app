import 'package:contacts_app/data/contact.dart';
import 'package:faker/faker.dart';
import 'package:scoped_model/scoped_model.dart';

class ContactsModel extends Model {
  List<Contact> _contacts = List.generate(5, (index) {
    return Contact(
      name: faker.person.firstName(),
      email: faker.internet.freeEmail(),
      phoneNumber: faker.phoneNumber.de(),
    );
  });

  List<Contact> get contacts => _contacts;

  void addContact(Contact contact) {
    _contacts.add(contact);
    notifyListeners();
    print(_contacts.length);
  }

  void updateContact(Contact contact, int index) {
    _contacts[index] = contact;
    notifyListeners();
  }

  void changeFavoriteStatus(int index) {
    Contact contact = _contacts[index];
    contact.isFavorite = !contact.isFavorite;
    _sortContacts();
    notifyListeners();
  }

  void _sortContacts() {
    _contacts.sort((a, b) {
      int comp = _compareBasedOnFavoriteStatus(a, b);
      if (comp == 0) comp = _compareBasedOnName(a, b);
      return comp;
    });
  }

  int _compareBasedOnFavoriteStatus(Contact a, Contact b) {
    if (a.isFavorite) return -1;
    if (b.isFavorite) return 1;
    return 0;
  }

  int _compareBasedOnName(Contact a, Contact b) {
    return a.name.compareTo(b.name);
  }
}
