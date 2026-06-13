import 'package:flutter/material.dart';

// اللون الأساسي بتاعك (خلفية الشاشة مثلاً)
const kPrimaryColor = Color(0xFF414C8D);

// 1. لون خفيف جداً وهادي ومناسب جداً كخلفية للـ TextField جوه شاشتك الداكنة
const kSecondaryColor = Color(0xFF5A66A8); // درجة أفتح من الأزرق بتاعك

// 2. لون أفتح كمان ومائل للرمادي/الأزرق (لو حابب الـ TextField يكون بارز أكتر)
const kTextFieldBgColor = Color(0xFF727EB8);

// 3. ألوان الـ Gradient (التدريج) لزرار الـ CustomButton
const kGradientStartColor = Color(
  0xFF5361B5,
); // أزرق فاتح مبهج يبدأ منه التدريج
const kGradientEndColor = Color(
  0xFF2E3666,
); // درجة أغمق ينتهي عندها التدريج ليعطي عمق للزرار
const kChatGradientStartColor = Color.fromARGB(
  255,
  10,
  151,
  170,
); // لون بداية التدريج لرسائل الشات
const kLogoImagePath = "assets/images/newLogo.png"; // مسار الصورة الجديدة للوجو

const kMessageCollections = "messages"; // اسم مجموعة الرسائل في Firestore
const kMessage = "message"; // اسم الحقل اللي بيحتوي نص الرسالة في Firestore
const kTimestamp = "timestamp"; // اسم الحقل اللي بيحتوي توقيت الرسالة في Firestore