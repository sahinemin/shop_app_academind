import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/auth.dart';
import './providers/orders.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview.dart';
import './widgets/splash_screen.dart';

void main() {
  final ThemeData theme = ThemeData(fontFamily: 'Lato');
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products("", "", []),
            update: (context, auth, previousProducts) => Products(
                auth.token, auth.userId, previousProducts?.items ?? []),
          ),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => Orders("", "", []),
              update: (context, auth, previousOrders) => Orders(
                  auth.token, auth.userId, previousOrders?.orders ?? [])),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, child) {
            return MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme: theme.copyWith(
                colorScheme: theme.colorScheme.copyWith(
                    primary: Colors.purple,
                    secondary: Colors.deepOrange,
                    error: Colors.red),
              ),
              routes: {
                ProductDetailScreen.routeName: (_) =>
                    const ProductDetailScreen(),
                CartScreen.routeName: (_) => const CartScreen(),
                OrdersScreen.routeName: (_) => const OrdersScreen(),
                UserProductScreen.routeName: (_) => const UserProductScreen(),
                EditProductScreen.routeName: (_) => const EditProductScreen(),
                ProductOverview.routeName: (_) => const ProductOverview()
              },
              home: auth.isAuth
                  ? const ProductOverview()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? const SplashScreen()
                              : const AuthScreen()),
            );
          },
        )),
  );
}
