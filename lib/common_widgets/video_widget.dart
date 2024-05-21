import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:property_rental_app/constants/app_colors.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  final String path;

  const PlayVideo({
    required this.path,
  });

  @override
  State<PlayVideo> createState() => PlayVideoState();
}

class PlayVideoState extends State<PlayVideo> {
  late VideoPlayerController videoController;
  bool isLoading = true;
  RxBool startVideo = false.obs;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    videoController = VideoPlayerController.network(widget.path)
      ..initialize().then((value) {
        setState(() {
          isLoading = false;
        });
        // videoController.setLooping(true);
        videoController.pause();
      });
    // videoController.initialize().then((_) {
    //   videoController.setLooping(true);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    videoController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (videoController.value.isPlaying) {
          videoController.pause();
          startVideo.value = false;
        } else {
          // If the video is paused, play it.
          videoController.play();
          startVideo.value = true;
        }
      },
      child: Container(
        height: 246,
        width: Get.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: videoController != null && !isLoading
            ? Stack(
                children: [
                  VideoPlayer(videoController!),
                  Positioned(
                      child: Center(
                    child: GestureDetector(
                      onTap: () {
                        if (videoController.value.isPlaying) {
                          videoController.pause();
                          startVideo.value = false;
                        } else {
                          // If the video is paused, play it.
                          videoController.play();
                          startVideo.value = true;
                        }
                      },
                      child: Obx(
                        () => startVideo.value == true
                            ? SizedBox()
                            : Image.asset(
                                'assets/images/play button.png',
                                height: 40,
                                width: 40,
                              ),
                      ),
                    ),
                  ))
                ],
              )
            : Center(
                child: CircularProgressIndicator(
                color: primaryColor,
              )),
      ),
    );
  }
}
