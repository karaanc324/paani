import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:paani/modal/product.dart';
import 'package:paani/modal/puser.dart';

import 'database_service.dart';

class AuthService {
  var auth =  FirebaseAuth.instance;

  AuthService() {
    _intializeMe().then((_) {
      print('=============initializing');
      auth = FirebaseAuth.instance;
    });
  }


  Future<FirebaseApp> _intializeMe() async {
    return await Firebase.initializeApp();
  }

  Future signOut() async {
    try {
      return await auth.signOut().whenComplete(() async {
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signup(String name, String email, String contact, String password,
      String role) async {
    try {
      UserCredential newUser = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = newUser.user;
      await DatabaseService(uid: user?.uid)
          .updateUserDetail(name, email, contact, password, role);
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future login(String email, String password) async {
    try {
      UserCredential newUser = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = newUser.user;
      return _userFromFirebaseUser(user!);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // create user object based on FirebaseUser
  PUser? _userFromFirebaseUser(User user) {
    print("=============");
    print(user);
    return (user != null) ? PUser(uid: user.uid) : null;
  }

  checkUserRole(PUser puser) async {
    return await DatabaseService(uid: puser?.uid).getUserDetail(puser.uid);
  }

  getCurrentUser() {
    print("inside auth");
    print(auth.currentUser);
    return auth.currentUser;
  }

  getProductsOfVendor() {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());
    return DatabaseService(uid: puser?.uid).getProducts();
  }

  getAllVendors() {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());
    return DatabaseService(uid: puser?.uid).getVendors();
  }

  getCart() {
    PUser? puser = _userFromFirebaseUser(getCurrentUser());
    return DatabaseService(uid: puser?.uid).getCart();
  }

  getAddresses() {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());
    return DatabaseService(uid: puser?.uid).getAddresses();  }

  getAddr() {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());
    return DatabaseService(uid: puser?.uid).getAddr();  }



  void addAddress(String name, String contact, String fullAddress, String pincode) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).addAddress(name, contact, fullAddress, pincode);
  }

   checkIfProductInCart(int pid) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).checkIfProductInCart(pid);
  }

   removeProductFromCart(data) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).removeProductFromCart(data);
  }

   addProductToCart(data) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).addProductToCart(data);
  }

  bool addToCart(Product prod) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).addToCart(prod);
  }

  checkCart(String id) {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).checkCart(id);
  }

   clearCart() {
    PUser? puser=  _userFromFirebaseUser(getCurrentUser());

    return DatabaseService(uid: puser?.uid).clearCart();
  }



}