import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'controllers/auth/lupa_password_controller.dart';
import 'controllers/home_controller.dart';
import 'ui/pages/auth/lupa_password/cek_kode_page.dart';
import 'ui/pages/auth/lupa_password/lupa_password_page.dart';
import 'ui/pages/auth/lupa_password/lupa_ubah_password_page.dart';
import 'ui/pages/auth/register_page.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import 'constants.dart';
import 'controllers/auth/login_controller.dart';
import 'models/user_model.dart';
import 'ui/pages/auth/login_page.dart';
import 'ui/pages/home_page.dart';
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
                title: "Mount Slamet",
                debugShowCheckedModeBanner: false,
                initialRoute: '/',
                theme: appThemeData,
                defaultTransition: Transition.native,
                getPages: [
                  GetPage(name: "/", page: () => SplashScreenPage()),
                  GetPage(
                      name: "/auth/login",
                      page: () => LoginPage(),
                      binding: LoginBind()),
                  GetPage(name: "/auth/register", page: () => RegisterPage()),
                  GetPage(
                      name: "/auth/forget_password",
                      page: () => LupaPasswordPage(),
                      binding: LupaPasswordBind()),
                  GetPage(
                      name: "/auth/forget_password/cek_kode",
                      page: () => CekKodePage()),
                  GetPage(
                      name: "/auth/forget_password/change_password",
                      page: () => LupaUbahPasswordPage()),
                  GetPage(
                      name: "/home",
                      page: () => HomePage(),
                      binding: HomeBind()),
                ]));
  }
}

class HomeBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}

class LoginBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }
}

class LupaPasswordBind extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LupaPasswordController>(() => LupaPasswordController());
  }
}
