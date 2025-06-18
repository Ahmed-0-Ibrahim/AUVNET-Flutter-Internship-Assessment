import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_internship_task/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_internship_task/features/auth/presentation/pages/login_page.dart';
import 'package:flutter_internship_task/features/auth/presentation/pages/signup_page.dart';
import 'package:flutter_internship_task/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flutter_internship_task/features/cart/presentation/pages/cart_page.dart';
import 'package:flutter_internship_task/features/home/presentation/pages/home_page.dart';
import 'package:flutter_internship_task/features/product/presentation/pages/product_details_page.dart';
import 'package:flutter_internship_task/features/product/presentation/pages/product_list_page.dart';
import 'package:hive_flutter/adapters.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox('preferences');
  await Hive.openBox('products');
  await Hive.openBox('cart');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (context) => AuthBloc()),
        BlocProvider<CartBloc>(
          create: (context) => CartBloc(),
        ), // Ensure CartBloc is provided here
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter E-commerce App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute:
            FirebaseAuth.instance.currentUser == null ? '/login' : '/',
        routes: {
          '/': (context) => HomePage(),
          '/login': (context) => LoginPage(),
          '/signup': (context) => SignupPage(),
          '/products': (context) => const ProductListPage(),
          '/productDetails': (context) => const ProductDetailsPage(),
          '/cart': (context) => const CartPage(),
        },
      ),
    );
  }
}
