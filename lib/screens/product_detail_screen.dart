import 'package:flutter/material.dart';
import 'package:login/screens/cart_screen.dart';

// Global state
final List<Map<String, dynamic>> cart = [];

class ProductDetailScreen extends StatefulWidget {
  final String imagePath;
  final String productName;
  final String category;
  final double rating;
  final String price;

  const ProductDetailScreen({
    Key? key,
    required this.imagePath,
    required this.productName,
    required this.category,
    required this.rating,
    required this.price,
  }) : super(key: key);

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool isInCart = false;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(
        title: Text(widget.productName),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Use Image.network for remote images
            Image.network(
              widget.imagePath,
              height: 250,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Icon(Icons.error, size: 50));
              },
            ),
            const SizedBox(height: 16),
            Text(
              widget.productName,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.category,
              style: TextStyle(
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.price,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow),
                    Text(
                      '${widget.rating}',
                      style: TextStyle(
                        fontSize: 18,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: toggleCart,
              style: ElevatedButton.styleFrom(
                backgroundColor: isInCart ? Colors.green : Colors.blue,
              ),
              child: Text(
                isInCart ? 'Remove from Cart' : 'Add to Cart',
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
