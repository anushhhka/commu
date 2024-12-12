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
    var carousels =
        await FirebaseFirestore.instance.collection('carousel').get();
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
    return isLoaded
        ? Container(
            margin: const EdgeInsets.all(6),
            width: double.infinity,
            child: carousel.CarouselSlider.builder(
              itemCount: carouselList.length,
              itemBuilder: (context, index, realIndex) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: CachedNetworkImage(
                    imageUrl: carouselList[index].image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                );
              },
              options: carousel.CarouselOptions(
                height: 100.0,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: 1.95,
              ),
            ),
          )
        : const SizedBox(
            height: 20,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: CircularProgressIndicator(),
              ),
            ),
          );
  }
}
