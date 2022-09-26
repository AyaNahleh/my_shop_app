import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';
import 'package:myshop/widgets/product_item.dart';
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key, required this.showFav }) : super(key: key);

  final bool showFav;


  @override
  Widget build(BuildContext context) {
    final productsData= Provider.of<Products>(context);
    final products=showFav?productsData.favoriteItems:productsData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child:const ProductItem(
          // id: products[index].id,
          // title: products[index].title,
          // imageUrl: products[index].imageUrl
        ),),
      itemCount: products.length,
      padding: const EdgeInsets.all(10),
    );
  }
}
