
import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProduct(BuildContext context)async{
    await Provider.of<Products>(context,listen: false).fetchAndSetProducts(true);
  }
  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder:(ctx,snapshot)=>
        snapshot.connectionState==ConnectionState.waiting?const Center(child: CircularProgressIndicator()):
          RefreshIndicator(
          onRefresh: ()=>_refreshProduct(context),
          child: Consumer<Products>(
            builder:(ctx,productsData,_)=> Padding(
              padding: const EdgeInsets.all(8),
              child: ListView.builder(
                itemCount: productsData.items.length,
                itemBuilder: (_, index) => Column(
                  children: [
                    UserProductItem(
                        id: productsData.items[index].id,
                        title: productsData.items[index].title,
                        imageUrl: productsData.items[index].imageUrl),
                    const Divider(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
