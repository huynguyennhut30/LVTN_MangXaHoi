import 'package:flutter/material.dart';
import 'package:lvtn_mangxahoi/resources/auth_method.dart';
import 'package:lvtn_mangxahoi/responsive/mobile_screen_layout.dart';
import 'package:lvtn_mangxahoi/responsive/responsive_layout_screen.dart';
import 'package:lvtn_mangxahoi/responsive/web_screen_layout.dart';
import 'package:lvtn_mangxahoi/screens/signup_screens.dart';
import 'package:lvtn_mangxahoi/utils/utils.dart';

import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';

class LoginScreens extends StatefulWidget {
  const LoginScreens({super.key});

  @override
  State<LoginScreens> createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  final Color kAccentColor = Colors.teal;
  bool _obscureText = true;
  bool isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void iniitShared() async {
    await sharedPreferences.initPreference();
  }

  @override
  void initState() {
    super.initState();
    iniitShared();
  }

  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await aut.loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'success') {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
            mobileScreenLayout: MobileScreenLayout(),
            webScreenLayout: WebScreenLayout(),
          ),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      showSnackBar(context, res);
    }
    setState(() {
      isLoading = false;
    });
  }

  void navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SignupScreens(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            color: const Color.fromARGB(255, 196, 250, 253),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      'assets/logoSnapshot.png',
                      width: 250.0,
                      height: 250.0,
                    ),
                    _buildTextField(
                      textEditingController: _emailController,
                      hintText: 'Email',
                      icon: Icons.email,
                      textInputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                      textEditingController: _passwordController,
                      hintText: 'Mật khẩu',
                      icon: Icons.lock,
                      obscureText: _obscureText,
                      isPassword: true,
                      textInputType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 32.0),
                    InkWell(
                      onTap: loginUser,
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const ShapeDecoration(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(30),
                            ),
                          ),
                          // color: Color.fromARGB(255, 91, 165, 226),
                          color: Color.fromARGB(255, 15, 145, 211),
                        ),
                        child: isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.blueAccent,
                                ),
                              )
                            : const Text(
                                'ĐĂNG NHẬP',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: const Text(
                        "Bạn chưa có tài khoản? ",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: navigateToSignUp,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                        ),
                        child: const Text(
                          "Đăng ký tại đây",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController textEditingController,
    required String hintText,
    required IconData icon,
    required TextInputType textInputType,
    bool obscureText = false,
    bool isPassword = false,
    int maxLines = 1,
  }) {
    return TextField(
      controller: textEditingController,
      keyboardType: textInputType,
      obscureText: obscureText,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        prefixIcon: Icon(
          icon,
          color: Colors.grey,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: () {
                  // đảo ngược trạng thái của obscureText khi nhấn vào biểu tượng con mắt
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            // color: Theme.of(context).accentColor,
            color: Colors.blueAccent,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
