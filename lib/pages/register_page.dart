import 'package:chatapp/constants.dart';
import 'package:chatapp/widgets/custom_button.dart';
import 'package:chatapp/widgets/custom_text.dart'; // تأكد إن ده ملف الـ CustomTextField بتاعك
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  static const String id = "RegisterPage()";

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;

  String? password;

  bool isLoading = false;
  // متغير جديد عشان نتحكم في ظهور الـ Progress HUD
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall:
          isLoading, // حطيناها false عشان ما تظهرش ال Progress HUD طول الوقت
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 40),
                Image.asset(kLogoImagePath, height: 150),
                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                // ✉️ خانة الإيميل مع الـ Validator بتاعها
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    onChanged: (data) {
                      email = data;
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      // للتأكد إن صيغة الإيميل صحيحة وفيها @ و .com
                      if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                      ).hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Enter your email',
                    obscureText: false,
                  ),
                ),

                // 🔐 خانة الباسورد القوية والواقعية
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextField(
                    onChanged: (data) {
                      password = data;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      // تشيك على الحرف الكابتل A-Z
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return 'Must contain at least one uppercase letter (A-Z)';
                      }
                      // تشيك على الأرقام 0-9
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return 'Must contain at least one number (0-9)';
                      }
                      // تشيك على العلامات الخاصة زي @ أو # أو $ إلخ
                      if (!RegExp(
                        r'[!@#\$%^&*(),.?":{}|<>_-]',
                      ).hasMatch(value)) {
                        return 'Must contain at least one special character (@, #, \$, etc.)';
                      }
                      return null;
                    },
                    labelText: 'Password',
                    keyboardType: TextInputType.text,
                    hintText: 'Enter your password',
                    obscureText: true,
                    isPassword: true, // خليها true عشان يظهر زرار العين
                  ),
                ),

                const SizedBox(height: 20),

                // زرار التسجيل
                CustomButton(
                  text: "Register",
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      // 1. شغل الـ Spinner وحدّث الشاشة فوراً
                      setState(() {
                        isLoading = true;
                      });

                      try {
                        var auth = FirebaseAuth.instance;
                        await auth.createUserWithEmailAndPassword(
                          email: email!.trim(),
                          password: password!,
                        );

                        showSnackBar(context, 'Success! Account Created.');

                        // 2. اخرج بره صفحة التسجيل وارجع للـ Login فوراً بعد النجاح 🚀
                        Navigator.pop(context);
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'email-already-in-use') {
                          showSnackBar(
                            context,
                            'This email is already registered.',
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
                        // 3. الـ finally دي هي البطل! هتطفي الـ Spinner وتعمل setState غصب عن أي أيرور 🛡️
                        setState(() {
                          isLoading = false;
                        });
                      }
                    }
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Sign In",
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
    );
  }

  void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
