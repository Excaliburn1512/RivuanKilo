import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rivu_v1/colors.dart';
import 'package:rivu_v1/core/services/firebase_service.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService(ref);
});

class NotificationService {
  final Ref _ref;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  NotificationService(this._ref);

  /// Panggil fungsi ini di initState halaman Home
  Future<void> init() async {
    // 1. Request Permission (Logic dipindah ke sini agar muncul di UI)
    await _requestPermission();

    // 2. Listener saat aplikasi dibuka (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Pesan FCM diterima di foreground: ${message.notification?.title}");

      RemoteNotification? notification = message.notification;

      if (notification != null) {
        AwesomeNotifications().createNotification(
          content: NotificationContent(
            id: notification.hashCode,
            channelKey: 'basic_channel',
            title: notification.title,
            body: notification.body,
            notificationLayout: NotificationLayout.Default,
            color: AppColors.primary,
          ),
        );
      }
    });

    // 3. Subscribe ke Topik Device
    _subscribeToCurrentSystem();
  }

  Future<void> _requestPermission() async {
    // Cek izin Awesome Notifications (Android/iOS)
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Tampilkan dialog izin bawaan OS
      await AwesomeNotifications().requestPermissionToSendNotifications();
    }

    // Cek izin FCM (Khusus iOS perlu ini juga)
    await _fcm.requestPermission(alert: true, badge: true, sound: true);
  }

  Future<void> _subscribeToCurrentSystem() async {
    final systemId = _ref.read(currentSystemIdProvider);
    if (systemId != null) {
      await _fcm.subscribeToTopic(systemId);
      print("🔔 [Awesome] Subscribed to FCM Topic: $systemId");
    }
  }
}
