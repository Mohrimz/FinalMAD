class Product {
  final String imagePath;
  final String name;
  final String category;
  final String price;
  final double rating;
  bool isFavorite;

  Product({
    required this.imagePath,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    this.isFavorite = false, // Default value for isFavorite
  });
}
