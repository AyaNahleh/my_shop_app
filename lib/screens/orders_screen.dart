import 'package:flutter/material.dart';
import 'package:myshop/providers/orders.dart' show Orders;
import 'package:myshop/widgets/app_drawer.dart';
import 'package:myshop/widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget{
  static const routeName='/orders';
  const OrdersScreen({Key? key}) : super(key: key);

 // var _isLoading=false;

  //@override
  // void initState() {
  //   _isLoading=true;
  //     Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_) => {
  //     setState((){
  //     _isLoading=false;
  //     })
  //     });
  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    // final ordersData=Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Your Orders'),),
      drawer: const AppDrawer(),
      body:FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchAndSetOrders(),
        builder: (ctx,dataSnapshot){
          if(dataSnapshot.connectionState==ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          }else {
            if(dataSnapshot.error!=null){
              return const Center(child: Text('No Orders yet'),);
              //do error handling stuff
            }
            else{
              return Consumer<Orders>(builder: (ctx,orderData,child)=>ListView.builder(
                itemCount: orderData.orders.length,
                itemBuilder: (ctx,index)=>
                    OrderItem(orderItem: orderData.orders[index]),
              ));
            }
          }
        },
      )

    );
  }
}
