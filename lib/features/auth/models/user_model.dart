class UserModel {
  final String uid;
  final String email;
  final String role;
  final bool isVerified;
  final bool isActive;
  final String? photoUrl;
  final String? name;
  final String? phone;

  const UserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.isVerified = false,
    this.isActive = true,
    this.photoUrl,
    this.name,
    this.phone,
  });

  UserModel copyWith({
    String? uid,
    String? email,
    String? role,
    bool? isVerified,
    bool? isActive,
    String? photoUrl,
    String? name,
    String? phone,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      role: role ?? this.role,
      isVerified: isVerified ?? this.isVerified,
      isActive: isActive ?? this.isActive,
      photoUrl: photoUrl ?? this.photoUrl,
      name: name ?? this.name,
      phone: phone ?? this.phone,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: (json['id'] ?? json['uid'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      role: (json['role'] ?? '') as String,
      isVerified: (json['is_verified'] as bool?) ?? false,
      isActive: (json['is_active'] as bool?) ?? true,
      photoUrl: json['photo_url'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': uid,
      'email': email,
      'role': role,
      'is_verified': isVerified,
      'is_active': isActive,
      if (photoUrl != null) 'photo_url': photoUrl,
      if (name != null) 'name': name,
      if (phone != null) 'phone': phone,
    };
  }
}
