import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:heyoo/models/carousel_model.dart';

class CarouselSlider extends StatefulWidget {
  const CarouselSlider({super.key});

  @override
  State<CarouselSlider> createState() => _CarouselSliderState();
}

class _CarouselSliderState extends State<CarouselSlider> {
  List<CarouselModel> carouselList = [];
  bool isLoaded = false;

  @override
  void initState() {
    fetchCarousel();
    super.initState();
  }

  fetchCarousel() async {
    var carousels = await FirebaseFirestore.instance.collection('carousel').get();
    mapRecords(carousels);
  }

  mapRecords(QuerySnapshot<Map<String, dynamic>> records) {
    var list = records.docs
        .map(
          (item) => CarouselModel(
            image: item['image'],
          ),
        )
        .toList();
    setState(() {
      isLoaded = true;
      carouselList = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return isLoaded
        ? SizedBox(
            width: screenWidth, // Explicitly set the width to the screen width
            child: carousel.CarouselSlider.builder(
              itemCount: carouselList.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(15), // Adjust as needed
                  child: CachedNetworkImage(
                    imageUrl: carouselList[index].image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                );
              },
              options: carousel.CarouselOptions(
                height: screenHeight * 0.23, // Set height to 15% of the screen height
                enlargeCenterPage: false, // Disable scaling to prevent shrinking effect
                autoPlay: true,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayInterval: const Duration(seconds: 10),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.0, // Each item takes 100% width
              ),
            ),
          )
        : const SizedBox(
            height: 20,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
