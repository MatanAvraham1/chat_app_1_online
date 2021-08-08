import 'package:chat_app_1/models/message.dart';
import 'package:chat_app_1/services/time_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatelessWidget {
  final Message message;

  const MessageTile({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          message.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 30.h),
        child: Column(
          crossAxisAlignment: message.sentByMe
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 25.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: message.sentByMe ? Color(0xffe0d5ff) : Color(0xffebebeb),
                borderRadius: BorderRadius.only(
                  topLeft:
                      message.sentByMe ? Radius.circular(20.r) : Radius.zero,
                  bottomLeft: Radius.circular(20.r),
                  bottomRight: Radius.circular(20.r),
                  topRight:
                      message.sentByMe ? Radius.zero : Radius.circular(20.r),
                ),
              ),
              child: Text(
                message.content,
                style: TextStyle(
                  fontFamily: "CircularStd",
                  color: Colors.black,
                  fontSize: 13.sp,
                ),
              ),
            ),
            SizedBox(
              height: 7.h,
            ),
            Text(
              getShortTime(message.sentAt),
              style: TextStyle(
                fontSize: 11.sp,
                fontFamily: "CiruclarStd",
                color: Color(0xff979797),
              ),
            )
          ],
        ),
      ),
    );
  }
}
