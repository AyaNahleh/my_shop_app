import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:provider/provider.dart';
import 'package:myshop/widgets/cart_item.dart' as ci;
import 'package:myshop/providers/orders.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cart.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (ctx, index) => ci.CartItem(
                    productId: cart.items.keys.toList()[index],
                    id: cart.items.values.toList()[index].id,
                    title: cart.items.values.toList()[index].title,
                    quantity: cart.items.values.toList()[index].quantity,
                    price: cart.items.values.toList()[index].price)),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cart.totalAmount<=0||_isLoading)
          ? null
          :() async{
        setState((){
          _isLoading=true;
        });
       await Provider.of<Orders>(context, listen: false).addOrder(
            widget.cart.items.values.toList(),
           widget.cart.totalAmount);
        setState((){
          _isLoading=false;
        });
        widget.cart.clear();
      },
      child: _isLoading
          ?const CircularProgressIndicator()
          :Text(
        'ORDER NOW',
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}
