import 'package:flutter/material.dart';
import 'package:heyoo/localization/language_constants.dart';
import 'package:heyoo/widgets/carousel_slider.dart';

class AdvertisementScreen extends StatelessWidget {
  const AdvertisementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTranslated(context, 'advertisement')),
        centerTitle: true,
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: CarouselSlider(),
            ),
          ],
        ),
      ),
    );
  }
}
