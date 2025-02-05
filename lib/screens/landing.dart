import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:login/screens/search_screen.dart';
import 'package:login/screens/step_counter_screen.dart';
import 'package:login/widgets/category_item.dart';
import 'package:login/services/api_service.dart';
import 'package:login/widgets/landing.dart'; // Ensure this import points to your FeaturedProductCard file

/// Loads dummy products from a local JSON file.
Future<List<dynamic>> loadDummyProducts(BuildContext context) async {
  final String jsonString = await DefaultAssetBundle.of(context)
      .loadString('assets/dummy_products.json');
  final Map<String, dynamic> data = jsonDecode(jsonString);
  return data['products'];
}

class WelcomeScreen extends StatefulWidget {
  final List<Map<String, dynamic>> favoriteProducts;
  final Function(Map<String, dynamic>) onFavoriteToggle;
  final String userName; // User's name to display in the header

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
  bool _isOffline = false; // Indicates if the app is offline
  String selectedCategory = 'Nike';

  // List of categories for the horizontal list.
  final List<String> categories = ['Nike', 'Adidas', 'Puma', 'Fila'];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  /// Attempts to fetch products from the API.
  /// If the API call fails, loads dummy data from local JSON.
  Future<void> fetchProducts() async {
    try {
      final fetchedProducts = await ApiService.fetchProducts();
      if (!mounted) return; // Ensure the widget is still mounted before calling setState.
      setState(() {
        products = fetchedProducts.map((product) {
          return {
            'name': product['name'] ?? 'No Name',
            'category': 'Shoes', // Update if your API provides a category.
            'price': '\$${product['price'] ?? 0}',
            'rating': (product['rating'] ?? 4.6).toDouble(),
            'imagePath': product['target_file'] ?? '',
            'description': product['description'] ?? 'No description available',
          };
        }).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products from API: $e");
      if (!mounted) return;
      setState(() {
        _isOffline = true;
      });
      try {
        final dummyProducts = await loadDummyProducts(context);
        if (!mounted) return;
        setState(() {
          products = dummyProducts.map((product) {
            return {
              'name': product['name'] ?? 'No Name',
              'category': 'Shoes',
              'price': '\$${product['price'] ?? 0}',
              'rating': (product['rating'] ?? 0.0).toDouble(),
              'imagePath': product['target_file'] ?? '',
              'description': product['description'] ?? 'No description available',
            };
          }).toList();
          isLoading = false;
        });
      } catch (localError) {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load products: $localError')),
        );
      }
    }
  }

  /// Toggles the favorite status for the given product.
  void toggleFavorite(Map<String, dynamic> product) {
    widget.onFavoriteToggle(product);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Offline banner shown only if _isOffline is true.
              if (_isOffline)
                Container(
                  width: double.infinity,
                  color: Colors.redAccent,
                  padding: const EdgeInsets.all(8),
                  child: const Text(
                    "You're offline.",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 20),
              // Header section with a welcome message and icons.
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Welcome text and user's name.
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
                    // Search and step counter icons.
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
              // New Collection card with gradient background.
              Padding(
                padding: EdgeInsets.all(screenWidth * 0.05),
                child: Container(
                  height: screenWidth * 0.45,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade200, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // Collection text and button.
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'New Collection',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Discount 50% for\nthe first purchase',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                ),
                                child: const Text(
                                  'Shop Now',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Collection image.
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.asset(
                            'assets/images/image23.png',
                            height: screenWidth * 0.35,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Categories header.
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
              // Horizontal list of category items.
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
              // Featured products header.
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
              // Products list.
              isLoading
                  ? const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : products.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: Text('No products found')),
                        )
                      : Container(
                          height: 250,
                          padding: const EdgeInsets.only(left: 16),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: products.length,
                            itemBuilder: (context, index) {
                              final product = products[index];
                              // Check if product is marked as favorite.
                              bool isFavorite = widget.favoriteProducts.any(
                                  (fav) => fav['name'] == product['name']);
                              return FeaturedProductCard(
                                imagePath: product['imagePath'],
                                name: product['name'],
                                category: product['category'],
                                price: product['price'],
                                rating: product['rating'],
                                isFavorite: isFavorite,
                                onFavoriteToggle: () => toggleFavorite(product),
                                description: product['description'] ??
                                    'No description available',
                              );
                            },
                          ),
                        ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
