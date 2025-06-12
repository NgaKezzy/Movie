import 'dart:io';

import 'package:app/config/print_color.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  printGreen('Title : ${message.notification!.title}');
  printGreen('Body : ${message.notification!.body}');
  printGreen('Payload : ${message.data}');
}

class FirebaseApi {
  final firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // chõ này để kết nối với firebase khi vào app để lấy fcm token
    await firebaseMessaging.requestPermission();
    String? token;
    if (Platform.isIOS) {
      token = await firebaseMessaging.getAPNSToken();
    } else {
      token = await firebaseMessaging.getToken();
    }
    printGreen('Token : $token');
    // hàm này để chạy chế độ nền để nắng nghe thông báo
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      printGreen('Thông báo khi ứng dụng đang mở');
    });
  }
}
