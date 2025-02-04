import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login/screens/cart_screen.dart';

// Global state for the cart
final List<Map<String, dynamic>> cart = [];

class ProductDetailScreen extends StatefulWidget {
  final String imagePath;
  final String productName;
  final String category;
  final double rating;
  final String price;
  final String description;

  const ProductDetailScreen({
    Key? key,
    required this.imagePath,
    required this.productName,
    required this.category,
    required this.rating,
    required this.price,
    required this.description,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isInCart = false;

  @override
  void initState() {
    super.initState();
    // Check if the product is already in the cart.
    isInCart = cart.any((item) => item['name'] == widget.productName);
  }

  void toggleCart() {
    setState(() {
      if (isInCart) {
        cart.removeWhere((item) => item['name'] == widget.productName);
      } else {
        cart.add({
          'name': widget.productName,
          'price': widget.price,
          'imagePath': widget.imagePath,
          'category': widget.category,
          'quantity': 1,
        });
      }
      isInCart = !isInCart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar with the image as background.
          SliverAppBar(
            pinned: true,
            expandedHeight: 300,
            backgroundColor: Colors.deepPurple,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),
            ],
            // Remove the title so that it doesn't appear over the image.
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag: widget.productName,
                child: Image.network(
                  widget.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(child: Icon(Icons.error, size: 50));
                  },
                ),
              ),
            ),
          ),
          // The rest of the content below the image.
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name below the image.
                  Text(
                    widget.productName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Category and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.category,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                        ),
                      ),
                      Text(
                        widget.price,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Hardcoded Rating Row (shows 4.6)
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '4.6',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Description Card
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 16,
                              color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Add-to-Cart Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: toggleCart,
                      icon: Icon(
                        isInCart ? Icons.remove_shopping_cart : Icons.add_shopping_cart,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      label: Text(
                        isInCart ? 'Remove from Cart' : 'Add to Cart',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.green : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
