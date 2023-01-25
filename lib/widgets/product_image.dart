import 'dart:io';

import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? url;

  const ProductImage({super.key, this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBoxDecoration(),
      width: double.infinity,
      height: 350,
      child: _BackgroundImage(url: url));
    
      
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
    borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
    color: Colors.black,
    boxShadow:[ 
      BoxShadow(
      color: Colors.black.withOpacity(0.05) ,
      blurRadius: 10,
      offset: const Offset(0,5))]
  );
}

class _BackgroundImage extends StatelessWidget {
  final String? url;
  const _BackgroundImage({
    Key? key, this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return   Opacity(
      opacity: 0.8,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        child: getImage(url)
        
      ),
    );
  }

  Widget getImage( String? picture){


    if(picture == null){
      return const Image(
            image: AssetImage('assets/no-image.png'),
            fit: BoxFit.cover,
            );
    }

    if( picture.startsWith('http')){
      return FadeInImage(
            placeholder: const AssetImage('assets/jar-loading.gif'),
            image: NetworkImage(picture),  
          fit: BoxFit.cover,
           );
    }
    
    return Image.file(
      File(picture),
      fit: BoxFit.cover, 

    );


          
           
  }
}