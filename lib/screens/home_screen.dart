import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/services/services.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
   
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false); 
    final productsService = Provider.of<ProductsServices>(context);
    
    if(productsService.isLoading) return const LoadingScreen();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (() {
            authService.logOut();
            Navigator.pushReplacementNamed(context, 'login');
          } ),
          icon: const Icon(Icons.login_outlined),
          ),
        title: const Center(child:  Text('Productos'))),
      body: ListView.builder(
          itemCount: productsService.products.length,
          itemBuilder: ((context, index) => GestureDetector(
            onTap:() {
              productsService.selectedProduct = productsService.products[index].copy();
              Navigator.pushNamed(context, 'product');

            },   
            child:  ProductCard(product: productsService.products[index],))),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:(() {
            productsService.selectedProduct = Product(
              available: true, 
              name: 'nuevo producto', 
              price: 50);
              Navigator.pushNamed(context, 'product');
          }), 
          child: const Icon(Icons.add) ,
          ),

    );
  }
}