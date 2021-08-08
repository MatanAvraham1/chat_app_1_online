import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:chat_app_1/models/chat.dart';
import 'package:chat_app_1/models/message.dart';

class Group extends Chat {
  String title;
  String id;
  String profilePhotoUrl;
  List<Message> messages;
  List<String> members;

  Group(
    this.title,
    this.id,
    this.profilePhotoUrl,
    this.messages,
    this.members,
  ) : super(
          id: id,
          members: members,
          messages: messages,
        );

  Group copyWith({
    String? title,
    String? id,
    String? profilePhotoUrl,
    List<Message>? messages,
    List<String>? members,
  }) {
    return Group(
      title ?? this.title,
      id ?? this.id,
      profilePhotoUrl ?? this.profilePhotoUrl,
      messages ?? this.messages,
      members ?? this.members,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'id': id,
      'profilePhotoUrl': profilePhotoUrl,
      'messages': messages.map((x) => x.toMap()).toList(),
      'members': members,
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      map['title'],
      map['id'],
      map['profilePhotoUrl'],
      List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
      List<String>.from(map['members']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Group.fromJson(String source) => Group.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Group(title: $title, id: $id, profilePhotoUrl: $profilePhotoUrl, messages: $messages, members: $members)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Group &&
        other.title == title &&
        other.id == id &&
        other.profilePhotoUrl == profilePhotoUrl &&
        listEquals(other.messages, messages) &&
        listEquals(other.members, members);
  }

  @override
  int get hashCode {
    return title.hashCode ^
        id.hashCode ^
        profilePhotoUrl.hashCode ^
        messages.hashCode ^
        members.hashCode;
  }
}
