import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/models/feeds_model.dart';
import 'package:heyoo/screens/notification_screen.dart';
import 'package:heyoo/screens/profile/profile_screen.dart';
import 'package:heyoo/widgets/carousel_slider.dart';
import 'package:heyoo/widgets/feed_tile.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  // Function to fetch feeds from Firestore
  Future<List<FeedsModel>> fetchFeeds() async {
    var feeds = await FirebaseFirestore.instance.collection('feeds').get();
    return mapRecords(feeds);
  }

  // Method to map the records from Firestore to FeedsModel
  List<FeedsModel> mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    return records.docs
        .map(
          (item) => FeedsModel(
              text: item.data().containsKey('text') ? item['text'] : null,
              image: item.data().containsKey('image') ? item['image'] : null,
              createdAt: item.data().containsKey('createdAt') ? item['createdAt'] : null),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(getTranslated(context, 'nana_asambia')),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const NotificationsScreen()));
            },
          ),
        ],
      ),
      drawer: const Drawer(
        child: ProfileScreen(),
      ),
      body: SafeArea(
        child: FutureBuilder<List<FeedsModel>>(
          future: fetchFeeds(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No Feeds Available'));
            } else {
              var feedslList = snapshot.data!;
              return Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: CarouselSlider(),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: feedslList.length,
                      itemBuilder: (context, index) {
                        return FeedTile(
                          text: feedslList[index].text,
                          image: feedslList[index].image,
                          createdAt: feedslList[index].createdAt!,
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
