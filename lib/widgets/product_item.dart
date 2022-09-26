import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;

  const ProductItem({Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   final product= Provider.of<Product>(context,listen: false);
   final cart=Provider.of<Cart>(context,listen: false);
   final authData=Provider.of<Auth>(context,listen: false);
    return  ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: GridTile(
            footer: GridTileBar(
              backgroundColor: Colors.black87,
              leading: Consumer<Product>(
                builder: (ctx,product,child)=>
                 IconButton(
                  icon: Icon(product.isFavorite?Icons.favorite:Icons.favorite_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    product.toggleFavoriteStatus(authData.token,authData.userId);
                  },
                ),
                child: const Text('never changes'),
              ),

              trailing: IconButton(
                icon: Icon(Icons.shopping_cart,
                    color: Theme.of(context).colorScheme.secondary),
                onPressed: () {
                  cart.addItem(product.id, product.price, product.title);
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: const Text('Added item to const art!',),
                        duration: const Duration(seconds: 3),
                        action: SnackBarAction(label: 'CANCEL',
                          onPressed: (){
                          cart.removeSingleItem(product.id);
                          },
                        ),
                      ),);

                },
              ),
              title: Text(
                product.title,
                textAlign: TextAlign.center,
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id);
              },
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            )),


    );
  }
}
