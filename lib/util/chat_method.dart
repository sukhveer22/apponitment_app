import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/widget_extensions.dart';

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isFromTargetUser;
  final Function(String) onImageTap;

  const ChatBubble({
    Key? key,
    required this.message,
    required this.isFromTargetUser,
    required this.onImageTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (message['text'] != null && message['text'].isNotEmpty) {
      // Handle text messages
      return Align(
        alignment: isFromTargetUser ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isFromTargetUser ? Colors.blue : Colors.grey[200],
            borderRadius: BorderRadius.only(
              topRight: isFromTargetUser ? Radius.circular(8.0) : Radius.zero,
              topLeft: isFromTargetUser ? Radius.zero : Radius.circular(8.0),
              bottomLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(8.0),
            ),
          ),
          child: Text(
            message['text'],
            style: TextStyle(
              color: isFromTargetUser ? Colors.white : Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ).paddingSymmetric(horizontal: 10),
        ),
      );
    } else if (message['imageUrl'] != null && message['imageUrl'].isNotEmpty) {
      // Handle image messages
      return Align(
        alignment: isFromTargetUser ? Alignment.centerLeft : Alignment.centerRight,
        child: GestureDetector(
          onTap: () => onImageTap(message['imageUrl'].toString()),
          child: Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.symmetric(vertical: 10).copyWith(right: 15),
            decoration: BoxDecoration(
              color: isFromTargetUser ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topRight: isFromTargetUser ? Radius.circular(20.0) : Radius.zero,
                topLeft: isFromTargetUser ? Radius.zero : Radius.circular(20.0),
                bottomLeft: Radius.circular(25.0),
                bottomRight: Radius.circular(20.0),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Stack(
                children: [
                  Image.network(
                    message['imageUrl'].toString(),
                    fit: BoxFit.cover,
                    height: 200,
                    width: 200,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Icon(Icons.error, color: Colors.red, size: 40),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } else {
      // Empty container if neither text nor image is present
      return Container();
    }
  }
}
