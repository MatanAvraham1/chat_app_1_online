import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app_1/models/message.dart';
import 'package:chat_app_1/screens/components/message_tile.dart';
import 'package:chat_app_1/screens/components/new_messages_label.dart';
import 'package:chat_app_1/screens/components/send_message_field.dart';

class ChatScreen extends StatefulWidget {
  final dynamic chat;
  final String chatProfilePhotoUrl;
  final String chatTitle;
  const ChatScreen({
    Key? key,
    required this.chat,
    required this.chatProfilePhotoUrl,
    required this.chatTitle,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late ScrollController _scrollController;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> messagesStream;

  bool get isGroup => widget.chat.isGroup;

  @override
  void initState() {
    _scrollController = ScrollController();
    messagesStream = FirebaseFirestore.instance
        .collection("chats")
        .doc(widget.chat.id)
        .snapshots();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildHeader(),
          buildBottom(),
          SendMessageField(
            chatId: widget.chat.id,
          ),
        ],
      ),
    );
  }

  Align buildBottom() {
    var _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 708.h,
        decoration: BoxDecoration(
          color: _isDarkMode ? Colors.transparent : Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(29.r),
          ),
        ),
        child: Stack(
          children: [
            StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: messagesStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error!"),
                  );
                }

                var messages = snapshot.data!.get("messages");

                if (messages.length == 0) {
                  return Center(
                    child: Text("Send first message!"),
                  );
                }

                return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length + 1,
                    itemBuilder: (context, index) => index != messages.length
                        ? MessageTile(
                            message: Message.fromMap(messages[index]),
                          )
                        : Padding(
                            padding: EdgeInsets.only(bottom: 30.h),
                          ));
              },
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 60.h, left: 6.w),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: NewMessagesLabel(
                  messagesStream: messagesStream,
                  scrollController: _scrollController,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container buildHeader() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: isDarkMode ? null : 312.h,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(isDarkMode
                ? "assets/images/backgroundD.png"
                : "assets/images/backgroundL.png"),
            fit: BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 14.h),
        child: Column(
          children: [
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 24.sp,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                        width: 7.w,
                      ),
                      CircleAvatar(
                        radius: 18.r,
                        backgroundImage:
                            NetworkImage(widget.chatProfilePhotoUrl),
                      ),
                      SizedBox(
                        width: 11.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.chatTitle,
                            style: TextStyle(
                              fontFamily: "CircularStd",
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(
                            height: 6.h,
                          ),
                          Text(
                            "Online",
                            style: TextStyle(
                              fontFamily: "CircularStd",
                              color: Colors.white54,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                      SizedBox(
                        width: 28.w,
                      ),
                      Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: 24.sp,
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
