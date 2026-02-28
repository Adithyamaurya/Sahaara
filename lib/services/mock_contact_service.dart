import '../models/contact_model.dart';

class MockContactService {
  static final MockContactService _instance = MockContactService._internal();
  factory MockContactService() => _instance;

  MockContactService._internal();

  final List<ContactModel> _contacts = [
    ContactModel(id: '1', name: 'Emergency Contact 1', phone: '+91 98765 43210', relation: 'Family'),
    ContactModel(id: '2', name: 'Emergency Contact 2', phone: '+91 98765 43211', relation: 'Friend'),
    ContactModel(id: '3', name: 'Mom', phone: '+91 98765 43212', relation: 'Family'),
    ContactModel(id: '4', name: 'Neighbor', phone: '+91 98765 43213', relation: 'Neighbor'),
  ];

  List<ContactModel> getContacts() => List.from(_contacts);

  void addContact(ContactModel contact) {
    _contacts.add(contact);
  }

  void deleteContact(String id) {
    _contacts.removeWhere((c) => c.id == id);
  }
}
