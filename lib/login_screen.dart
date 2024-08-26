import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'home_page.dart'; // استيراد الصفحة الرئيسية

class LoginScreen extends StatefulWidget {
  final Function toggleTheme;
  final bool isDarkMode;

  LoginScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse('http://192.168.1.3:5000/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'username': _usernameController.text,
        'password': _passwordController.text,
      }),
    );

    final responseData = jsonDecode(response.body);
    if (response.statusCode == 200 && responseData['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    } else {
      _showErrorSnackbar('Login failed');
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget
                  .toggleTheme(); // Ensure this matches the expected function signature
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField(
              controller: _usernameController,
              label: 'Username',
            ),
            _buildTextField(
              controller: _passwordController,
              label: 'Password',
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText,
    );
  }
}
