import 'dart:convert';

class User {
  String? username;
  String? email;

  User({this.username, this.email});

  @override
  String toString() => 'User(username: $username, email: $email)';

  factory User.fromMap(Map<String, dynamic> data) => User(
        username: data['username'] as String?,
        email: data['email'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'username': username,
        'email': email,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [User].
  factory User.fromJson(String data) {
    return User.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [User] to a JSON string.
  String toJson() => json.encode(toMap());
}
