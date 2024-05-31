class AuthLoginData {
  final String token;
  final int id;

  const AuthLoginData({required this.token, required this.id});

  // Factory constructor to create an instance from JSON
  factory AuthLoginData.fromJson(Map<String, dynamic> json) {
    return AuthLoginData(
      token: json['token'],
      id: json['id'],
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'id': id,
    };
  }

  // Override equality operator
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthLoginData && other.token == token && other.id == id;
  }

  // Override hashCode
  @override
  int get hashCode => token.hashCode ^ id.hashCode;

  // Copy method
  AuthLoginData copyWith({
    String? token,
    int? id,
  }) {
    return AuthLoginData(
      token: token ?? this.token,
      id: id ?? this.id,
    );
  }

  // Documentation or comments can be added here
  // to explain the purpose of this class and its members.
}
