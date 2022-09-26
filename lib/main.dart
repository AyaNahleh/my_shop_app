import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/orders.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/screens/orders_screen.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/products_overview_screen.dart';
import 'package:myshop/screens/splash_screen.dart';
import 'package:myshop/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:myshop/providers/cart.dart';
import './screens/auth_screen.dart';

void main() {
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
            create: (ctx) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (_) => Products(null, [], ""),
            update: (ctx, auth, previousProducts) => Products(
                auth.token,
                previousProducts == null ? [] : previousProducts.items,
                auth.userId),
          ),
          ChangeNotifierProvider(
            create: (ctx) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
            create: (_) => Orders(null, [], ''),
            update: (ctx, auth, previousProducts) => Orders(
                auth.token,
                previousProducts == null ? [] : previousProducts.orders,
                auth.userId),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.purple,
              ),
              primaryColor: Colors.purple,
              colorScheme: ColorScheme.fromSwatch()
                  .copyWith(secondary: Colors.orangeAccent),
              fontFamily: 'Lato',
            ),
            title: 'My Shop App',
            home: auth.isAuth
                ? const ProductOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) => authResultSnapshot.connectionState==ConnectionState.waiting
                        ? SplashScreen()
                        :const AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  const ProductDetailScreen(),
              CartScreen.routeName: (ctx) => const CartScreen(),
              OrdersScreen.routeName: (ctx) => const OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => const EditProductScreen(),
            },
          ),
        ));
  }
}
