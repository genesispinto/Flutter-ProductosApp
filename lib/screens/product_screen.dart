import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/providers/product_form_provider.dart';
import 'package:productos_app/services/services.dart';
import 'package:image_picker/image_picker.dart';

import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final productServices = Provider.of<ProductsServices>(context);

    return ChangeNotifierProvider(
      create: ((context) =>  ProductFormProvider(productServices.selectedProduct)),
      child: _ProductScreenBody(productServices: productServices),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.productServices,
  }) : super(key: key);

  final ProductsServices productServices;

  @override
  Widget build(BuildContext context) {
    final productform = Provider.of<ProductFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, se oculta el teclado al hacer scroll
        child: Column(
          children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Stack(
                  children:   [
                  ProductImage(url: productServices.selectedProduct.picture),
                    Positioned(
                      top:60,
                      right: 30,
                      child: IconButton(
                        onPressed: (() async {
                            final picker = ImagePicker();
                            final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 100
                              );

                              if( pickedFile == null)return;
                              
                              print('Tenemos imagen ${pickedFile.path}');

                              productServices.updateSelectedProductImage(pickedFile.path);
                        }),
                        icon:const Icon(Icons.camera_alt_outlined,  size: 35, color:Colors.white)
                      )
                     ),
                    Positioned(
                      top:60,
                      left: 30,
                      child: IconButton(
                        onPressed: (() => Navigator.of(context).pop()),
                        icon:const Icon(Icons.arrow_back_ios_new,  size: 35, color:Colors.white)
                      ))
                  ],
                ),
              ),
            const _ProductForm(),
            const SizedBox(height: 100,)

          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed:( productServices.isSaving
        ? null
          
        : () async {
         if (!productform.isValidForm()) return;

         final String? imageUrl = await productServices.uploadImage();

        if ( imageUrl != null ) productform.product.picture = imageUrl;

         await productServices.saveOrCreateProduct(productform.product);
        }),
        child: productServices.isSaving
        ? const CircularProgressIndicator(color: Colors.white,)
        : const Icon(Icons.save_outlined), ),
    );
  }
}

class _ProductForm extends StatelessWidget {
  const _ProductForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productform = Provider.of<ProductFormProvider>(context);
    final product = productform.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        decoration: _buildDecoration(),
        child: Form(
          key: productform.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10,),
              TextFormField(
                initialValue: product.name,
                onChanged: ((value) => product.name = value),
                validator: ((value) {
                  if(value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                }),
                decoration: InputDecorations.authInputdecoration(
                  hintText: 'Nombre del producto', 
                  labelText: 'Nombre:'),
              ),
              const SizedBox(height: 10,),
              TextFormField(
                keyboardType: TextInputType.number,
                initialValue: '\$${product.price}',
                inputFormatters: [
                  //expresion regular para numeros
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                //validacion implicita
                onChanged: ((value) {
                  if(double.tryParse(value)== null){
                    product.price = 0;
                  }else{
                    product.price = double.parse(value);
                  }
                  
                } ),
                decoration: InputDecorations.authInputdecoration(
                  hintText: ' \$150.000', 
                  labelText: 'Precio'),
              ),

              const SizedBox(height: 10,),

              SwitchListTile.adaptive(
                activeColor: Colors.indigo,
                value: product.available, 
                onChanged: ((value) => productform.updateAvailability(value)),
                title: const Text('Disponible'),
                ),
                const SizedBox(height: 50,),
            ],
          )),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(25),bottomRight: Radius.circular(25), ),
    boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0,5),
            blurRadius: 10
          )
        ]
  );
}

