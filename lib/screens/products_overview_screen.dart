import 'package:flutter/material.dart';
import 'package:myshop/providers/cart.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/cart_screen.dart';
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/products_grid.dart';
import 'package:provider/provider.dart';
import 'package:myshop/widgets/badge.dart';

enum FilterOption {
  favorites,
  all,
}

class ProductOverviewScreen extends StatefulWidget {
  const ProductOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductOverviewScreen> createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit=true;
  var _isLoading=false;

  @override
  //void initState() {
    //this is wont work because of context but if you put listen to false it work
   // Provider.of<Products>(context).fetchAndSetProduct();
    // this 2 ways to solve this
    //1
    // Future.delayed(Duration.zero).then((value) {
    //   Provider.of<Products>(context).fetchAndSetProduct();
    // });
    //2 is using didChange
  //  super.initState();
 // }

  @override
  //it run after init and before build and run multiTimes
  void didChangeDependencies() {
    if(_isInit){
      setState((){
        _isLoading=true;
        });
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        setState((){
          _isLoading=false;

        });

      });

    }
    //to make sure that its run just one time
    _isInit=false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOption val) {
              setState(() {
                if (val == FilterOption.favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOption.favorites,
                child: Text('Only Favorites'),
              ),
              const PopupMenuItem(
                value: FilterOption.all,
                child: Text('Show All'),
              ),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cartData, ch) => Badge(
              value:cartData.itemCount.toString(),
              child:ch!,
                ),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading?const Center(child: CircularProgressIndicator()):
      ProductsGrid(showFav: _showOnlyFavorites),
    );
  }
}
