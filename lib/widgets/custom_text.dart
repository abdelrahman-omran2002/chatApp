import 'package:chatapp/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextInputType keyboardType;
  final String hintText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool isPassword; // 1. ضفنا flag نعرف بيه هل ده حقل باسورود ولا لأ 🎯

  const CustomTextField({
    super.key,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    required this.hintText,
    this.onChanged,
    this.validator,
    this.isPassword = false,
    required bool
    obscureText, // العادي بتاعه إنه مش باسورد (يعني للإيميل مش هيظهر عين)
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  // متغير داخلي نتحكم بيه في إخفاء وإظهار النص
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // 1. التعديل السحري هنا: لو هو باسورد، خليه مخفي (true) في الأول دايماً 🎯
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validator,
      onChanged: widget.onChanged,
      obscureText: _obscureText, // بياخد القيمة ويقفل النص لو true
      keyboardType: widget.keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: kSecondaryColor,
        hintText: widget.hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.white),

        // لو هو باسورود اظهر زرار العين، لو لأ سيبه فاضي
        suffixIcon: widget.isPassword
            ? IconButton(
                icon: Icon(
                  // 2. تظبيط شكل شكل الأيقونة على حسب النص مخفي ولا ظاهر 👇
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.white70,
                ),
                onPressed: () {
                  // بنعكس الحالة عشان النص يظهر أو يختفي
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null, // للإيميل مش هيظهر أيقونة خالص

        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: kTextFieldBgColor),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
