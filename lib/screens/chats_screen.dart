import 'package:chat_app_1/models/group.dart';
import 'package:chat_app_1/screens/components/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:chat_app_1/constants/colors.dart';
import 'package:chat_app_1/models/chat.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  _ChatsScreenState createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          buildHeader(),
          buildBottom(),
        ],
      ),
    );
  }

  Align buildBottom() {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // height: 667.h,
        height: 658.h,
        decoration: BoxDecoration(
          color: isDarkMode ? chatTileBkColorD : chatTileBkColorL,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(29.r),
          ),
        ),
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error!"),
              );
            }

            var chats = snapshot.data!.get("chats");
            return ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection("chats")
                      .doc(chats[index])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error!"),
                      );
                    }

                    var chat = snapshot.data!.data();
                    // If is group
                    if (chat!["title"] != null)
                      return ChatTile(chat: Group.fromMap(chat));

                    // If is chat
                    return ChatTile(chat: Chat.fromMap(chat));
                  },
                );
              },
            );
          },
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
            fit: isDarkMode ? BoxFit.fill : BoxFit.cover),
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 56.h),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Message's (32)",
                  style: TextStyle(
                    fontFamily: "CircularStd",
                    fontSize: 18.sp,
                    color: Colors.white,
                    letterSpacing: 0.24.w,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 24.sp,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 28.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(13.r),
                  ),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 13.w, vertical: 6.h),
                    child: Text(
                      "Friends",
                      style: TextStyle(
                        color: Color(0xff6789ca),
                        fontFamily: "CircularStd",
                        letterSpacing: 0.24.w,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Text(
                  "Teachers",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "CircularStd",
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Groups",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "CircularStd",
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "Add More",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: "CircularStd",
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
