import 'package:flutter/material.dart';
import 'package:login/screens/product_detail_screen.dart' as detail;

class FeaturedProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String category;
  final String price;
  final double rating;
  final bool isFavorite;
  final Function onFavoriteToggle;
  final String description;

  const FeaturedProductCard({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.description,
  }) : super(key: key);

  /// Returns an image widget after normalizing the image path.
  Widget _buildProductImage() {
    String normalizedPath = imagePath;
    // If the path starts with "images/", add "assets/" prefix.
    if (imagePath.startsWith("images/")) {
      normalizedPath = "assets/" + imagePath;
    }
    
    if (normalizedPath.startsWith("assets/")) {
      return Image.asset(
        normalizedPath,
        height: 125,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        imagePath,
        height: 125,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Image.asset(
            'assets/images/placeholder.png', // A fallback placeholder image.
            height: 125,
            width: double.infinity,
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          // Navigate to the product detail screen.
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => detail.ProductDetailScreen(
                imagePath: imagePath,
                productName: name,
                category: category,
                rating: rating,
                price: price,
                description: description,
              ),
            ),
          );
        },
        child: Container(
          width: 170,
          margin: const EdgeInsets.only(right: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: _buildProductImage(),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  category,
                  style: const TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star,
                            color: Colors.yellow, size: 14),
                        Text(
                          '$rating',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
