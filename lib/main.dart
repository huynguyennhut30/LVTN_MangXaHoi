import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:lvtn_mangxahoi/provider/post_provider.dart';
import 'package:lvtn_mangxahoi/provider/user_provider.dart';
import 'package:lvtn_mangxahoi/screens/login_screens.dart';
import 'package:provider/provider.dart';

import 'responsive/mobile_screen_layout.dart';
import 'responsive/responsive_layout_screen.dart';
import 'responsive/web_screen_layout.dart';
import 'utils/colors.dart';
import 'package:lvtn_mangxahoi/utils/sharedpreference.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await sharedPreferences.initPreference();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBa5jQTEknJWc6Kdy-OP-YYKX3Ovsvwh10',
        appId: '1:830435108300:web:6dc54afcd9fe60976d6969',
        messagingSenderId: '830435108300',
        projectId: 'instagram-145d3',
        storageBucket: 'instagram-145d3.appspot.com',
      ),
    );
  } else {
    await Firebase.initializeApp(
        // options: DefaultFirebaseOptions.currentPlatform,
        );
  }
  var result = await FlutterNotificationChannel.registerNotificationChannel(
    description: 'Your channel description',
    id: 'chats',
    importance: NotificationImportance.IMPORTANCE_HIGH,
    name: 'Chats',
  );
  log('Result: $result');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PostsProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Snapshare',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        // home: ResponsiveLayout(
        //   mobileScreenLayout: MobileScreenLayout(),
        //   webScreenLayout: WebScreenLayout(),
        // ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.idTokenChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobileScreenLayout: MobileScreenLayout(),
                  webScreenLayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  // color: primaryColor,
                  color: secondaryColor,
                ),
              );
            }
            return const LoginScreens();
          },
        ),
      ),
    );
  }
}
