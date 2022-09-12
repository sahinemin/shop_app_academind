import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/user_product_item.dart';
import '../providers/products.dart';

class UserProductScreen extends StatelessWidget {
  const UserProductScreen({super.key});
  static const String routeName = '/userProducts';
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      _refreshProducts(context);
                    },
                    child: SafeArea(
                      child: Consumer<Products>(
                        builder: (context, products, child) => ListView.builder(
                          itemCount: products.items.length,
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                  id: products.items[i].id,
                                  title: products.items[i].title,
                                  imageUrl: products.items[i].imageUrl),
                              const Divider(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
