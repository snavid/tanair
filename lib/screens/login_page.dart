import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tanair/screens/order_list_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  final String _demoUsername = 'admin';
  final String _demoPassword = 'password123';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (_usernameController.text == _demoUsername &&
          _passwordController.text == _demoPassword) {
        final token = 'demo_token_${DateTime.now().millisecondsSinceEpoch}';
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderListPage()),
        );
      } else {
        _showErrorDialog('Invalid credentials. Use admin/password123');
      }
    } catch (e) {
      _showErrorDialog('Login error. Please try again.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: 1,
                  child: Image.asset('assets/tanair.b745e74.png')),
                Opacity(
                  opacity: 0.9,
                  child: Text('The wings of Kilmanjaro', style: GoogleFonts.blackOpsOne(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Color.fromRGBO(0, 115, 191, 1)
                  ),),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
            Column(
              children: [
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.elliptical(25, 25))
                    ),
                    //hintText: 'Demo: admin',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.elliptical(25, 25))
                    ),
                  //  hintText: 'Demo: password123',
                  ),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                        child: Text('Login'),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
