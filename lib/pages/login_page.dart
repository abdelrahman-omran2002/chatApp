import 'package:chatapp/constants.dart';
import 'package:chatapp/helper/show_snack_bar.dart';
import 'package:chatapp/pages/chat_page.dart';
import 'package:chatapp/pages/register_page.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String id = "LoginPage()";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;
  String? password;
  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Form(
              key: formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 60),
                  Image.asset(kLogoImagePath, height: 150),
                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),

                  // خانة الإيميل
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      onChanged: (data) {
                        email = data;
                      },
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Email is required';
                        }
                        return null;
                      },
                      labelText: "Email",
                      keyboardType: TextInputType.emailAddress,
                      hintText: 'Enter your email',
                      obscureText: false,
                    ),
                  ),

                  // خانة الباسورد
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CustomTextField(
                      onChanged: (data) {
                        password = data;
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                      isPassword: true,
                      obscureText: true,
                      labelText: "Password",
                      keyboardType: TextInputType.text,
                      hintText: 'Enter your password',
                    ),
                  ),

                  const SizedBox(height: 30),

                  // زرار الـ Login
                  CustomButton(
                    text: "Login",
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });

                        try {
                          await loginUser(
                            email: email!.trim(),
                            password: password!,
                          );

                          showSnackBar(context, 'Success! Logged In.');

                          // 🚀 التنقل لصفحة الشات فوراً عند النجاح
                          Navigator.pushNamed(
                            context,
                            ChatPage.id,
                            arguments: email,
                          );
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found' ||
                              e.code == 'wrong-password' ||
                              e.code == 'invalid-credential') {
                            showSnackBar(
                              context,
                              'Incorrect email or password. Please try again.',
                            );
                          } else if (e.code == 'invalid-email') {
                            showSnackBar(
                              context,
                              'The email address is badly formatted.',
                            );
                          } else {
                            showSnackBar(
                              context,
                              e.message ?? 'Authentication failed',
                            );
                          }
                        } catch (e) {
                          showSnackBar(
                            context,
                            'Something went wrong. Please try again.',
                          );
                        } finally {
                          setState(() {
                            isLoading = false;
                          });
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(color: Colors.grey),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // بيستنى لحد ما الـ RegisterPage تقفل بـ pop
                          await Navigator.pushNamed(context, RegisterPage.id);

                          // أول ما يرجع هنا، بيطفي الـ Spinner فوراً للأمان
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
      ),
    );
  }

  // دالة الـ loginUser بقت جاهزة ومستقلة وبتستقبل الداتا صح 🚀
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
