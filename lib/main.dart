import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:relie_nquiry/firebase_options.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

/// push notification
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

/// 🔔 Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  _showNotification(message);
}

/// 🔔 Show local notification
Future<void> _showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    'High Importance Notifications',
    channelDescription: 'This channel is used for important notifications.',
    importance: Importance.max,
    priority: Priority.high,








    showWhen: true,
  );


  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  await flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.notification?.title ?? 'Notification',
    message.notification?.body ?? '',
    platformDetails,
    payload: message.data['category'] ?? '',
  );
}

/// 🔐 Get FCM Token
Future<void> getToken() async {
  try {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token != null) {
      print("🔐 FCM Token: $token");
    }
  } catch (e) {
    print("❌ Failed to get FCM token: $e");
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  //Local notification initialization
  const AndroidInitializationSettings androidInitSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initSettings = InitializationSettings(
    android: androidInitSettings,
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
    const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'Used for showing important notifications',
      importance: Importance.high,
    ),
  );




  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      if (payload != null && payload.isNotEmpty) {
        print("🔔 Notification clicked with payload: $payload");
        // Get.toNamed(payload);
      }
    },
  );

  // Background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Ask permission
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission();
  print('🔐 Permission granted: ${settings.authorizationStatus}');

  await getToken();

  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseMessaging.instance.subscribeToTopic(user.uid);
    print("📩 Subscribed to topic: ${user.uid}");
  }
  ///  rotaite of
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  /// auto update
  if (GetPlatform.isAndroid) {
    InAppUpdate.checkForUpdate().then((updateInfo) {
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        if (updateInfo.immediateUpdateAllowed) {
          InAppUpdate.performImmediateUpdate().then((result) {
            if (result == AppUpdateResult.success) {
              print("✅ Immediate update done.");
            }
          });
        } else if (updateInfo.flexibleUpdateAllowed) {
          InAppUpdate.startFlexibleUpdate().then((result) {
            if (result == AppUpdateResult.success) {
              InAppUpdate.completeFlexibleUpdate();
              print("✅ Flexible update done.");
            }
          });
        }
      }
    });
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Foreground handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📥 Foreground FCM received: ${message.notification?.title}");
      _showNotification(message);
    });

    // When tapped on notification in background
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      print("📲 App opened from background notification: ${message.data}");
    });

    // When app is opened from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("📲 App opened from terminated notification: ${message.data}");
      }
    });

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NQuiry',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: Routes.splashScreen,
      getPages: AppPages.routes,
    );
  }
}
// //
// // // import 'package:flutter/material.dart';
// // // import 'package:get/get.dart';
// // //
// // // import 'package:firebase_core/firebase_core.dart';
// // // import 'package:relie_nquiry/routes/app_routes.dart';
// // //
// // // import 'firebase_options.dart';
// // // import 'routes/app_pages.dart';
// // //
// // // void main() async {
// // //   WidgetsFlutterBinding.ensureInitialized();
// // //   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
// // //   runApp(MyApp());
// // // }
// // //
// // // class MyApp extends StatelessWidget {
// // //   const MyApp({super.key});
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return GetMaterialApp(
// // //       debugShowCheckedModeBanner: false,
// // //       title: 'Relie Enquiry',
// // //       theme: ThemeData(
// // //         // useMaterial3: true,
// // //         primarySwatch: Colors.green,
// // //       ),
// // //       // home:,
// // //       initialRoute: Routes.splashScreen,
// // //       getPages: AppPages.routes,
// // //     );
// // //   }
// // // }
// import 'package:flutter/material.dart';
// import 'bill_quotation_list_page.dart';
// // import 'package:relie_nquiry/bill_quotation_page.dart'; // இது HomePage-லவே import பண்ணிருப்பீங்க
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Relie Nquiry',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       // 👉 App start ஆனதும் HomePage தான் main screen
//       home: HomePage(),
//     );
//   }
// }
//
//
// class HomePage extends StatefulWidget {
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Home"),
//         backgroundColor: Colors.blue,
//       ),
//       body: Center(
//         child: ElevatedButton.icon(
//           icon: Icon(Icons.receipt_long),
//           label: Text("Go to Bill & Quotation"),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             foregroundColor: Colors.white,
//           ),
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => BillQuotationPage()),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
