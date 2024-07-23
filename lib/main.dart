// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:galaxy_planets/controller/animate_pro.dart';
import 'package:galaxy_planets/view/detailpage.dart';
import 'package:galaxy_planets/view/home.dart';
import 'package:galaxy_planets/view/likepage.dart';
import 'package:galaxy_planets/view/splash.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences preferences;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  preferences = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AnimatePro(),
        ),
      ],
      builder: (context, child) => MaterialApp(
        title: "Planet App",
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        darkTheme: ThemeData.dark(useMaterial3: true),
        themeMode: Provider.of<AnimatePro>(context).isDark
            ? ThemeMode.light
            : ThemeMode.dark,
        initialRoute: "/",
        routes: {
          "/": (context) => Splash(),
          "Home": (context) => Home(),
          "DetailPage": (context) => DetailPage(),
          "LikePage": (context) => LikePage(),
        },
      ),
    );
  }
}
