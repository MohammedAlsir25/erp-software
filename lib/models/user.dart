class User {
  final String id;
  String username;
  String email;
  String password;
  bool isVerified;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    this.isVerified = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      isVerified: json['isVerified'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'isVerified': isVerified ? 1 : 0,
    };
  }
}
