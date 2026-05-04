class Customer {
  final int? id;
  final String firstName;
  final String lastName;
  final String phone;

  Customer({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  // This converts JSON from Java into a Flutter Object
  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
