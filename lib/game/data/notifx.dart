import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:verdeForest/game/data/notifications.dart';

class NotificationServverdeForestFb {
  late final FirebaseMessaging _messaging;

  PushNotification? _notificationInfo;
  final localNotverdeForestServverdeForest = LocalNotverdeForestServverdeForest();

  activate() {
    registerNotification();
    checkForInitialMessage();
    listen();
  }

  void registerNotification() async {
    _messaging = FirebaseMessaging.instance;
    localNotverdeForestServverdeForest.setup();

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
     

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {

        _notificationInfo = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
          dataTitle: message.data['title'],
          dataBody: message.data['body'],
        );

        if (_notificationInfo != null) {
          localNotverdeForestServverdeForest.addNotification(
            _notificationInfo!.title ?? '',
            _notificationInfo!.body ?? '',
          );
        }
      });
    } else {
    }
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _notificationInfo = PushNotification(
        title: initialMessage.notification?.title,
        body: initialMessage.notification?.body,
        dataTitle: initialMessage.data['title'],
        dataBody: initialMessage.data['body'],
      );
    }
  }

  listen() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _notificationInfo = PushNotification(
        title: message.notification?.title,
        body: message.notification?.body,
        dataTitle: message.data['title'],
        dataBody: message.data['body'],
      );
    });
  }

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
  }
}

class PushNotification {
  PushNotification({
    this.title,
    this.body,
    this.dataTitle,
    this.dataBody,
  });

  String? title;
  String? body;
  String? dataTitle;
  String? dataBody;
}
