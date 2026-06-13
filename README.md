A Professional Real-time Chat Application built with Flutter and Firebase Firestore.

🚀 Features implemented in my way:
Real-time Chatting: Uses Firebase Firestore StreamBuilder to receive and display messages instantly without manual refresh.
Smart Chat Bubbles: Custom-designed UI bubbles inspired by WhatsApp (dynamic size and padding based on message length).
Auto Scroll Down: Chat automatically animates and scrolls to the latest message smoothly upon sending.
Dynamic Message Alignment: Messages are smartly aligned (Right side for Current Sender / Left side for Receiver) by validating Firebase user IDs.
Secure Password Field: Custom Stateful text field equipped with a toggleable eye icon to show/hide passwords safely.
Keyboard-Safe Layout: UI dynamically adjusts and shrinks when the virtual keyboard pops up to prevent any screen overflow (Yellow lines bug).
🛠️ Tech Stack & Architecture:
Framework: Flutter (Dart)
Backend: Firebase Authentication & Cloud Firestore DB
State Management & Architecture: Clean Folder Structure (Models, Views, Widgets) for high scalability.