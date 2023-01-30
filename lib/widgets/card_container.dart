import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:provider/provider.dart';

import '../services/services.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size.width*0.8,
        height: 400,
        decoration: _createCardShape(),
        child: Column(
          children: [
              ChangeNotifierProvider(
              create: (_)=> LoginFormProvider(),
              child:const _LoginForm(), ),
              
              const SizedBox(height: 50,),
              TextButton(
                onPressed: (() => Navigator.pushReplacementNamed(context, 'register')), 
                style: ButtonStyle(
                  overlayColor: MaterialStateProperty.all(Colors.indigo.withOpacity(0.1)),
                  shape: MaterialStateProperty.all(const StadiumBorder())
                ),
                child: const Text('Crear una nueva cuenta', style: TextStyle(fontSize: 18, color: Colors.black87),)
                )
          ],
        ),
          
      ),
    );
  }

  BoxDecoration _createCardShape() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color:Colors.grey[200],
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 15,
            offset: Offset(0,5)
          )
        ]);
  }
}
class _LoginForm extends StatelessWidget {
  const _LoginForm({super.key});

  @override
  Widget build(BuildContext context) {

    final loginForm = Provider.of<LoginFormProvider>(context);
    return Form(
      key: loginForm.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  Padding(
                    padding: const EdgeInsets.only(top:15.0),
                    child: Text('Ingreso', style: Theme.of(context).textTheme.headline4,),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                       decoration: InputDecorations.authInputdecoration(
                        hintText: 'example@gmail.com', 
                        labelText: 'Correo Electronico', 
                        prefixIcon: Icons.alternate_email_outlined),
                        onChanged: ((value) => loginForm.email= value),
                        validator: (value) {
                          String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                          RegExp regExp  =  RegExp(pattern);

                          return regExp.hasMatch(value ?? '')
                                  ? null
                                  : 'Por favor ingrese un correcto' ;
                        },
                        ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      autocorrect: false,
                      obscureText: true,
                      decoration: InputDecorations.authInputdecoration(
                        hintText: '********', 
                        labelText: 'Contraseña',
                        prefixIcon: Icons.lock_outline),
                        onChanged: ((value) => loginForm.password= value),
                        validator: (value) {
                          return  value != null && value.length >= 6 
                          ?  null
                          : 'Min 6 digitos';
                        },
                      ),
                  ),
                  const SizedBox(height: 30,),
                  MaterialButton(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    disabledColor: Colors.grey,
                    elevation: 0,
                    color: Colors.deepPurple,
                    onPressed: loginForm.isLoading ? null : (() async {

                      //para quitar el teclado
                      FocusScope.of(context).unfocus();
              
                      if( !loginForm.isValidForm() ) return;
                      loginForm.isLoading = true;

                      // TODO: validar si el login es correcto


                      final authService = Provider.of<AuthService>(context, listen: false);
                      final String? errorMessage = await authService.login(loginForm.email, loginForm.password);

                      if(errorMessage == null){
                        Navigator.pushReplacementNamed(context, 'home');
                      }else{
                         //mostrsr erro en pantalla
                        NotificationsService.showSnackBar(errorMessage);
                        loginForm.isLoading = false;
                      }
                    }),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                      child: Text(
                        loginForm.isLoading
                        ? 'Espere'
                        : 'Entrar', 
                      style: const TextStyle( color: Colors.white),),
                    ))
                ]),
    );
  }
}