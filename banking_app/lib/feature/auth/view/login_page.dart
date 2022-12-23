import 'package:banking_app/feature/auth/controller/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _loginController = Get.find<LoginController>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: Obx(
          () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // * TextFields
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Username",
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      hintText: "Password",
                    ),
                  ),
                ),
                ElevatedButton(
                    onPressed: () {
                      if (_usernameController.text.isEmpty ||
                          _passwordController.text.isEmpty) {
                        _loginController.updateStatus("Please fill all fields");
                        return;
                      }

                      _loginController.loginRequest(
                          _usernameController.text, _passwordController.text);
                    },
                    child: const Text("Login")),

                _loginController.loading.value
                    ? const CircularProgressIndicator()
                    : Text(
                        _loginController.status.value,
                        style: const TextStyle(color: Colors.black),
                      ),

                // * SignUp Button
                const SizedBox(height: 20),
                const Text("Don't have an account?"),
                ElevatedButton(
                    onPressed: () {
                      Get.toNamed("/register");
                    },
                    child: const Text("SignUp"))
              ],
            ),
          ),
        ));
  }
}
