import 'package:contacts_app/data/contact.dart';
import 'package:contacts_app/data/db/app_db.dart';
import 'package:sembast/sembast.dart';

class ContactDao {
  static const String CONTACT_STORE_NAME = 'contacts';
  final _contactStore = intMapStoreFactory.store(CONTACT_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Contact contact) async {
    int key = await _contactStore.add(
      await _db,
      contact.toMap(),
    );
    contact.id = key;
  }

  Future update(Contact contact) async {
    var finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.update(
      await _db,
      contact.toMap(),
      finder: finder,
    );
  }

  Future delete(Contact contact) async {
    var finder = Finder(filter: Filter.byKey(contact.id));
    await _contactStore.delete(
      await _db,
      finder: finder,
    );
  }

  Future<List<Contact>> getAllInSortedOrder() async {
    var finder = Finder(sortOrders: [
      SortOrder('isFavorite', false),
      SortOrder('name'),
    ]);
    final snapshots = await _contactStore.find(
      await _db,
      finder: finder,
    );
    return snapshots.map((sn) {
      var c = Contact.fromMap(sn.value);
      c.id = sn.key;
      return c;
    }).toList();
  }
}
