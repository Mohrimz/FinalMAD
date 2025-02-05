import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:login/screens/profile_screen.dart';

class CheckoutForm extends StatefulWidget {
  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for form fields.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  // State variables for location info.
  bool _isCalculating = false;
  bool _locationInfoVisible = false;
  List<Map<String, dynamic>> _locationDistances = [];
  String? _userAddress;
  Map<String, dynamic>? _selectedShop;

  // Fixed shop locations.
  final Map<String, dynamic> _locationA = {
    'name': 'TRENDY.LK 1',
    'latitude': 6.875138,
    'longitude': 79.877484,
    'address': "Gregory's Ave, Colombo 00800",
  };

  final Map<String, dynamic> _locationB = {
    'name': 'TRENDY.LK 2',
    'latitude': 6.912121,
    'longitude': 79.880407,
    'address': "Philip Gunewardena Mawatha, Colombo 00700",
  };

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  /// calculates distances to the nearest shops
  Future<void> _fetchLocationAndCalculateDistances() async {
    if (_locationInfoVisible) {
      setState(() {
        _locationInfoVisible = false;
        _locationDistances = [];
        _userAddress = null;
        _selectedShop = null;
      });
      return;
    }

    setState(() {
      _isCalculating = true;
      _locationDistances = [];
      _userAddress = null;
      _selectedShop = null;
    });

    //Getting my location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        _userAddress =
            "${place.name ?? ''} ${place.street ?? ''}, ${place.locality ?? ''}, ${place.administrativeArea ?? ''} ${place.postalCode ?? ''}, ${place.country ?? ''}";
      } else {
        _userAddress = "Address not found";
      }

      // Calculating distance to other shops
      double distanceA = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _locationA['latitude'],
        _locationA['longitude'],
      );
      double distanceB = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        _locationB['latitude'],
        _locationB['longitude'],
      );

      // Build list of shop info.
      List<Map<String, dynamic>> distances = [
        {
          'name': _locationA['name'],
          'distance': distanceA,
          'address': _locationA['address'],
        },
        {
          'name': _locationB['name'],
          'distance': distanceB,
          'address': _locationB['address'],
        },
      ];
      distances.sort((a, b) => a['distance'].compareTo(b['distance']));

      setState(() {
        _locationDistances = distances;
        _locationInfoVisible = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error retrieving location: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isCalculating = false;
      });
    }
  }

  /// Shows a modal dialog confirming the order.
  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text('Order Confirmed'),
          content: Text(
            '${_selectedShop!['name']} will be ready to take your order.',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomProfileScreen(
                      userName: _nameController.text,
                      toggleDarkMode: () {},
                      logOut: () {},
                    ),
                  ),
                );
              },
              child: Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  void _placeOrder() {
    if (_formKey.currentState!.validate()) {
      if (_selectedShop == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please select a shop before placing the order.')),
        );
        return;
      }
      _showOrderConfirmationDialog();
    }
  }

  Widget _buildShopButtons() {
    if (_locationDistances.isEmpty) return SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: _locationDistances.map((shop) {
        double distanceInKm = shop['distance'] / 1000;
        bool isSelected =
            _selectedShop != null && _selectedShop!['name'] == shop['name'];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor:
                  isSelected ? Colors.lightBlueAccent : Colors.white,
              side: BorderSide(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2,
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            ),
            onPressed: () {
              setState(() {
                _selectedShop = shop;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${shop['name']} - ${distanceInKm.toStringAsFixed(2)} km away",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  shop['address'],
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  ///Displaying the user's address and shop selection.
  Widget _buildLocationInfo() {
    if (!_locationInfoVisible) return SizedBox.shrink();
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your Address:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            Text(
              _userAddress ?? 'Not available',
              style: TextStyle(fontSize: 15),
            ),
            Divider(height: 24, thickness: 1),
            Text('Select a Shop:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 4),
            _buildShopButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Personal Information Section
              _buildInputField(
                label: 'Full Name',
                controller: _nameController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildInputField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              _buildInputField(
                label: 'Phone Number',
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              // Payment Information
              _buildInputField(
                label: 'Card Number',
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your card number';
                  }
                  String cardNum = value.replaceAll(' ', '');
                  if (cardNum.length < 16) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildInputField(
                      label: 'Expiry Date',
                      hintText: 'MM/YY',
                      controller: _expiryController,
                      keyboardType: TextInputType.datetime,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter expiry date';
                        }
                        if (!RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$')
                            .hasMatch(value.trim())) {
                          return 'Enter a valid expiry date';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildInputField(
                      label: 'CVV',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Enter CVV';
                        }
                        if (value.trim().length < 3) {
                          return 'CVV must be at least 3 digits';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              // Get My Address and Nearest Shop button.
              ElevatedButton.icon(
                onPressed: _fetchLocationAndCalculateDistances,
                icon: Icon(Icons.location_on),
                label: Text('Select the Shop'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  textStyle: TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Display location info
              _isCalculating
                  ? Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    )
                  : _buildLocationInfo(),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _placeOrder,
                child: Text('Place Order'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
