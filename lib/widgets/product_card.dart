import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';

class ProductCard extends StatelessWidget {

  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(top: 30, bottom: 50),
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children:  [
             _BackgroundImage(url: product.picture),
              _ProductDetails(name: product.name, id: product.id),
            
           Positioned(
              top: 0,
              right: 0,
              child: _PriceTag(price: product.price)),
            if(!product.available)
            const Positioned(
              top: 0,
              left: 0,
              child: _NotAvailable()),

          ]),  
      ),
    );
  }

  BoxDecoration _cardBorders() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(0,5),
            blurRadius: 10
          )
        ]
        );
  }
}

class _NotAvailable extends StatelessWidget {

  const _NotAvailable({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 100,
      height: 70,
      decoration: BoxDecoration(
      borderRadius: 
      const BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25)),
      color: Colors.yellow[800],
    ),
      child:  const FittedBox(
            fit: BoxFit.contain,
            child:  Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10),
            child:  Text('No Disponible', 
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
    );
  }
}

class _PriceTag extends StatelessWidget {
  final double price;

  const _PriceTag( {
    Key? key, required this.price 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
          alignment: Alignment.center,
          width: 100,
          height: 70,
          decoration: _buildBoxDecoration(),
        child: 
           FittedBox(
            fit: BoxFit.contain,
          child:  Padding(
            padding:  const EdgeInsets.symmetric(horizontal: 10),
            child:  Text(
              '\$$price', 
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
          ),
        ),
         
    );
  }
  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      borderRadius: 
      BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Colors.indigo,
    );
  }
}



class _ProductDetails extends StatelessWidget {
  final String? id;
  final String name;
  const _ProductDetails({
    Key? key,  this.id, required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                width: double.infinity,
                height: 70,
                decoration: _buildBoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  [
                    Text(
                    name, 
                    style: const TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold, ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5,),
                    Text( id != null ?
                    id! : 'Producto sin id', 
                    style: const TextStyle(fontSize: 15, color: Colors.white ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    ),

                  ]),
              ),
    );
  }

  BoxDecoration _buildBoxDecoration() {
    return const BoxDecoration(
      borderRadius: 
      BorderRadius.only(bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Colors.indigo,
    );
  }
}

class _BackgroundImage extends StatelessWidget {

  final String? url;
  const _BackgroundImage({
    Key? key, required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child:  SizedBox(
        width: double.infinity,
        height: 400,
        child: url == null 
        ? const Image(
          image: AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
          )
        
         : FadeInImage(
          placeholder: const AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(url!),
          fit: BoxFit.cover,
           ),
      ),
    );
  }
}