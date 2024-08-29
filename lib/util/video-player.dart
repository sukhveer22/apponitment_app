// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoUrl;
//
//   VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);
//
//   @override
//   _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   bool _isPlaying = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.network(widget.videoUrl)
//       ..initialize().then((_) {
//         setState(() {});
//       });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Video Player'),
//       ),
//       body: Center(
//         child: _controller.value.isInitialized
//             ? Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             AspectRatio(
//               aspectRatio: _controller.value.aspectRatio,
//               child: VideoPlayer(_controller),
//             ),
//             SizedBox(height: 20),
//             _buildControls(),
//           ],
//         )
//             : CircularProgressIndicator(),
//       ),
//     );
//   }
//
//   Widget _buildControls() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         IconButton(
//           icon: Icon(
//             _isPlaying ? Icons.pause : Icons.play_arrow,
//             color: Colors.white,
//           ),
//           onPressed: () {
//             setState(() {
//               if (_isPlaying) {
//                 _controller.pause();
//               } else {
//                 _controller.play();
//               }
//               _isPlaying = !_isPlaying;
//             });
//           },
//         ),
//         IconButton(
//           icon: Icon(Icons.stop, color: Colors.white),
//           onPressed: () {
//             setState(() {
//               _controller.pause();
//               _controller.seekTo(Duration.zero);
//               _isPlaying = false;
//             });
//           },
//         ),
//       ],
//     );
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }
