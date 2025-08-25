import 'package:supabase_flutter/supabase_flutter.dart';

class UserModel {
  final String id;
  final String email;
  final String? fullName;
  final String? phone;
  final String? organization;
  final String role;
  final DateTime createdAt;
  final DateTime? updatedAt;

  UserModel({
    required this.id,
    required this.email,
    this.fullName,
    this.phone,
    this.organization,
    required this.role,
    required this.createdAt,
    this.updatedAt,
  });

  // Create UserModel from Supabase User
  factory UserModel.fromSupabaseUser(User user) {
    return UserModel(
      id: user.id,
      email: user.email ?? '',
      fullName: user.userMetadata?['full_name'] as String?,
      phone: user.phone,
      role: 'inspector',
      createdAt: DateTime.parse(user.createdAt),
      updatedAt: user.updatedAt != null
          ? DateTime.parse(user.updatedAt!)
          : null,
    );
  }

  //Create UserModel from database profile
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'] ?? '',
      fullName: json['full_name'],
      phone: json['phone'],
      organization: json['organization'],
      role: json['role'] ?? 'inspector',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'organization': organization,
      'role': role,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) {
      return fullName!;
    }
    return email;
  }

  String get initials {
    if (fullName != null && fullName!.isNotEmpty) {
      final names = fullName!.split(' ');
      if (names.length >= 2) {
        return '${names[0]}$names'.toUpperCase();
      }
      return fullName!.toUpperCase();
    }
    return email.toUpperCase();
  }


  bool get isAdmin => role == 'admin';
  bool get isInspector => role == 'inspector';
  String get formattedCreatedAt {
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }


  int get accountAgeDays {
    return DateTime.now().difference(createdAt).inDays;
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? fullName,
    String? phone,
    String? organization,
    String? role,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      organization: organization ?? this.organization,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, email: $email, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}