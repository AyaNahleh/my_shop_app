import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myshop/providers/auth.dart';
import 'package:provider/provider.dart';
import '../models/http_exception.dart';


enum AuthMode { signUp, logIn }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    // final transformConfig = Matrix4.rotationZ(-8 * pi / 180);
    // transformConfig.translate(-10.0);
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromRGBO(215, 117, 255, 1).withOpacity(0.5),
                  const Color.fromRGBO(255, 188, 117, 1).withOpacity(0.9),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0, 1],
              ),
            ),
          ),
          SingleChildScrollView(
            child: SizedBox(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 20.0),
                      padding:
                          const EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                      transform: Matrix4.rotationZ(-8 * pi / 180)
                        ..translate(-10.0),
                      // ..translate(-10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.deepOrange.shade900,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Colors.black26,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Text(
                        'MyShop',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 50,
                          fontFamily: 'Anton',
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: const AuthCard(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({Key? key,}) : super(key: key);

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.logIn;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  void _showErrorDialog(String message){
     showDialog(context: context, builder: (ctx)=>
     AlertDialog(title: const Text('An Error Occurred!'),
     content: Text(message),
       actions: [
         TextButton(onPressed: (){
           Navigator.of(ctx).pop();
         }, child: const Text('Okay'))
       ],
     ),
     );
  }

  Future<void> _submit() async{
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try{
      if (_authMode == AuthMode.logIn) {
        // Log user in
        await Provider.of<Auth>(context,listen: false).login(_authData['email']!, _authData['password']!);

      } else {
        // Sign user up
        await Provider.of<Auth>(context,listen: false).signup(_authData['email']!, _authData['password']!);
      }
      Navigator.of(context).pushReplacementNamed('/products-overview');
    } on HttpException catch(error){
      var errorMessage='Authenticate failed';
      if(error.toString().contains('EMAIL_EXISTS')){
        errorMessage='This email address is already in use.';
      } else if( error.toString().contains('INVALID_EMAIL') ){
        errorMessage='This is not a valid email address';
      }else if(error.toString().contains('WEAK_PASSWORD')){
        errorMessage='This password is too weak';
      }else if(error.toString().contains('EMAIL_NOT_FOUND')){
        errorMessage='Could not find a user with that email';
      }else if (error.toString().contains('INVALID_PASSWORD')){
        errorMessage='Invalid password';

      }
      _showErrorDialog(errorMessage);

    }
    // catch(e){
    //   const errorMessage='Could not authenticate you. Please try again later.';
    //   _showErrorDialog(errorMessage);
    //
    // }

    setState(() {
      _isLoading = false;
    });
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.signUp ? 320 : 260,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;

                  },
                  onSaved: (value) {
                    _authData['email'] = value!;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;

                  },
                  onSaved: (value) {
                    _authData['password'] = value!;
                  },
                ),
                if (_authMode == AuthMode.signUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.signUp,
                    decoration: const InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: _authMode == AuthMode.signUp
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                const SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all(const TextStyle(
                        color: Colors.white
                      )),
                      backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),

                          )
                      )

                    ),


                    // textColor: Colors.white,
                    child:
                        Text(_authMode == AuthMode.logIn ? 'LOGIN' : 'SIGN UP'),
                  ),
                TextButton(

                  style: TextButton.styleFrom(
                    primary: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 4),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,


                  ),
                  onPressed: _switchAuthMode,

                  child: Text(
                      '${_authMode == AuthMode.logIn ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

