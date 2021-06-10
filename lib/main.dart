import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'constants.dart';
import 'models/user_model.dart';
import 'ui/pages/auth/login_page.dart';
import 'ui/pages/splash_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Digunakan untuk memaksa potrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // Inisialisasi library hive (penyimpanan mirip SQLite)
  var appDocumentDirectory =
      await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(UserModelAdapter());
  // Inisialisasi library onesignal
  OneSignal.shared.setAppId(Constants.oneSignalKey);
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    print("Accepted permission: $accepted");
  });
  // OSDeviceState device = await OneSignal.shared.getDeviceState();
  // String userId = device.userId;
  // print("userId " + userId);
  // Run Aplikasi
  runApp(App());
}

class AppController extends GetxController {
  @override
  void onInit() {
    // Inisialisasi notifikasi one signal]
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent handler) {
      print("notif title ${handler.notification.title}");
      print("notif body ${handler.notification.body}");
      // a notification has been received
    });
    super.onInit();
  }
}

// inisialisasi Tema aplikasi
final ThemeData appThemeData = ThemeData(
  scaffoldBackgroundColor: Color(0xFFF8F8F8),
  primaryColor: Colors.blueAccent,
  primarySwatch: Colors.blue,
  appBarTheme: AppBarTheme(color: Colors.transparent, elevation: 0),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  fontFamily: 'Roboto',
  textTheme: TextTheme(
    headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
  ),
);

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(Constants.screenWidth, Constants.screenHeight),
        builder: () => GetMaterialApp(
                title: "Wholesale",
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                theme: appThemeData,
                defaultTransition: Transition.native,
                getPages: [
                  GetPage(name: "/", page: () => SplashScreenPage()),
                  GetPage(name: "/auth/login", page: () => LoginPage()),
                ]));
  }
}
