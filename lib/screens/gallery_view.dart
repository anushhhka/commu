import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/utils/url_type_helper.dart';
import 'package:heyoo/widgets/video_player.dart';
import 'package:photo_view/photo_view.dart';

class GalleryView extends StatefulWidget {
  final List<String> mediaUrls;
  final int initialIndex;

  const GalleryView(
      {super.key, required this.mediaUrls, this.initialIndex = 0});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  late int currentIndex;
  late List<Widget> mediaWidgets;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    mediaWidgets = _buildMediaWidgets();
  }

  List<Widget> _buildMediaWidgets() {
    return widget.mediaUrls.map((url) {
      if (UrlTypeHelper.getType(url) == UrlType.VIDEO) {
        return VideoPlayerWidget(
          isFeed: false,
          videoUrl: url,
        );
      } else {
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(
            url,
          ),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.contained * 4,
        );
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: PageController(initialPage: currentIndex),
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            children: mediaWidgets,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${currentIndex + 1} / ${widget.mediaUrls.length}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
