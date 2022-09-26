import 'package:flutter/material.dart';
import 'package:myshop/providers/products.dart';
import 'package:myshop/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';

class UserProductItem extends StatelessWidget {
  final String? id;
  final String title;
  final String imageUrl;
  const UserProductItem({Key? key, required this.title, required this.imageUrl, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scaffold=ScaffoldMessenger.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: (){

                Navigator.of(context).pushNamed(EditProductScreen.routeName,arguments: id);
                
              }, 
              icon: const Icon(Icons.edit),
              color: Theme.of(context).primaryColor,),
            IconButton(
              onPressed: ()async{
                try{
                  await Provider.of<Products>(context,listen: false).deleteProduct(id!);
                }catch (error){
                 scaffold.showSnackBar( const SnackBar(content:Text('Deleting failed!',textAlign: TextAlign.center
                   ,)));

                }

              },
              icon: const Icon(Icons.delete),
              color: Theme.of(context).errorColor,)

          ],
        ),
      ),
    );
  }
}
