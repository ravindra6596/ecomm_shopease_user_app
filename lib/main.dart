import 'dart:developer';

import 'package:e_comm_user/core/api_client.dart';
import 'package:e_comm_user/core/dio_client.dart';
import 'package:e_comm_user/core/shared_pref_helper.dart';
import 'package:e_comm_user/di/configure.dart';
import 'package:e_comm_user/routes/app_routes.dart';
import 'package:e_comm_user/service/notification_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  // Handle background fetch here
  await Firebase.initializeApp();
}
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  NotificationService().initialize();
  FirebaseMessaging.onMessage.listen(
        (RemoteMessage message) {
      log(message.notification?.title??'');
    },
  );
  configureDependencies();
  registerAdditionalDependencies();
  AppRoutes().setupLocator();
  await SharedPrefHelper.generateGuestId();
  runApp(MyApp());
  getIt.registerSingleton<DioSingleton>(DioSingleton());

  final dio = getIt<DioSingleton>().dio;
  getIt.registerSingleton<ApiClient>(ApiClient(dio));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final appRouter = getIt<AppRoutes>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final data = NotificationService.pendingNotification;
      if (data != null) {
        NotificationService.pendingNotification = null;
        NotificationService().handleNotificationNavigation(data);
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
        builder: (context, orientation, screenType) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: appRouter.config(),
        );
      }
    );
  }
}
