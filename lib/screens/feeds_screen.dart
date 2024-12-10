import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/models/feeds_model.dart';
import 'package:heyoo/screens/profile/profile_screen.dart';
import 'package:heyoo/widgets/carousel_slider.dart';
import 'package:heyoo/widgets/feed_tile.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  List<FeedsModel> feedslList = [];
  bool isLoaded = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    fetchFeeds();
    super.initState();
  }

  fetchFeeds() async {
    var feeds = await FirebaseFirestore.instance.collection('feeds').get();
    mapRecords(feeds);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map(
          (item) => FeedsModel(
            text: item.data().containsKey('text') ? item['text'] : null,
            image: item.data().containsKey('image') ? item['image'] : null,
          ),
        )
        .toList();
    setState(() {
      isLoaded = true;
      feedslList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Nana Asambia'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: const Drawer(
        child: ProfileScreen(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CarouselSlider(),
            !isLoaded
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: feedslList.length,
                      itemBuilder: (context, index) {
                        return FeedTile(
                          text: feedslList[index].text,
                          image: feedslList[index].image,
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
