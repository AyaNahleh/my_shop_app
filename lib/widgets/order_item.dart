import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart' as ord;
import 'package:intl/intl.dart';
import 'dart:math';

class OrderItem extends StatefulWidget {
  const OrderItem({Key? key, required this.orderItem}) : super(key: key);
  final ord.OrderItem orderItem;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.orderItem.amount}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                .format(widget.orderItem.dateTime)),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 4),

              height: min(widget.orderItem.products.length * 20.0 + 10, 100),
              child: ListView(
                  children: widget.orderItem.products
                      .map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                e.title,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${e.quantity}x \$${e.price}',
                                style:
                                    const TextStyle(fontSize: 18, color: Colors.grey),
                              )
                            ],
                          ))
                      .toList()),
            )
        ],
      ),
    );
  }
}
