import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newapp/screens/home_screen.dart';
import 'package:newapp/screens/login_screen.dart';
import 'package:newapp/screens/cart_screen.dart';
import 'package:newapp/screens/profile_screen.dart';
import 'package:newapp/screens/favorite_screen.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthService(),
      child: MaterialApp(
        title: 'Grocery App',
        theme: ThemeData(primarySwatch: Colors.green),
        home: Consumer<AuthService>(
          builder: (context, authService, _) =>
              authService.isSignedIn ? HomeScreen() : LoginScreen(),
        ),
        routes: {
          '/home': (_) => HomeScreen(),
          '/cart': (_) => CartScreen(),
          '/profile': (_) => ProfilePage(),
          '/login': (_) => LoginScreen(), // Added route for login screen
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/favorites') {
            final userId = settings.arguments as String;
            return MaterialPageRoute(
              builder: (context) => FavoritesPage(userId: userId),
            );
          }
          return null;
        },
      ),
    );
  }
}
