import 'package:flutter/material.dart';
import 'package:login/screens/cart_screen.dart';
import 'package:login/screens/product_detail_screen.dart' hide cart;

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;

  const FavoritesScreen({Key? key, required this.favoriteProducts})
      : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  void _addToCart(Map<String, dynamic> product) {
    // Use the global cart variable from cart_screen.dart.
    // Check if the product is not already in the cart.
    if (!cart.any((item) => item['name'] == product['name'])) {
      cart.add({
        'name': product['name'],
        'price': product['price'],
        'imagePath': product['imagePath'],
        'category': product['category'] ?? 'Category',
        'quantity': 1,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} added to cart!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${product['name']} is already in the cart!'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          // Optional: AppBar cart icon to navigate directly to the cart.
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          )
        ],
      ),
      body: widget.favoriteProducts.isEmpty
          ? const Center(
              child: Text('No favorite products'),
            )
          : ListView.builder(
              itemCount: widget.favoriteProducts.length,
              itemBuilder: (context, index) {
                final product = widget.favoriteProducts[index];
                return ListTile(
                  // Tapping the ListTile navigates to the ProductDetailScreen.
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          imagePath: product['imagePath'],
                          productName: product['name'],
                          // Use the product's category if available; otherwise provide a default.
                          category: product['category'] ?? 'Category',
                          // Use the product's rating if available; otherwise provide 0.0.
                          rating: product['rating'] != null
                              ? (product['rating'] as num).toDouble()
                              : 0.0,
                          price: product['price'],
                        ),
                      ),
                    );
                  },
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(product['imagePath']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  title: Text(product['name']),
                  subtitle: Text(product['price']),
                  trailing: IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      _addToCart(product);
                    },
                  ),
                );
              },
            ),
    );
  }
}
