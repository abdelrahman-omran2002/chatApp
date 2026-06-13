import 'package:chatapp/constants.dart';
import 'package:chatapp/models/message.dart';
import 'package:chatapp/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});

  static const String id = "ChatPage()";

  // تظبيط الـ variables لتكون final لمنع الـ Warnings 🎯
  final _scrollController = ScrollController();
  final _textController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    // استقبال الـ email اللي جاي من صفحة الـ Login
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    // تعريف الـ CollectionReference هنا كـ final جوه الـ build أو فوق
    final CollectionReference messages = _firestore.collection(
      kMessageCollections,
    );

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy(kTimestamp, descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // تحويل الـ docs لـ List من نوع Message باستخدام الموديل بتاعك 🚀
          final List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }

          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kPrimaryColor,
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(kLogoImagePath, height: 70),
                  const Text("ChatApp"),
                ],
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    itemBuilder: (context, index) {
                      final currentMessage = messagesList[index];

                      // كود المقارنة الذكي لتحديد مكان الرسالة بناءً على الـ email 📡
                      if (currentMessage.id == email) {
                        return ChatModelforFriend(
                          message: currentMessage.message,
                        ); // على اليمين
                      } else {
                        return ChatModel(
                          message: currentMessage.message,
                        ); // على الشمال
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    controller: _textController,
                    onSubmitted: (data) {
                      if (data.trim().isNotEmpty) {
                        messages.add({
                          kMessage: data.trim(),
                          kTimestamp: DateTime.now(),
                          "id": email,
                        });
                        _textController.clear();
                        _scrollDown();
                      }
                    },
                    style: const TextStyle(color: Colors.black87),
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      hintStyle: const TextStyle(color: Colors.grey),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        color: kPrimaryColor,
                        onPressed: () {
                          final data = _textController.text;
                          if (data.trim().isNotEmpty) {
                            messages.add({
                              kMessage: data.trim(),
                              kTimestamp: DateTime.now(),
                              "id": email,
                            });
                            _textController.clear();
                            _scrollDown();
                          }
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide(
                          color: kTextFieldBgColor.withOpacity(0.3),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: const BorderSide(
                          color: kPrimaryColor,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: kPrimaryColor),
            ),
          );
        }
      },
    );
  }

  // ميثود الأنيميشن عند إرسال رسالة جديدة
  void _scrollDown() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
