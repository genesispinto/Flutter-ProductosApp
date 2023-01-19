import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  final Widget child;
  const AuthBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children:  [
          const _PurpleBox(),

          const _HeaderIcon(),
          
          child
          
        ]),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: Icon(Icons.person_pin, color: Colors.white, size: 100,),
        ),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _purpleBackground(),
      child: Stack(
        children: const [
          Positioned(top: 90, left: 50,child:  _Buggle(),),
          Positioned(top: -50, left: 50,child:  _Buggle(),),
          Positioned(top: 220, left: 20,child:  _Buggle(),),
          Positioned(top: 150, left: 150,child:  _Buggle(),),
          Positioned(top: 20, left: 200,child:  _Buggle(),),
          
        ]),
    );
  }

  BoxDecoration _purpleBackground() => const BoxDecoration(
    gradient: LinearGradient(
      colors:[
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1),
      ] )
  );
}

// pelotitas blancas
class _Buggle extends StatelessWidget {
  const _Buggle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color.fromRGBO(255, 255, 255, 0.05), ),
        
    );
  }
}