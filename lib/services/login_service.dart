
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';

class AuthService extends ChangeNotifier{

  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyC-JpsbtkWb-dzir0q-Sqe303aaI5iwiaI';

  final storage = const  FlutterSecureStorage();

  //si retornamos algo, es un error, sino todo bien 
  Future <String?> createUser(String email, String password) async {

    final Map<String, dynamic> authData = {
      'email':email,
      'password':password,
      'returnSecureToken': true
    };

    //para hacer la peticion POST

    final url = Uri.https(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken
    });

    final resp= await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      //token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      //return decodedResp['idToken'];
      return null;
    }else{
      return decodedResp['error']['message'];
    }
    

  }

  Future <String?> login(String email, String password) async {

    final Map<String, dynamic> authData = {
      'email':email,
      'password':password,
      'returnSecureToken': true
    };

    //para hacer la peticion POST

    final url = Uri.https(_baseUrl, 'v1/accounts:signInWithPassword', {
      'key': _firebaseToken
    });

    final resp= await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if(decodedResp.containsKey('idToken')){
      //token hay que guardarlo en un lugar seguro
      //return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    }else{
      return decodedResp['error']['message'];
    }
    
  }
  Future logOut() async {
    await storage.delete(key: 'token');
    return ;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}