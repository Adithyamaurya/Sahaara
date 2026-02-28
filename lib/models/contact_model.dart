class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String? relation;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    this.relation,
  });
}
