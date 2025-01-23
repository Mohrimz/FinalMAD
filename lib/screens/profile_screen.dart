import 'package:flutter/material.dart';
import 'package:login/screens/edit_profile_screen.dart';
import 'package:login/screens/signup_screen.dart';
import 'package:login/widgets/profile_option.dart';
import '../widgets/profile.dart';

class CustomProfileScreen extends StatelessWidget {
  final Function toggleDarkMode;
  final Function logOut; 

  const CustomProfileScreen({super.key, required this.toggleDarkMode, required this.logOut});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 250,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.purple, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/images/profile.jpg'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mohomed Rimzan',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ProfileOption(
                        icon: Icons.person,
                        title: 'My Profile',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(toggleDarkMode: toggleDarkMode)));
                        },
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                      ProfileOption(
                        icon: Icons.message,
                        title: 'Messages',
                        onTap: () {},
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                      ProfileOption(
                        icon: Icons.favorite,
                        title: 'Favourites',
                        onTap: () {},
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                      ProfileOption(
                        icon: Icons.location_on,
                        title: 'Location',
                        onTap: () {},
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                      ProfileOption(
                        icon: Icons.settings,
                        title: 'Settings',
                        onTap: () {},
                        textColor: isDarkMode ? Colors.white : Colors.black,
                      ),
                      SwitchListTile(
                        title: const Text('Mode'), 
                        value: isDarkMode,
                        onChanged: (bool value) {
                          toggleDarkMode(); 
                        },
                        activeColor: Colors.blue, 
                        subtitle: Text(
                          '',
                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                        ),
                      ),
                      ProfileOption(
                        icon: Icons.logout,
                        title: 'Log Out',
                        textColor: isDarkMode ? Colors.white : Colors.black,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpScreen()), 
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
