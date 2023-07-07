import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lvtn_mangxahoi/resources/auth_method.dart';
import 'package:lvtn_mangxahoi/screens/choice_title.dart';
import 'package:lvtn_mangxahoi/screens/login_screen.dart';
import 'package:lvtn_mangxahoi/utils/utils.dart';

import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signUpUser() async {
    setState(() {
      isLoading = true;
    });
    String res = await AuthMethod().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        file: _image!);
    setState(() {
      isLoading = false;
    });
    if (res != 'success') {
      showSnackBar(context, res);
    } else {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(
      //     builder: (context) => const ResponsiveLayout(
      //       mobileScreenLayout: MobileScreenLayout(),
      //       webScreenLayout: WebScreenLayout(),
      //     ),
      //   ),
      // );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ChoiceTitle(),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Flexible(
              child: Container(),
              flex: 2,
            ),
            SvgPicture.asset(
              'assets/ic_instagram.svg',
              color: primaryColor,
              height: 64,
            ),
            const SizedBox(height: 14),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            "https://tse2.mm.bing.net/th?id=OIP.RtLnpr_QmrKy0jS5EVs8CQHaHa&pid=Api&P=0"),
                      ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: _usernameController,
              hintText: 'Enter your username',
              textInputType: TextInputType.text,
              icon: Icon(Icons.person),
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: _emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.emailAddress,
              icon: Icon(Icons.email),
            ),
            const SizedBox(height: 20),
            TextFieldInput(
              textEditingController: _passwordController,
              hintText: 'Enter your password',
              textInputType: TextInputType.visiblePassword,
              icon: Icon(Icons.lock),
              isPass: true,
            ),
            const SizedBox(height: 20),
            TextFieldInput(
                textEditingController: _bioController,
                icon: Icon(Icons.book),
                hintText: 'Enter your bio',
                textInputType: TextInputType.text),
            const SizedBox(height: 20),
            InkWell(
              onTap: signUpUser,
              child: Container(
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: primaryColor,
                        ),
                      )
                    : const Text('Sign up'),
                width: double.infinity,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: const ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4),
                    ),
                  ),
                  color: blueColor,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Flexible(
              child: Container(),
              flex: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Text(
                    "Don't have an account?",
                    style: TextStyle(color: kBlack),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                  ),
                ),
                GestureDetector(
                  onTap: navigateToLogin,
                  child: Container(
                    child: Text(
                      "Login",
                      style: TextStyle(fontWeight: FontWeight.bold, color: kBlack),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
