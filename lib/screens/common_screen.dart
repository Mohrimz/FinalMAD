import 'package:flutter/material.dart';
import 'login_screen.dart'; 
import 'signup_screen.dart'; 

class CommonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/new.jpg', 
              fit: BoxFit.cover, 
            ),
          ),
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.7), 
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 150), 
                    const Text(
                      'Welcome to TRENDY.LK',
                      style: TextStyle(
                        fontFamily: 'CustomFont', 
                        fontSize: 32,
                        color: Colors.white, 
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10), 
                    const Text(
                      'EVERY STEP MATTERS',
                      style: TextStyle(
                        fontFamily: 'CustomFont', 
                        fontSize: 18,
                        fontWeight: FontWeight.w500, 
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () {
                        print('Sign In Button Pressed');
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()), 
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: Colors.white),
                        ),
                        backgroundColor: Colors.transparent, 
                      ),
                      child: Text(
                        'LOG IN',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white, 
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUpScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.purpleAccent, 
                      ),
                      child: Text(
                        'SIGN UP',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
