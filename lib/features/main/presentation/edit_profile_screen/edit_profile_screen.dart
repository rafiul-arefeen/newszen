import 'package:flutter/material.dart';
import 'package:news_zen/core/theme/colors.dart';
import 'package:news_zen/core/utils/app_assets.dart';
import 'package:news_zen/core/utils/pref_utils.dart';
import 'package:http/http.dart' as http; // For API calls
import 'dart:convert'; // For JSON encoding/decoding

import '../../../../config/server_config.dart'; // For server configuration

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _newEmailController = TextEditingController();

  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isLoading = false; // To show loading state during API call

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Fetch data from PrefUtils
    final email = await PrefUtils.getEmail();
    final username = await PrefUtils.getUserName();
    final password = await PrefUtils.getPassword();

    // Set the fetched data to the controllers
    setState(() {
      _emailController.text = email ?? '';
      _usernameController.text = username ?? '';
      _oldPasswordController.text = '';
      _newPasswordController.text = ''; // Leave new password blank initially
      _newEmailController.text = ''; // Leave new email blank initially
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: main_background_colour,
          title: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Image.asset(
                      AppAssets.image.img_med_logo, // Your logo asset
                      width: 140,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    icon: Icon(Icons.close, color: primary_red),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage:
                      AssetImage(AppAssets.image.img_user_profile),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.black54,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // Username Field
              _buildInputLabel('Name'),
              _buildTextField(
                controller: _usernameController,
                hintText: 'Enter your username',
              ),
              const SizedBox(height: 20),

              // Email Field
              _buildInputLabel('E mail address'),
              _buildTextField(
                controller: _emailController,
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // New Email Field
              _buildInputLabel('New Email (Optional)'),
              _buildTextField(
                controller: _newEmailController,
                hintText: 'Enter your new email',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Old Password Field
              _buildInputLabel('Old Password'),
              _buildTextField(
                controller: _oldPasswordController,
                hintText: 'Enter your old password',
                obscureText: !_isOldPasswordVisible,
                suffixIcon: _isOldPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixIconPressed: () {
                  setState(() {
                    _isOldPasswordVisible = !_isOldPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 20),

              // New Password Field
              _buildInputLabel('New Password'),
              _buildTextField(
                controller: _newPasswordController,
                hintText: 'Enter your new password',
                obscureText: !_isNewPasswordVisible,
                suffixIcon: _isNewPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
                onSuffixIconPressed: () {
                  setState(() {
                    _isNewPasswordVisible = !_isNewPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 32),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 50.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _saveProfileChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary_red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Save Changes",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    IconData? suffixIcon,
    VoidCallback? onSuffixIconPressed,
    String? prefixText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
          ),
          prefixText: prefixText,
          prefixStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
          ),
          suffixIcon: suffixIcon != null
              ? IconButton(
            icon: Icon(suffixIcon, color: Colors.grey),
            onPressed: onSuffixIconPressed,
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfileChanges() async {
    // Validate old email
    final storedEmail = await PrefUtils.getEmail();
    if (_emailController.text != storedEmail) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old email is incorrect')),
      );
      return;
    }

    // Validate old password
    final storedPassword = await PrefUtils.getPassword();
    if (_oldPasswordController.text != storedPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old password is incorrect')),
      );
      return;
    }

    setState(() {
      _isLoading = true; // Show loading indicator
    });

    try {
      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        'oldemail': _emailController.text,
        'username': _usernameController.text,
        //'password': _oldPasswordController.text,
      };

      // Add new email only if it is provided
      if (_newEmailController.text.isNotEmpty) {
        requestBody['email'] = _newEmailController.text;
      }

      // Add new password only if it is provided
      if (_newPasswordController.text.isNotEmpty) {
        requestBody['password'] = _newPasswordController.text;
      }

      // Send API request
      final response = await http.post(
        Uri.parse(updateuserinfourl), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        // Update PrefUtils with new values
        if (_newEmailController.text.isNotEmpty) {
          await PrefUtils.saveEmail(_newEmailController.text);
        }
        await PrefUtils.saveUserName(_usernameController.text);
        if (_newPasswordController.text.isNotEmpty) {
          await PrefUtils.savePassword(_newPasswordController.text);
        }

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      } else {
        // Handle API error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile: ${response.body}')),
        );
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }
}