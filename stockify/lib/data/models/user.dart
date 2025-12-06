class User {
  final int id;
  final String email;
  final String? fullName;

  User({
    required this.id,
    required this.email,
    this.fullName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int 
          ? json['id'] as int 
          : int.tryParse(json['id'].toString()) ?? 0,
      email: json['email'] as String,
      fullName: json['full_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'full_name': fullName,
    };
  }
}

