import 'package:flutter/material.dart';

class FavoritesScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;

  const FavoritesScreen({Key? key, required this.favoriteProducts}) : super(key: key);

  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<Map<String, dynamic>> cartItems = [];

  void _addToCart(Map<String, dynamic> product) {
    setState(() {
      cartItems.add(product); 
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product['name']} added to cart!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
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
                  leading: Image.asset(product['imagePath']),
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
