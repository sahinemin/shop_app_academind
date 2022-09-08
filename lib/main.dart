import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/edit_product_screen.dart';
import './screens/user_products_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview.dart';

void main() {
  final ThemeData theme = ThemeData(fontFamily: 'Lato');
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Products(),
          ),
          ChangeNotifierProvider(
            create: (_) => Cart(),
          ),
          ChangeNotifierProvider(
            create: (_) => Orders(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
                primary: Colors.purple,
                secondary: Colors.deepOrange,
                error: Colors.red),
          ),
          routes: {
            ProductDetailScreen.routeName: (_) => const ProductDetailScreen(),
            CartScreen.routeName: (_) => const CartScreen(),
            OrdersScreen.routeName: (_) => const OrdersScreen(),
            UserProductScreen.routeName: (_) => const UserProductScreen(),
            EditProductScreen.routeName: (_) => const EditProductScreen(),
          },
          home: const ProductOverview(),
        )),
  );
}
