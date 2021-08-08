import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import 'package:chat_app_1/models/group.dart';
import 'package:chat_app_1/models/message.dart';

class Chat {
  String id;
  List<String> members;
  List<Message> messages;
  Chat({
    required this.id,
    required this.members,
    this.messages = const [],
  });

  Chat copyWith({
    String? id,
    List<String>? members,
    List<Message>? messages,
  }) {
    return Chat(
      id: id ?? this.id,
      members: members ?? this.members,
      messages: messages ?? this.messages,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'members': members,
      'messages': messages.map((x) => x.toMap()).toList(),
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      members: List<String>.from(map['members']),
      messages:
          List<Message>.from(map['messages']?.map((x) => Message.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Chat.fromJson(String source) => Chat.fromMap(json.decode(source));

  @override
  String toString() => 'Chat(id: $id, members: $members, messages: $messages)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Chat &&
        other.id == id &&
        listEquals(other.members, members) &&
        listEquals(other.messages, messages);
  }

  @override
  int get hashCode => id.hashCode ^ members.hashCode ^ messages.hashCode;

  bool get isGroup {
    return this is Group;
  }

  String get targetUser {
    if (isGroup) {
      throw Exception("There is no target user to group!");
    }
    return this
        .members
        .where((element) => element != FirebaseAuth.instance.currentUser!.uid)
        .toList()
        .first;
  }
}
