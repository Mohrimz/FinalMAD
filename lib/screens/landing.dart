import 'package:flutter/material.dart';
import 'package:login/screens/search_screen.dart';
import 'package:login/screens/step_counter_screen.dart';
import 'package:login/widgets/category_item.dart';
import 'package:login/widgets/landing.dart';
import 'package:login/services/api_service.dart';

class WelcomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final String userName; // To hold the user's name

  const WelcomeScreen({
    Key? key,
    required this.favoriteProducts,
    required this.onFavoriteToggle,
    required this.userName,
  }) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  List<Map<String, dynamic>> products = [];
  bool isLoading = true;
  String selectedCategory = 'Nike';

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await ApiService.fetchProducts();
      setState(() {
        products = fetchedProducts.map((product) {
          return {
            'name': product['name'] ?? 'No Name',
            'category': 'Shoes', // Update if your API provides a category.
            'price': '\$${product['price'] ?? 0}',
            'rating': (product['rating'] ?? 0.0).toDouble(),
            'imagePath': product['target_file'] ?? '',
            // Include the description from the API
            'description': product['description'] ?? 'No description available',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  void toggleFavorite(Map<String, dynamic> product) {
    widget.onFavoriteToggle(product);
    setState(() {});
  }

  final List<String> categories = ['Nike', 'Adidas', 'Puma', 'Fila'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            // Header: "Welcome" and the user's name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome',
                        style: TextStyle(
                          fontSize: screenWidth * 0.07,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        widget.userName,
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          color: isDarkMode ? Colors.white54 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // Search and notifications icons
                  Row(
  children: [
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.search, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
      ),
    ),
    const SizedBox(width: 10),
    // New Step Counter Icon (instead of the notification icon)
    Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(Icons.directions_run, color: Colors.black),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const StepCounterScreen(),
            ),
          );
        },
      ),
    ),
  ],
),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // New Collection card
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Container(
                height: screenWidth * 0.45,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'New Collection',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Discount 50% for\nthe first purchase',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: const BorderSide(color: Colors.blue),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: const Text(
                              'Shop Now',
                              style: TextStyle(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/images/image23.png',
                        height: screenWidth * 0.35,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Categories section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 90,
              padding: const EdgeInsets.only(left: 16),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  String category = categories[index];
                  bool isSelected = selectedCategory == category;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    child: CategoryItem(
                      imagePath: 'assets/images/$category.png',
                      label: category,
                      isSelected: isSelected,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Featured products section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Featured',
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : products.isEmpty
                    ? const Center(child: Text('No products found'))
                    : Container(
                        height: 250,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            // Determine favorite status by checking the global favorite list.
                            bool isFavorite = widget.favoriteProducts.any(
                                (fav) => fav['name'] == product['name']);
                            return FeaturedProductCard(
                              imagePath: product['imagePath'],
                              name: product['name'],
                              category: product['category'],
                              price: product['price'],
                              // Hardcode rating as 4.6
                              rating: 4.6,
                              isFavorite: isFavorite,
                              onFavoriteToggle: () => toggleFavorite(product),
                              description: product['description'] ??
                                  'No description available',
                            );
                          },
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
