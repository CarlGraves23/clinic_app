class UserModel {
  String? id;
  String? email;
  String? name;
  String? phone;
  String? role;
  DateTime? createdAt;

  UserModel({
    this.id,
    this.email,
    this.name,
    this.phone,
    this.role,
    this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'createdAt': createdAt,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'],
      createdAt: json['createdAt'] != null ? (json['createdAt'] as DateTime) : null,
    );
  }
}