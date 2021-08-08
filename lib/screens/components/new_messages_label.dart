import 'dart:async';

import 'package:chat_app_1/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewMessagesLabel extends StatefulWidget {
  final Stream<DocumentSnapshot<Map<String, dynamic>>> messagesStream;
  final ScrollController scrollController;

  NewMessagesLabel({
    Key? key,
    required this.messagesStream,
    required this.scrollController,
  }) : super(key: key);

  @override
  _NewMessagesLabelState createState() => _NewMessagesLabelState();
}

class _NewMessagesLabelState extends State<NewMessagesLabel> {
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      messagesStreamSubscription;

  bool autoScroll =
      true; // If true - scrolling to bottom after every new message
  int newMessages = 0;

  @override
  void initState() {
    // Scroll to bottom after the build method
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      // waiting until the jumpTo method will be able to call (waiting for the listview to be completely rendered)
      while (!widget.scrollController.hasClients) {
        await Future.delayed(Duration(milliseconds: 1));
      }

      widget.scrollController.jumpTo(
        widget.scrollController.position.maxScrollExtent,
      );
    });

    messagesStreamSubscription = widget.messagesStream.listen((event) {
      // If the listview is compleyly rendered and the autoScroll is enbaled
      if (widget.scrollController.hasClients && autoScroll) {
        // Scrolling to bottom when every message sent
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }

      if (!autoScroll) {
        // If the new message has not sent by me
        if (!Message.fromMap(event.get("messages").last).sentByMe) {
          // Show the new messages
          setState(() {
            newMessages++;
          });
        }
      }
    });

    // If the user scrolling up - disabling the auto scroll until the user will click on the new messages button
    widget.scrollController.addListener(() {
      // If the listview is completly rendered
      if (widget.scrollController.hasClients) {
        if (widget.scrollController.position.userScrollDirection ==
            ScrollDirection.forward) {
          autoScroll = false;
        }
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    messagesStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return newMessages == 0
        ? Container()
        : GestureDetector(
            onTap: () {
              // If the listview is completely rendered
              if (widget.scrollController.hasClients) {
                widget.scrollController.animateTo(
                  widget.scrollController.position.maxScrollExtent,
                  duration: Duration(seconds: 1),
                  curve: Curves.fastOutSlowIn,
                );
              }

              setState(() {
                autoScroll = true;
                newMessages = 0;
              });
            },
            child: Text(
              "$newMessages new messages!",
              style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.blue,
                  fontFamily: "CiruclarStd",
                  fontWeight: FontWeight.bold),
            ),
          );
  }
}
