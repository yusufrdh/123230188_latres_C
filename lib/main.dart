import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/cart_item_model.dart';
import 'services/auth_service.dart';
import 'views/login_page.dart';
import 'views/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CartItemAdapter());


  final authService = AuthService();
  final loggedInUser = await authService.getLoggedInUser();

  runApp(MyApp(initialUser: loggedInUser));
}

class MyApp extends StatelessWidget {
  final String? initialUser;

  const MyApp({super.key, this.initialUser});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portal Premium E-Commerce',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black87,
        scaffoldBackgroundColor: Colors.white,
      ),

      home: initialUser != null && initialUser!.isNotEmpty
          ? const MainPage()
          : const LoginPage(),
    );
  }
}