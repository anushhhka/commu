import 'package:flutter/material.dart';

class GeneralContactScreen extends StatelessWidget {
  // List of images (add the actual image URLs or paths)
  final List<String> imagePaths = [
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
    'images/da.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("General Contact")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 items per row
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          itemCount: imagePaths.length, // Total number of items in grid
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Navigate to the next screen when an image is tapped
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InfoScreen(imageIndex: index),
                  ),
                );
              },
              child: GridTile(
                child: Column(
                  children: [
                    Expanded(
                      child: Image.asset(
                        imagePaths[index],
                        fit: BoxFit.cover, // Scale image to fill the space
                      ),
                    ),
                    SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        // Handle the click on the text for info as well
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => InfoScreen(imageIndex: index),
                          ),
                        );
                      },
                      child: Text(
                        "Click here for info",
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class InfoScreen extends StatelessWidget {
  final int imageIndex;

  InfoScreen({required this.imageIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Info for Image $imageIndex")),
      body: Center(
        child: Text(
          "Detailed information about image $imageIndex goes here.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
