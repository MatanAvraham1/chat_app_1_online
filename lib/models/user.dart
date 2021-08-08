import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  List<String> chats; // List of chats ids of the chats the user own.
  String name;
  String profilePhotoUrl;
  String id;
  User({
    required this.chats,
    required this.name,
    required this.profilePhotoUrl,
    required this.id,
  });

  User copyWith({
    List<String>? chats,
    String? name,
    String? profilePhotoUrl,
    String? id,
  }) {
    return User(
      chats: chats ?? this.chats,
      name: name ?? this.name,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chats': chats,
      'name': name,
      'profilePhotoUrl': profilePhotoUrl,
      'id': id,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      chats: List<String>.from(map['chats']),
      name: map['name'],
      profilePhotoUrl: map['profilePhotoUrl'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));

  @override
  String toString() {
    return 'User(chats: $chats, name: $name, profilePhotoUrl: $profilePhotoUrl, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        listEquals(other.chats, chats) &&
        other.name == name &&
        other.profilePhotoUrl == profilePhotoUrl &&
        other.id == id;
  }

  @override
  int get hashCode {
    return chats.hashCode ^
        name.hashCode ^
        profilePhotoUrl.hashCode ^
        id.hashCode;
  }
}
