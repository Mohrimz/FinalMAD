import 'package:flutter/material.dart';
import 'package:login/screens/cart_screen.dart';
import 'package:login/screens/favorites_screen.dart';
import 'package:login/screens/landing.dart';         // Contains WelcomeScreen, for example.
import 'package:login/screens/profile_screen.dart';   // (If you use this separately)
import 'package:login/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Since we're using system theme settings, we no longer need to manage dark mode manually.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      // Define your light theme.
      theme: ThemeData.light().copyWith(
        primaryColor: Colors.blue,
        hintColor: Colors.purple,
      ),
      // Define your dark theme.
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.blue,
        hintColor: Colors.purple,
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[850],
        ),
      ),
      // Follow the system setting.
      themeMode: ThemeMode.system,
      // Use MainScreen as the home.
      home: MainScreen(
        userName: 'User', // You can update this with a dynamic user name later.
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String userName;

  const MainScreen({
    Key? key,
    required this.userName,
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  List<Map<String, dynamic>> favoriteProducts = [];

  void toggleFavorite(Map<String, dynamic> product) {
    setState(() {
      if (favoriteProducts.any((fav) => fav['name'] == product['name'])) {
        favoriteProducts.removeWhere((fav) => fav['name'] == product['name']);
      } else {
        favoriteProducts.add(product);
      }
    });
  }

  // List of screens for the bottom navigation.
  List<Widget> _screens() {
    return [
      // WelcomeScreen requires the user's name.
      WelcomeScreen(
        favoriteProducts: favoriteProducts,
        onFavoriteToggle: toggleFavorite,
        userName: widget.userName,
      ),
      // FavoritesScreen
      FavoritesScreen(favoriteProducts: favoriteProducts),
      // CartScreen
      CartScreen(),
      // CustomProfileScreen now also accepts userName.
      CustomProfileScreen(
        toggleDarkMode: () {
          // Your toggle dark mode logic here.
        },
        logOut: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        userName: widget.userName, // Pass the userName here.
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: _screens()[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: isDarkMode ? Colors.white : Colors.blue,
        unselectedItemColor: isDarkMode ? Colors.white54 : Colors.black,
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
