class UserModel {
  final String id;
  final String name;
  final String email;
  final bool isVerified;
  final String role;
  final String qrCode;
  final String qrCodeUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.isVerified,
    required this.role,
    required this.qrCode,
    required this.qrCodeUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      isVerified: json['isVerified'],
      role: json['role'],
      qrCode: json['qrCode'],
      qrCodeUrl: json['qrCodeUrl'],
    );
  }
}
