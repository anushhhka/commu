import 'package:flutter/material.dart';
import 'package:heyoo/widgets/carousel_slider.dart';

class FeedsScreen extends StatelessWidget {
  const FeedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CarouselSlider(),
          ],
        ),
      ),
    );
  }
}
