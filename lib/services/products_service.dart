

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

class ProductsServices extends ChangeNotifier {

  final String _baseUrl = 'flutter--product-default-rtdb.firebaseio.com';
  final List<Product> products= [];
  late Product selectedProduct;

  final storage = const  FlutterSecureStorage();
  
  File? newPictureFile;
  
  bool isLoading = true;
  bool isSaving = false;

  ProductsServices(){
    loadProducts();
  }


//<List<Product>>
  Future <List<Product>> loadProducts() async {

      isLoading = true;
      notifyListeners();

      final url = Uri.https(_baseUrl, 'products.json',{
        'auth': await storage.read(key: 'token') ?? ''
      });
      final resp = await http.get(url);

      final Map<String, dynamic> productsMap = json.decode(resp.body);
        
        productsMap.forEach((key, value) {
        final tempProduct = Product.fromJson(value);
        tempProduct.id = key;
        products.add(tempProduct); 
     });
      //products tiene una lista con el id y la informacion 
     //print(products[0].name);


      isLoading = false;
      notifyListeners();
      return products;
  }
   
   Future saveOrCreateProduct (Product product) async {

    isSaving = true;
    notifyListeners();

    if(product.id == null){
      await createProduct(product);
    }else{
      //hay que actualizar
      await updateProduct(product);
    }



    isSaving = false;
    notifyListeners();
   }
    Future <String> updateProduct (Product product) async {
      final url = Uri.https(_baseUrl, 'products/${product.id}.json',{
        'auth': await storage.read(key: 'token') ?? ''
      });
      final resp = await http.put(url, body: product.toRawJson(),);

      final decodeData = resp.body;


      //Actualizar producto manera genesis
      /* products.forEach((element) {

        if( element.id == product.id){
            element.name = product.name;
            element.picture = product.picture;
            element.price = product.price;
            element.available = product.available;          
        }
       }); */

      //Actualizar el producto manera prof
      final index = products.indexWhere((element) => element.id == product.id);
      products[index]= product;



      return product.id!;
    }

    Future <String> createProduct(product) async {

      final url = Uri.https(_baseUrl, 'products.json',{
        'auth': await storage.read(key: 'token') ?? ''
      });
      final resp = await http.post(url, body: product.toRawJson());
        // decodeData contiene el id del producto
      final decodeData = json.decode(resp.body);

      product.id = decodeData['name'];
      
      products.add(product);



      return product.id!;
    }

     void updateSelectedProductImage (String path){

      selectedProduct.picture = path;
      newPictureFile = File.fromUri(Uri(path: path));

      notifyListeners();
    }

    Future <String?> uploadImage() async {
      if(newPictureFile == null) return null;

      isSaving = true;
      notifyListeners();

      final url = Uri.parse('https://api.cloudinary.com/v1_1/dmhayxlfi/image/upload?upload_preset=ndxr37vx');

      final imageUploadRequest = http.MultipartRequest('POST', url);

      final file = await http.MultipartFile.fromPath('file', newPictureFile!.path);

      imageUploadRequest.files.add(file);

      final streamResponse = await imageUploadRequest.send();
      final resp = await http.Response.fromStream(streamResponse);

      if( resp.statusCode != 200 && resp.statusCode != 201){
        print(resp.body);
        return null;
      }

      newPictureFile= null;

      final decodedData = json.decode(resp.body);
      return decodedData['secure_url'];

    } 
}