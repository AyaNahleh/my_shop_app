
import 'package:flutter/material.dart';
import 'package:myshop/providers/product.dart';
import 'package:myshop/providers/products.dart';
import 'package:provider/provider.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  const EditProductScreen({Key? key}) : super(key: key);

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();

  final _imageUrlController = TextEditingController();
  var _isInit=true;
  var _initValues={
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':''
  };

  final _form = GlobalKey<FormState>();
  var _editProduct = Product(
      title: '',
      id: null,
      price: 0,
      description: '',
      imageUrl: '');

  var _isLoading=false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);

    super.initState();
  }
  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId=ModalRoute.of(context)!.settings.arguments ;
      if(productId!=null) {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId.toString());
        _initValues = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text=_editProduct.imageUrl;
      }
    }
    _isInit=false;
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https'))||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.jpeg'))){
        return ;
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async{
    final isValid=_form.currentState!.validate();
    if(!isValid){
      return;
    }
    _form.currentState!.save();
    setState((){
      _isLoading=true;
    });
    if(_editProduct.id!=null){
      await Provider.of<Products>(context,listen: false).updateProduct(_editProduct.id!, _editProduct);

    }else{
      try{
        await Provider.of<Products>(context,listen: false).addProduct(_editProduct);
      }catch(error){
        await showDialog<void>(context: context, builder: (ctx)=> AlertDialog(
          title: const Text('An error occurred!'),
          content: const Text('Something went wrong!'),
          actions: [
            TextButton(
                onPressed: (){Navigator.of(ctx).pop();},
                child: const Text('Close'))
          ],
        ),
        );
      }
      // finally{
      //   setState((){
      //     _isLoading=false;
      //   });
      //   Navigator.of(context).pop();
      // }
    }
    setState((){
      _isLoading=false;
    });
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading?const Center(
        child: CircularProgressIndicator(),
      ):Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                initialValue: _initValues['title'],
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (value){
                  _editProduct=Product(
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite,
                      title: value!,
                      description: _editProduct.description,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please provide a value ';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _initValues['price'],
                decoration: const InputDecoration(
                  labelText: 'Price',
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (value){
                  _editProduct=Product(
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite,
                      title: _editProduct.title,
                      description: _editProduct.description,
                      price: double.parse(value!),
                      imageUrl: _editProduct.imageUrl);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a price ';
                  }if(double.tryParse(value)==null){
                    return 'Please enter a valid number';
                  }
                  if(double.parse(value)<=0){
                    return 'Please enter a number greater than zero';
                  }
                  return null;
                },

              ),
              TextFormField(
                initialValue: _initValues['description'],
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.next,
                focusNode: _descriptionFocusNode,
                onSaved: (value){
                  _editProduct=Product(
                      id: _editProduct.id,
                      isFavorite: _editProduct.isFavorite,
                      title: _editProduct.title,
                      description: value!,
                      price: _editProduct.price,
                      imageUrl: _editProduct.imageUrl);
                },
                validator: (value){
                  if(value!.isEmpty){
                    return 'Please enter a description ';
                  } if(value.length<10){
                    return 'Should be at least 10 characters long';
                  }
                  return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? const Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Image URL',
                      ),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      controller: _imageUrlController,
                      onEditingComplete: () {
                        setState(() {});
                      },
                      focusNode: _imageUrlFocusNode,
                      onFieldSubmitted: (_) {
                        _saveForm();
                      },
                      onSaved: (value){
                        _editProduct=Product(
                            id: _editProduct.id,
                          isFavorite: _editProduct.isFavorite,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: value!,
                        );
                      },
                      validator: (value){
                        if(value!.isEmpty){
                          return 'Please enter an image URL ';
                        }if (!value.startsWith('http') && !value.startsWith('https')){
                          return 'Please enter a valid URL';
                        }if (!value.endsWith('.png') && !value.endsWith('.jpg') && !value.endsWith('.jpeg')){
                          return 'Please enter a valid image URL';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}


