import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';

class Message {
  String senderId; // The id of the user sender
  String content;
  DateTime sentAt;
  Message({
    required this.senderId,
    required this.content,
    required this.sentAt,
  });

  Message.byMe({
    required this.content,
  })  : this.senderId = FirebaseAuth.instance.currentUser!.uid,
        this.sentAt = DateTime.now();

  Message copyWith({
    String? senderId,
    String? content,
    DateTime? sentAt,
  }) {
    return Message(
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      sentAt: sentAt ?? this.sentAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'content': content,
      'sentAt': sentAt.millisecondsSinceEpoch,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'],
      content: map['content'],
      sentAt: DateTime.fromMillisecondsSinceEpoch(map['sentAt']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Message.fromJson(String source) =>
      Message.fromMap(json.decode(source));

  @override
  String toString() =>
      'Message(senderId: $senderId, content: $content, sentAt: $sentAt)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Message &&
        other.senderId == senderId &&
        other.content == content &&
        other.sentAt == sentAt;
  }

  @override
  int get hashCode => senderId.hashCode ^ content.hashCode ^ sentAt.hashCode;

  bool get sentByMe => this.senderId == FirebaseAuth.instance.currentUser!.uid;
}
