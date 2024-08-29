import 'package:app_apponitmnet/models/chat_model.dart';
import 'package:app_apponitmnet/models/user_model.dart';
import 'package:app_apponitmnet/util/chat_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:app_apponitmnet/util/app_color.dart';
import 'package:app_apponitmnet/util/custom_text_field.dart';
import '../controllers/chat-room_controller.dart';

class ChatRoomPage extends StatefulWidget {
  final String targetUserId;
  final ChatRoomModel chatroom;

  ChatRoomPage({
    Key? key,
    required this.targetUserId,
    required this.chatroom,
  }) : super(key: key);

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late ChatController _controller;
  final TextEditingController _chatController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller = Get.put(ChatController(
      targetUserId: widget.targetUserId,
      chatroom: widget.chatroom,
    ));
    // Fetch data and listen for messages
    _controller.fetchTargetUserData(widget.targetUserId);
    _controller.messages.listen((_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom();
      });
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }

  void _showFullScreenImage(BuildContext context, {required String imageUrl}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.black,
          child: Stack(
            children: [
              Center(
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(Icons.error, color: Colors.red, size: 40),
                    );
                  },
                ),
              ),
              Positioned(
                top: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.white, size: 30),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              Positioned(
                bottom: 40,
                right: 20,
                child: IconButton(
                  icon: Icon(Icons.download, color: Colors.white, size: 30),
                  onPressed: () {
                    _controller.downloadAndSaveImage(
                      imageUrl,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showClearChatDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Clear Chat'),
          content: Text('Are you sure you want to clear the chat?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                await _controller.clearChat(); // Clear the chat
              },
              child: Text('Clear'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade300,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 90.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.r),
                    bottomRight: Radius.circular(25.r),
                  ),
                ),
                child: Obx(() {
                  return Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios_new),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        CircleAvatar(
                          radius: 25.r,
                          backgroundImage: NetworkImage(
                            _controller.targetUserImage.value ??
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRHCuAeu1euCiebE3y2qi8JJah3n_8TLJwNyg&s",
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 8.w),
                            Text(
                              _controller.targetUserName.value,
                              style: TextStyle(
                                color: AppColors.textColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Obx(
                              () => Text(
                                _controller.userActive.value
                                    ? 'Online'
                                    : 'Offline',
                                style: TextStyle(
                                  color: AppColors.textColor,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        IconButton(
                          icon: Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.clear_all),
                          ),
                          onPressed: _showClearChatDialog,
                        ),
                      ],
                    ),
                  );
                }),
              ),
              Expanded(
                child: Obx(() {
                  if (_controller.messages.isEmpty) {
                    return Center(child: Text("Say hi to your new friend"));
                  } else {
                    return ListView.builder(
                      controller: _scrollController,
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      itemCount: _controller.messages.length,
                      itemBuilder: (context, index) {
                        final message = _controller.messages[index].data()
                            as Map<String, dynamic>;
                        bool isFromTargetUser =
                            message['sender'] == _controller.targetUserId;
                        return ChatBubble(
                          isFromTargetUser: isFromTargetUser,
                          message: message,
                          onImageTap: (imageUrl) =>
                              _showFullScreenImage(context, imageUrl: imageUrl),
                        );
                      },
                    );
                  }
                }),
              ),
              Obx(() => _controller.isTyping.value
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Typing...', style: TextStyle(fontSize: 14.sp)),
                        ],
                      ),
                    )
                  : SizedBox.shrink()),
              Container(
                height: 60.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white70,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.r),
                    topRight: Radius.circular(25.r),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.image),
                        ),
                        onPressed: () => _controller.sendImage(),
                      ),
                      Expanded(
                        child: CustomTextField(
                          focusedBorderColor: AppColors.textColor,
                          borderColor: AppColors.textColor,
                          hintText: 'Type a message',
                          hintStyle: TextStyle(
                            color: AppColors.textColor,
                          ),
                          controller: _chatController,
                        ),
                      ),
                      IconButton(
                        icon: Container(
                          width: 40.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.send),
                        ),
                        onPressed: () async {
                          if (_chatController.text.trim().isNotEmpty) {
                            await _controller
                                .sendMessage(_chatController.text.toString());
                            _chatController.clear();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
