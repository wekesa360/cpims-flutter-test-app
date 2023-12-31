import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../tokenProvider.dart';
import '../widgets/snackBarWidget.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => LoginState();
}

class LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Form(
              child: Column(
            children: [
              const SizedBox(height: 10),
              const Text("Login to your account",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _usernameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person_outline),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                    10,
                  )),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onEditingComplete: () => _focusNodePassword.requestFocus(),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter username.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                focusNode: _focusNodePassword,
                obscureText: _obscurePassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.password_outlined),
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      icon: _obscurePassword
                          ? const Icon(Icons.visibility_outlined)
                          : const Icon(Icons.visibility_off_outlined)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password.";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 60),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: _login,
                child: const Text("Login"),
              ),
            ],
          )),
        ),
      ],
      ),
    );
  }

  Future<void> _login() async {
    final String? apiBaseUrl = dotenv.env["API_BASE_URL"];
    final String? loginEndpoint = dotenv.env["LOGIN_ENDPOINT"];

    if (apiBaseUrl == null || loginEndpoint == null) {
      print("API_BASE_URL or LOGIN_ENDPOINT is not defined in your .env file.");
      return;
    }

    final Map<String, dynamic> body = {
      "username": _usernameController.text,
      "password": _passwordController.text,
    };

    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await http.post(Uri.parse("$apiBaseUrl$loginEndpoint"),
        body: json.encode(body), headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final String token = data["access"];
      final TokenProvider tokenProvider =
          Provider.of<TokenProvider>(context, listen: false);
      tokenProvider.setToken(token);
      Navigator.pushReplacementNamed(context, "/dashboard");
    } else if (response.statusCode == 401) {
      snackBarWidget(context, "Invalid username or password.");
    } else {
      snackBarWidget(context, "Login failed. ${response.statusCode}}");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }
}
