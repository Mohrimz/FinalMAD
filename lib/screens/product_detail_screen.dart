import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For HapticFeedback
import 'package:login/screens/cart_screen.dart';
import 'package:login/globals.dart'; // Import the global cart variable

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
        // Trigger a medium impact when removing from the cart.
        HapticFeedback.mediumImpact();
        cart.removeWhere((item) => item['name'] == widget.productName);
        _showCartAnimation(success: false); // Show removal animation
      } else {
        // Trigger a light impact when adding to the cart.
        HapticFeedback.lightImpact();
        cart.add({
          'name': widget.productName,
          'price': widget.price,
          'imagePath': widget.imagePath,
          'category': widget.category,
          'quantity': 1,
        });
        _showCartAnimation(success: true); // Show addition animation
      }
      isInCart = !isInCart;
    });
  }

  /// Displays an animated overlay to provide visual feedback.
  /// If [success] is true, it shows a check mark and "Added to Cart" message;
  /// otherwise, it shows a cross and "Removed from Cart" message.
  void _showCartAnimation({required bool success}) {
    final String message = success ? 'Added to Cart' : 'Removed from Cart';

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.4),
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Center(
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animation,
              curve: Curves.elasticOut,
              reverseCurve: Curves.easeIn,
            ),
            child: FadeTransition(
              opacity: animation,
              child: Container(
                width: 220,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: success
                        ? [Colors.greenAccent.shade200, Colors.green.shade400]
                        : [Colors.redAccent.shade200, Colors.red.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      success ? Icons.check_circle_outline : Icons.highlight_off,
                      size: 64,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return child;
      },
    );

    // Automatically dismiss the dialog after 1 second.
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop();
      }
    });
  }

  /// Helper method to build the product image.
  /// If the imagePath starts with "assets/", it loads a local asset;
  /// otherwise, it loads a network image.
  Widget _buildProductImage() {
    if (widget.imagePath.startsWith("assets/")) {
      return Image.asset(
        widget.imagePath,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(
        widget.imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return const Center(child: Icon(Icons.error, size: 50));
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      // Using a CustomScrollView with a SliverAppBar for a modern collapsible header.
      body: CustomScrollView(
        slivers: [
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
            flexibleSpace: FlexibleSpaceBar(
              // Use a Hero for smooth transition between screens.
              background: Hero(
                tag: widget.productName,
                child: _buildProductImage(),
              ),
            ),
          ),
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
                  // Category and Price Row.
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
                  // Hardcoded Rating Row (shows 4.6).
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
                  // Description Card.
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
                  // Add-to-Cart Button.
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: toggleCart,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isInCart ? Colors.green : Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        // Remove the default splash to let our animation stand out.
                        splashFactory: NoSplash.splashFactory,
                      ),
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
