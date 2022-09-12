import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/app_drawer.dart';
import '../screens/cart_screen.dart';
import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/products_grid.dart';

enum FilterOptions { favorites, all }

class ProductOverview extends StatefulWidget {
  static const routeName = '/productOverview';
  const ProductOverview({super.key});

  @override
  State<ProductOverview> createState() => _ProductOverviewState();
}

class _ProductOverviewState extends State<ProductOverview> {
  // ignore: prefer_final_fields
  bool _isInit = false;
  // ignore: prefer_final_fields
  bool _isLoading = true;

  bool _showOnlyFavorites = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      Provider.of<Products>(context).fetchProducts().then((_) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }).onError((error, stackTrace) {
        if (mounted) {
          setState(() {
            _isLoading = true;
          });
        }
      });
    } else {
      _isInit = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyShop"),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text("Favorites"),
              ),
              PopupMenuItem(
                value: FilterOptions.all,
                child: Text("Show All"),
              )
            ],
          ),
          Consumer<Cart>(
              builder: (_, cart, ch) => Badge(
                    value: cart.itemCount.toString(),
                    color: Colors.white,
                    child: ch!,
                  ),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
                },
              ))
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ProductsGrid(
              showFavorites: _showOnlyFavorites,
            ),
    );
  }
}
