import 'package:ebooks_point_admin/pages/auth/controllers/login_controller.dart';
import 'package:ebooks_point_admin/constants/text_strings.dart';
import 'package:ebooks_point_admin/responsive.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          elevation: 20,
          child: Container(
            height: MediaQuery.of(context).size.height *
                // 0.5, // Set width to half of the scre
                0.6, // Set width to half of the scre
            width: Responsive.isDesktop(context)
                ? MediaQuery.of(context).size.width * 0.2
                : MediaQuery.of(context).size.width *
                    0.6, // Set width to half of the screen
            padding: const EdgeInsets.all(16.0),
            // margin: const EdgeInsets.only(top: 100),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 50),
                  const Text(
                    ZText.zWelcomeBack,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center the text
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: loginController.usernameController,
                    decoration: InputDecoration(
                      labelText: ZText.zUsername,
                      prefixIcon: const Icon(FluentIcons.person_12_regular),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ZText.zPleaseEnterUsername;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: loginController.passwordController,
                    decoration: InputDecoration(
                      labelText: ZText.zPassword,
                      prefixIcon: const Icon(FluentIcons.password_16_regular),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return ZText.zPleaseEnterPassword;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        loginController.loginUser();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    child: const Text(
                      ZText.zLogin,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
