import 'package:flutter/material.dart';
import 'package:heyoo/config/themes/typograph.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/screens/advertisement_screen.dart';
import 'package:heyoo/screens/contact_screen.dart';
import 'package:heyoo/screens/gallery_screen.dart';
import 'package:heyoo/screens/profile/niyani_address_book.dart';
import 'package:heyoo/screens/profile/profile_screen.dart';
import 'package:heyoo/screens/profile/village_member_address_book.dart';
import 'package:url_launcher/url_launcher.dart';

class OptionScreen extends StatelessWidget {
  OptionScreen({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> screens = const [
    VillageMemberAddressBook(),
    NiyaniAddressBook(),
    GalleryScreen(),
    ContactAddress(),
    AdvertisementScreen(),
    ContactAddress(),
    // CommitteeScreen(),
    // PatrikaScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final List<String> options = [
      getTranslated(context, 'village_member'),
      getTranslated(context, 'niyani'),
      getTranslated(context, 'gallery'),
      getTranslated(context, 'support'),
      getTranslated(context, 'advertisement'),
      getTranslated(context, 'patrika'),
    ];

    final List<IconData> icons = [
      Icons.people,
      Icons.person,
      Icons.photo_album,
      Icons.support_agent,
      Icons.ad_units,
      Icons.book,
    ];

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(getTranslated(context, 'options')),
        automaticallyImplyLeading: false,
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
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(6, (index) {
            return Center(
              child: GestureDetector(
                onTap: () async {
                  if (index == options.length - 1) {
                    // Open link for the last index
                    final Uri url = Uri.parse('https://www.kutchipatrika.org');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  } else {
                    // Navigate to the corresponding screen for other indices
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => screens[index]),
                    );
                  }
                },
                child: Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    color: Colors.blue[100 * (index + 1 % 9)],
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icons[index],
                          size: 50,
                          color: Colors.black,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          options[index],
                          style: Typo.bodyLarge.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
