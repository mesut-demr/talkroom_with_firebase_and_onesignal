import 'package:comment_system/product/router/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  OneSignal.shared.setAppId("app_id"); //* You will write your OneSignal app ID here
  OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true);
  OneSignal.shared.setNotificationOpenedHandler((OSNotificationOpenedResult result) {
    print('NOTIFICATION OPENED HANDLER CALLED WITH: ${result}');
  });

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    print("height: ${MediaQuery.of(context).size.height}");
    print("width: ${MediaQuery.of(context).size.width}");
    return ScreenUtilInit(
      designSize: Size(411, 890),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        theme: ThemeData(textTheme: GoogleFonts.merriweatherTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}
