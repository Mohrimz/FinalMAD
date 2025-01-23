import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String backgroundImage;
  final double? height; 

  const HeaderWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.backgroundImage,
    this.height = 250, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundImage,
          width: double.infinity,
          height: height, 
          fit: BoxFit.cover,
        ),
        Container(
          width: double.infinity,
          height: height, 
          color: Colors.black.withOpacity(0.5),
        ),
        Positioned(
          left: 20,
          bottom: 30,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
