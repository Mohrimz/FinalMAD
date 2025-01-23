import 'package:flutter/material.dart';
import 'package:login/screens/cart_screen.dart';
import 'package:login/screens/favorites_screen.dart';
import 'package:login/screens/landing.dart';
import 'package:login/screens/profile_screen.dart';
import 'package:login/screens/login_screen.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void toggleDarkMode() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.blue,
              hintColor: Colors.purple,
              scaffoldBackgroundColor: Colors.black,
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.grey[850],
              ),
            )
          : ThemeData.light().copyWith(
              primaryColor: Colors.blue,
              hintColor: Colors.purple,
            ),
      home: MainScreen(toggleDarkMode: toggleDarkMode),
    );
  }
}


class MainScreen extends StatefulWidget {
  final Function toggleDarkMode;

  const MainScreen({Key? key, required this.toggleDarkMode}) : super(key: key);

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

  List<Widget> _screens() {
    return [
      WelcomeScreen(
        favoriteProducts: favoriteProducts,
        onFavoriteToggle: toggleFavorite,
      ),
      FavoritesScreen(favoriteProducts: favoriteProducts),
      CartScreen(),
      CustomProfileScreen(toggleDarkMode: widget.toggleDarkMode, logOut: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), 
        );
      }),
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
