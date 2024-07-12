

import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:kushi_3/notification/notification_service.dart';

import 'package:kushi_3/pages/check_permissions.dart';
import 'package:kushi_3/pages/contact_us.dart';
import 'package:kushi_3/pages/faqs.dart';
import 'package:kushi_3/pages/how_its_work.dart';
import 'package:kushi_3/pages/introslider.dart';
import 'package:kushi_3/pages/mainactivity.dart';
import 'package:kushi_3/pages/notifications.dart';

import 'package:kushi_3/pages/otp.dart';
import 'package:kushi_3/pages/privacy_policy.dart';
import 'package:kushi_3/pages/refer_page.dart';
import 'package:kushi_3/pages/referal_code.dart';

import 'package:kushi_3/pages/selectGender.dart';
import 'package:kushi_3/pages/selectHeight.dart';
import 'package:kushi_3/pages/selectWeight.dart';
import 'package:kushi_3/pages/signup.dart';
import 'package:kushi_3/pages/venAndVarn.dart';
import 'package:kushi_3/service/auth/auth_gate.dart';
import 'package:kushi_3/service/auth/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:kushi_3/pages/signin.dart';
import 'package:kushi_3/themes/dark_mode.dart';
import 'package:kushi_3/themes/light_mode.dart';




void main() async {
  WidgetsFlutterBinding
      .ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    if (!isAllowed) {
      AwesomeNotifications().requestPermissionToSendNotifications();
    }
  });
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Notify.initializeNotification();
  await Notify.scheduleDailyNotifications();

  // await FirebaseAppCheck.instance.activate();
  // NotificationService.initialize();
  // NotificationService.scheduleNotifications();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      // Provide AuthService

      // Provide ContactProvider
    ],
    // ChangeNotifierProvider(create: (context) => ContactProvider(),
    child: const MyApp(),
  )); // Run your application
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "flutter demo",
      theme: lightMode,
      darkTheme: darkMode,
      routes: {
        '/OTPPage': (context) => const OTPVerificationPage(),
        '/selectGender': (context) => const SelectGender(),
        '/selectHeight': (context) => const SelectHeight(),
        '/selectWeight': (context) => const SelectWeight(),

        '/phoneVerification': (context) => const SignIn(),
        '/userinfo': (context) => const SignUp(),

        '/referalpage': (context) => const ReferralScreen(),
        '/referalLink': (context) => const ReferalPage(),
        '/stepper': (context) => StepperDemo(),
        '/notification': (context) => NotificationPage(),
        '/contactus': (context)=> ContactUsPage(),
        '/faqs': (context)=> Faqs(),
        '/howitsworks': (context)=> HowItsWork(),
        '/privacypolicy':(context)=> PrivacyPolicy(),
        '/venAndVarn':(context)=> VenVarn(),
        '/main_activity':(context)=> MainActivity(),


      },
      home:StepperDemo(),
    );
  }
}




