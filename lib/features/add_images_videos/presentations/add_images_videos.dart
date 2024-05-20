import 'dart:io';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddImagesVideos extends StatefulWidget {
  const AddImagesVideos({super.key});

  @override
  State<AddImagesVideos> createState() => _AddImagesVideosState();
}

class _AddImagesVideosState extends State<AddImagesVideos> {
  File? image;
  File? video;
  final picker = ImagePicker();
  late VideoPlayerController videoPlayerController;

  pickImageFromGallery() async {
    final XFile? pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    if (pickedImage != null) {
      setState(() {
        image = File(pickedImage.path);
      });
    }
  }

  pickVideoFromGallery() async {
    final XFile? pickedVideo = await picker.pickVideo(
      source: ImageSource.gallery,
    );

    if (pickedVideo != null) {
      video = File(pickedVideo.path);
      videoPlayerController = VideoPlayerController.file(video!)
        ..initialize().then((_) {
          setState(() {});
          videoPlayerController.pause();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: pickImageFromGallery,
                child: const Text('Add Images'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: pickVideoFromGallery,
                child: const Text('Add Videos'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          image != null
              ? SizedBox(
                  width: 130,
                  height: 170,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      image!,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 20),
          video != null
              ? videoPlayerController.value.isInitialized
                  ? SizedBox(
                      width: 130,
                      height: 170,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GestureDetector(
                            onTap: () {
                              if (videoPlayerController.value.isPlaying) {
                                videoPlayerController.pause();
                              } else {
                                videoPlayerController.play();
                              }
                            },
                            child: VideoPlayer(videoPlayerController)),
                      ),
                    )
                  : const SizedBox.shrink()
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
