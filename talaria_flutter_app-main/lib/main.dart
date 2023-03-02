import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:talaria/provider/add_outfits_provider.dart';
import 'package:talaria/provider/add_shoes_from_api_provider.dart';
import 'package:talaria/provider/admin_provider.dart';
import 'package:talaria/provider/auth_provider.dart';
import 'package:talaria/provider/dashboard_provider.dart';
import 'package:talaria/provider/individual_shoe_provider.dart';
import 'package:talaria/provider/product_detail_provider.dart';
import 'package:talaria/provider/search_provider.dart';
import 'package:talaria/ui/onBoarding/splash_screen.dart';
import 'package:talaria/utils/fmsg_handler/fmsg_handler.dart';
import 'package:talaria/utils/size_block.dart';

bool isLogin = false;
//This is add git
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(create: (_) => AuthProvider()),
      ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ChangeNotifierProvider(create: (_) => ProductDetailProvider()),
      ChangeNotifierProvider(create: (_) => SearchProvider()),
      ChangeNotifierProvider(create: (_) => AdminProvider()),
      ChangeNotifierProvider(create: (_) => IndividualShoeProvider()),
      ChangeNotifierProvider(create: (_) => AddShoesFromAPIProvider()),
      ChangeNotifierProvider(create: (_) => AddOutfitsProvider()),
    ], child: const MyApp()),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        builder: (BuildContext context, Widget? child) {
          SizeBlock().init(context);
          return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!);
        },
        theme: ThemeData(
            brightness: Brightness.dark,
            iconTheme: const IconThemeData().copyWith(color: Colors.white)),
        debugShowCheckedModeBanner: false,
        title: 'Talaria',
        home: Application(page: const SplashScreen()),
      );
    });
  }
}
