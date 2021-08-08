import 'package:chat_app_1/models/message.dart';
import 'package:chat_app_1/services/online_db_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SendMessageField extends StatefulWidget {
  final String chatId;
  const SendMessageField({Key? key, required this.chatId}) : super(key: key);

  @override
  _SendMessageFieldState createState() => _SendMessageFieldState();
}

class _SendMessageFieldState extends State<SendMessageField> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 50.h,
        color: Color(0xffeaeeef),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textEditingController,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontFamily: "CircularStd",
                    color: Color(0xff262626),
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      fontSize: 16.sp,
                      fontFamily: "CircularStd",
                      color: Color(0xff262626),
                      fontWeight: FontWeight.w400,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.attach_file,
                    size: 24.sp,
                    color: Color(0xffb8b8b8),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Icon(
                    Icons.mic,
                    size: 24.sp,
                    color: Color(0xffb8b8b8),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  GestureDetector(
                    onTap: () async {
                      if (_textEditingController.value.text != "") {
                        await OnlineDBService.sendMessage(
                            Message.byMe(
                                content: _textEditingController.value.text),
                            widget.chatId);
                        setState(() {
                          _textEditingController.clear();
                        });
                      }
                    },
                    child: SvgPicture.asset(
                      "assets/images/send.svg",
                      width: 24.sp,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
