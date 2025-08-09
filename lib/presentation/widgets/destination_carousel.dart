import 'package:flutter/material.dart';

class DestinationCarousel extends StatelessWidget {
  final double screenWidth;

  const DestinationCarousel({super.key, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Padding(
          padding: const EdgeInsets.only(top: 24), // <-- margen arriba
          child: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Popular destinations",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: screenWidth * 0.45,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                _destinationCard("Paris", "assets/paris.jpg", screenWidth),
                _destinationCard("Singapore", "assets/singapur.jpg", screenWidth),
                _destinationCard("Sydney", "assets/sydney.jpg", screenWidth),
                _destinationCard("Rome", "assets/sydney.jpg", screenWidth),
                const SizedBox(width: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _destinationCard(String city, String imagePath, double screenWidth) {
    return Container(
      width: screenWidth * 0.35,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        padding: const EdgeInsets.all(8),
        alignment: Alignment.bottomLeft,
        child: Text(
          city,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
