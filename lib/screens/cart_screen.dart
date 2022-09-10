import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/orders.dart';
import '../widgets/cart_item.dart' as ci;

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Cart'),
        ),
        body: Column(
          children: <Widget>[
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(fontSize: 20),
                    ),
                    const Spacer(),
                    Consumer<Cart>(
                      builder: (context, cart, child) => Chip(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        label: Text(
                          '\$${cart.totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Consumer<Cart>(
                      builder: (context, cart, child) =>
                          OrderButton(cart: cart),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Consumer<Cart>(
                builder: ((context, cart, child) => ListView.builder(
                      itemCount: cart.items.length,
                      itemBuilder: ((context, index) => ci.CartItem(
                          id: cart.items.values.toList()[index].id,
                          productId: cart.items.keys.toList()[index],
                          title: cart.items.values.toList()[index].title,
                          quantity: cart.items.values.toList()[index].quantity,
                          price: cart.items.values.toList()[index].price)),
                    )),
              ),
            ),
          ],
        ));
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  const OrderButton({
    required this.cart,
    Key? key,
  }) : super(key: key);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  // ignore: prefer_final_fields
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount <= 0 || _isLoading)
            ? null
            : () async {
                setState(() {
                  _isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                    widget.cart.items.values.toList(), widget.cart.totalAmount);
                widget.cart.clear();
                setState(() {
                  _isLoading = false;
                });
              },
        child: !_isLoading
            ? const Text(
                'ORDER NOW',
              )
            : const CircularProgressIndicator());
  }
}
