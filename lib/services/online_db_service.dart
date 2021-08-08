import 'package:chat_app_1/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnlineDBService {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  static Future sendMessage(Message message, String chatId) async {
    await _firebaseFirestore.collection("chats").doc(chatId).update({
      "messages": FieldValue.arrayUnion([message.toMap()])
    });
  }
}
