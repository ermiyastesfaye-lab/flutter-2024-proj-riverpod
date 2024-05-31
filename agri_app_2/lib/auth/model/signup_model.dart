class SignupData {
  final String id;
  final String email;
  final String role;

  SignupData({required this.id, required this.email, required this.role});

  factory SignupData.fromJson(Map<String, dynamic> json) {
    return SignupData(
      id: json['id'],
      email: json['email'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }
}
