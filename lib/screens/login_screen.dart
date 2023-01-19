import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';


class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return  Scaffold(
      body: AuthBackground(
        child: CardContainer(size: size),
      )
    );
  }
}

