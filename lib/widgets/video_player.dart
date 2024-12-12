// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  var videoUrl;
  bool isFeed;

  VideoPlayerWidget({
    super.key,
    required this.videoUrl,
    required this.isFeed,
  });

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  bool isMuted = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _controller.value.isInitialized
          ? widget.isFeed
              ? Stack(
                  children: [
                    VideoPlayer(_controller),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.value.isPlaying
                                    ? _controller.pause()
                                    : _controller.play();
                              });
                            },
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          Expanded(
                            child: VideoProgressIndicator(
                              _controller,
                              allowScrubbing: true,
                              colors: const VideoProgressColors(
                                playedColor: Colors.white,
                                backgroundColor: Colors.black26,
                              ),
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                isMuted = !isMuted;
                                isMuted
                                    ? _controller.setVolume(0.0)
                                    : _controller.setVolume(1.0);
                              });
                            },
                            icon: isMuted
                                ? const Icon(
                                    Icons.volume_off,
                                    color: Colors.white,
                                  )
                                : const Icon(
                                    Icons.volume_up,
                                    color: Colors.white,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    children: [
                      VideoPlayer(_controller),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: VideoProgressIndicator(
                                _controller,
                                allowScrubbing: true,
                                colors: const VideoProgressColors(
                                  playedColor: Colors.white,
                                  backgroundColor: Colors.black26,
                                ),
                                padding: const EdgeInsets.all(8),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isMuted = !isMuted;
                                  isMuted
                                      ? _controller.setVolume(0.0)
                                      : _controller.setVolume(1.0);
                                });
                              },
                              icon: isMuted
                                  ? const Icon(
                                      Icons.volume_off,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.volume_up,
                                      color: Colors.white,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
