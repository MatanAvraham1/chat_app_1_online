import 'package:chat_app_1/models/chat.dart';
import 'package:chat_app_1/models/group.dart';
import 'package:chat_app_1/screens/chat_screen.dart';
import 'package:chat_app_1/services/time_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTile extends StatelessWidget {
  final dynamic chat;

  const ChatTile({
    Key? key,
    required this.chat,
  }) : super(key: key);

  bool get isGroup => chat.isGroup;

  String get lastMessageContent =>
      chat.messages.length == 0 ? "" : chat.messages.last.content;

  String get lastMessageSentTime => chat.messages.length == 0
      ? ""
      : getShortTime(this.chat!.messages.last.sentAt);

  @override
  Widget build(BuildContext context) {
    int newMessages = 0;

    if (isGroup)
      return buildWidget(
          chatProfilePhotoUrl: chat.profilePhotoUrl,
          chatTitle: chat.title,
          context: context,
          newMessages: newMessages);

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("users")
          .doc(chat!.targetUser)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Container(
              height: 10.h,
              width: 10.w,
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text("Error!"),
          );
        }

        String chatProfilePhotoUrl = snapshot.data!.get("profilePhotoUrl");
        String chatTitle = snapshot.data!.get("name");

        return buildWidget(
            context: context,
            chatProfilePhotoUrl: chatProfilePhotoUrl,
            chatTitle: chatTitle,
            newMessages: newMessages);
      },
    );
  }

  InkWell buildWidget(
      {required BuildContext context,
      required String chatProfilePhotoUrl,
      required String chatTitle,
      required int newMessages,
      Chat? chat,
      Group? group}) {
    bool _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatScreen(
            chat: this.chat,
            chatProfilePhotoUrl: chatProfilePhotoUrl,
            chatTitle: chatTitle,
          ),
        ));
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 28.r,
                      backgroundImage: NetworkImage(chatProfilePhotoUrl),
                    ),
                    SizedBox(
                      width: 12.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chatTitle,
                          style: TextStyle(
                            fontFamily: "CircularStd",
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 7.h,
                        ),
                        Text(
                          lastMessageContent,
                          style: TextStyle(
                            color: Color(0xff828282),
                            fontFamily: "CircularStd",
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    newMessages > 0
                        ? Container(
                            height: 18.h,
                            width: 18.w,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff6848bf),
                            ),
                            child: Center(
                              child: Text(
                                newMessages.toString(),
                                style: TextStyle(
                                    fontFamily: "CircularStd",
                                    fontSize: 10.sp,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        : Container(
                            height: 18.h,
                            width: 18.h,
                          ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      lastMessageSentTime,
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Color(0xff828282),
                          fontFamily: "CircularStd",
                          fontWeight: FontWeight.w400),
                    )
                  ],
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Divider(
              thickness: 2.h,
              color: _isDarkMode ? Color(0xff7a7c7f) : null,
            ),
          ],
        ),
      ),
    );
  }
}
