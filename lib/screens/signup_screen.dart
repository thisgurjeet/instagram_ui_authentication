import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram_clone/resources/auth_methods.dart';
import 'package:instagram_clone/screens/login_screen.dart';
import 'package:instagram_clone/utils/utils.dart';

import '../utils/colors.dart';
import '../widgets/text_field_input.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
  }

  void selectImage() async {
    Uint8List _im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = _im;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        bio: _bioController.text,
        username: _usernameController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {}
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Flexible(
            flex: 2,
            child: Container(),
          ),
          // instagram logo
          Image.asset(
            'assets/Instagram_logo.svg.png',
            color: primaryColor,
            height: 64,
          ),
          const SizedBox(
            height: 64,
          ),
          Stack(
            children: [
              _image != null
                  ? CircleAvatar(
                      radius: 64,
                      backgroundImage: MemoryImage(_image!),
                    )
                  : const CircleAvatar(
                      radius: 64,
                      backgroundImage: AssetImage('assets/default.png'),
                    ),
              Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(Icons.add_a_photo)))
            ],
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _usernameController,
              textInputType: TextInputType.text,
              hintText: 'Enter your username'),
          const SizedBox(
            height: 24,
          ),
          // text input for email
          TextFieldInput(
              textEditingController: _emailController,
              textInputType: TextInputType.emailAddress,
              hintText: 'Enter your email'),
          const SizedBox(
            height: 24,
          ),
          // text input for password
          TextFieldInput(
            textEditingController: _passwordController,
            textInputType: TextInputType.text,
            hintText: 'Enter your password',
            isPass: true,
          ),
          const SizedBox(
            height: 24,
          ),
          TextFieldInput(
              textEditingController: _bioController,
              textInputType: TextInputType.emailAddress,
              hintText: 'Enter your bio'),

          const SizedBox(
            height: 24,
          ),
          // log in button
          InkWell(
            onTap: signUpUser,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primaryColor,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: blueColor),
                    child: const Text('Sign up'),
                  ),
          ),
          const SizedBox(
            height: 12,
          ),
          Flexible(
            flex: 2,
            child: Container(),
          ),
          // text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Text('Don\'t have an account?'),
              ),
              GestureDetector(
                onTap: navigateToLogin,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Text(
                    'Log in',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          )
        ]),
      )),
    );
  }
}
