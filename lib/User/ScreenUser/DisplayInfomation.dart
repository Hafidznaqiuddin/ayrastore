import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DisplayInfomation extends StatelessWidget {
  final List<dynamic> images;
  final String brand;
  final String model;
  final String price;
  final String detail;
  final String quantity;
  final List<dynamic> features;

  DisplayInfomation({
    required this.images,
    required this.brand,
    required this.model,
    required this.price,
    required this.detail,
    required this.quantity,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Stack(
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    aspectRatio: 16 / 9,
                    viewportFraction: 1.0,
                    enableInfiniteScroll: false,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: images.map((image) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailScreen(imageUrl: image),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  top: 20,
                  left: 5,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        brand,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'RM $price',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$model',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                      Text(
                        'Available:  $quantity',
                        style: TextStyle(fontSize: 15, color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10)
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Details ',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '$detail',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Dimensions ',
                    style: TextStyle(fontSize: 15, color: Colors.black),
                  ),
                  SizedBox(height: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: features.map((feature) {
                      return Text(
                        '• $feature',
                        style: TextStyle(fontSize: 13, color: Colors.grey),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String imageUrl;

  DetailScreen({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Background color of the app bar
        elevation: 0, // No shadow
        title: Text(
          '',
          style: TextStyle(
            color: Colors.white, // Text color of the title
            fontSize: 20, // Font size of the title
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.white, // Icon color
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back when the close button is pressed
          },
        ),
      ),
      backgroundColor: Colors.black, // Background color of the screen
      body: Center(
        child: InteractiveViewer(
          boundaryMargin: EdgeInsets.all(20.0),
          minScale: 0.1,
          maxScale: 4,
          child: Image.network(
            imageUrl,
          ),
        ),
      ),
    );
  }
}