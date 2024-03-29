import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:paani/modal/product.dart';

class DatabaseService {
  final String? uid;

  var productToUpdate;

  DatabaseService({required this.uid});

  Random random = Random();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

  // Object? get currentQuant => null;
  //
  // set currentQuant(currentQuant) {}

  // get productToUpdate => null;
  //
  // set productToUpdate(productToUpdate) {
  //   productToUpdate = productToUpdate;
  // }

  Future updateUserDetail(String name, String email, String contact,
      String password, String role) async {
    return await userCollection.doc(uid).set({
      'uid': uid,
      'name': name,
      'email': email,
      'password': password,
      'role': role
      // 'groups': [],
      // 'profilePic': ''
    });
  }

  Future getUserDetail(String uid) async {
    var docSnapshot = await userCollection.doc(uid).get();
    if (docSnapshot.exists) {
      return docSnapshot.get('role');
    }
  }

  Future addProduct(
      String name, String type, String description, int price) async {
    var doc = productCollection.doc(uid);
    doc.get().then((docSnapShot) => {
          if (docSnapShot.exists)
            {
              productCollection.doc(uid).update({
                'Products': FieldValue.arrayUnion([
                  {
                    'pid': random.nextInt(90),
                    'name': name,
                    'type': type,
                    'description': description,
                    'price': price,
                    'vendorId': uid
                    // 'groups': [],
                    // 'profilePic': ''
                  }
                ])
              })
            }
          else
            {
              productCollection.doc(uid).set({
                'Products': FieldValue.arrayUnion([
                  {
                    'pid': random.nextInt(90),
                    'name': name,
                    'type': type,
                    'description': description,
                    'price': price,
                    'vendorId': uid
                    // 'groups': [],
                    // 'profilePic': ''
                  }
                ])
              })
            }
        });
  }

  getProducts() async {
    var docSnapshot = await productCollection.doc(uid).get();
    if (docSnapshot.exists) {
      return docSnapshot.get('Products');
    }
    return null;
  }

  getVendors() async {
    var docSnapshot = await userCollection.get();
    return docSnapshot.docs;
  }

  getAddr() {
    return userCollection.doc(uid).get();
  }

  getAddresses() {
    return userCollection.doc(uid).snapshots();
  }

  getCart() {
    // var docSnapshot = await cartCollection.doc(uid).get();
    // if (docSnapshot.exists) {
    //   return docSnapshot.get('Products');
    // }
    // return null;
    return cartCollection.doc(uid).snapshots();
  }

  checkCart(String id) async {
    print(id);
    var docSnapshot = await cartCollection.doc(uid).get();
    if (docSnapshot.exists && docSnapshot.get('Products').length > 0) {
      print("---======-----");
      print(docSnapshot.get('Products'));

      if (docSnapshot.get('Products')[0]['vendorId'] != id) {
        return false;
      }
    }
    print("not hotdog");
    return true;
  }

  bool addToCart(Product product) {
    print('indifr sdd to ct');
    bool addedToCart = false;
    var doc = cartCollection.doc(uid);
    doc.get().then((docSnapShot) => {
          if (docSnapShot.exists)
            {
              checkIfProductInCart(product.pid).then((value) {
                if (value) {
                  addedToCart = true;
                } else {
                  cartCollection.doc(uid).update({
                    'Products': FieldValue.arrayUnion([
                      {
                        'pid': product.pid,
                        'name': product.name,
                        'type': product.type,
                        'description': product.description,
                        'price': product.price,
                        'unit': 1,
                        // 'groups': [],
                        // 'profilePic': ''
                      }
                    ])
                  });
                  addedToCart = true;
                }
              })
              // else {
              //   cartCollection.doc(uid).get().then((value) => (docs) {
              //
              //   })
              // }
            }
          else
            {
              cartCollection.doc(uid).set({
                'Products': FieldValue.arrayUnion([
                  {
                    'pid': product.pid,
                    'name': product.name,
                    'type': product.type,
                    'description': product.description,
                    'price': product.price,
                    'unit': 1,
                    'vendorId': product.vendorId
                    // 'groups': [],
                    // 'profilePic': ''
                  }
                ])
              }),
              addedToCart = true
            }
        });
    return addedToCart;
  }

  removeProductFromCart(int pid) {
    bool addedToCart = false;
    var doc = cartCollection.doc(uid);
    doc.get().then((docSnapShot) => {
          if (docSnapShot.exists)
            {
              for (int i = 0; i < docSnapShot.get('Products').length; i++)
                {
                  if (docSnapShot.get('Products')[i]['pid'] == pid)
                    {
                      productToUpdate = docSnapShot.get('Products')[i],
                      cartCollection.doc(uid).update({
                        'Products': FieldValue.arrayRemove([productToUpdate])
                      }),
                      if (productToUpdate['unit'] > 1)
                        {
                          cartCollection.doc(uid).update({
                            'Products': FieldValue.arrayUnion([
                              {
                                'pid': productToUpdate['pid'],
                                'name': productToUpdate['name'],
                                'type': productToUpdate['type'],
                                'description': productToUpdate['description'],
                                'price': productToUpdate['price'],
                                'unit': --productToUpdate['unit'],
                                'vendorId': productToUpdate['vendorId']
                                // 'groups': [],
                                // 'profilePic': ''
                              }
                            ])
                          }),
                        },
                      addedToCart = true
                    }
                  else
                    {cartCollection.doc(uid).get().then((value) => (docs) {})}
                }
            }
        });
    return addedToCart;
  }

  addProductToCart(int pid) {
    bool addedToCart = false;
    List cartList = [];

    var doc = cartCollection.doc(uid);
    StreamSubscription<DocumentSnapshot>? listener;
    // DatabaseReference cartRef = doc.ref('cart');
    // print("asdasdadasdadasdasdasdasdasdasdasd");
    listener = doc.snapshots().listen((event) {
      //  print("dkajshdasudgisakdfglajskdmasdasdasda"),
      // print(event.get('Products')),
      List cartList = event.get('Products');
      print("aaaaaaaaaaaaaaaaa");
      print(cartList);
      cartList.firstWhere((element) => element['pid'] == pid)['unit'] =
          ++cartList.firstWhere((element) => element['pid'] == pid)['unit'];
      print(cartList);
      doc.update({'Products': cartList}).then((_) {
        // Cancel the stream subscription after updating the database
        listener!.cancel();
      }).catchError((error) {
        // Handle any errors that occur during the update
        print("Error updating cart: $error");
      });
    });
    addedToCart = true;

    // if(addedToCart) {
    //   listener.cancel();
    // }
    // doc.get().then((docSnapShot) => {
    //       if (docSnapShot.exists)
    //         {
    //           // for (int i = 0; i < docSnapShot.get('Products').length; i++)
    //           //   {
    //           //     if (docSnapShot.get('Products')[i]['pid'] == pid)
    //           //       {
    //           //         productToUpdate = docSnapShot.get('Products')[i],
    //           //         cartCollection.doc(uid).update({
    //           //           'Products': FieldValue.arrayRemove([productToUpdate])
    //           //         }),
    //           //         cartCollection.doc(uid).update({
    //           //           'Products': FieldValue.arrayUnion([
    //           //             {
    //           //               'pid': productToUpdate['pid'],
    //           //               'name': productToUpdate['name'],
    //           //               'type': productToUpdate['type'],
    //           //               'description': productToUpdate['description'],
    //           //               'price': productToUpdate['price'],
    //           //               'unit': ++productToUpdate['unit'],
    //           //               'vendorId': productToUpdate['vendorId']
    //           //               // 'groups': [],
    //           //               // 'profilePic': ''
    //           //             }
    //           //           ])
    //           //         }),
    //           //         addedToCart = true
    //           //       }
    //           //     else
    //           //       {cartCollection.doc(uid).get().then((value) => (docs) {})}
    //           //   }
    //           cartList = docSnapShot.get('Products'),
    //           // print(cartList.firstWhere((element) => element['pid'] == pid)['unit']),
    //
    //           cartList.firstWhere((element) => element['pid'] == pid)['unit'] = ++cartList.firstWhere((element) => element['pid'] == pid)['unit'],
    //           print("naaaaaaaaaaaa"),
    //           print(cartList)
    //         }
    //
    //       // else
    //       //   {
    //       //     cartCollection.doc(uid).set({
    //       //       'Products': FieldValue.arrayUnion([
    //       //         {
    //       //           'pid': product.pid,
    //       //           'name': product.name,
    //       //           'type': product.type,
    //       //           'description': product.description,
    //       //           'price': product.price,
    //       //           'unit': 1
    //       //           // 'groups': [],
    //       //           // 'profilePic': ''
    //       //         }
    //       //       ])
    //       //     }),
    //       //     addedToCart = true
    //       //   }
    //     });
    // print("haaaaaaaaaaa");
    // print(cartList);
    // doc.update({
    //   'Products': cartList
    // });
    return addedToCart;
  }

  Future<bool> checkIfProductInCart(int pid) async {
    // var docSnapshot = await cartCollection.doc(uid).get();
    // if (docSnapshot.exists) {
    //   var products = docSnapshot.get('Products');
    //   for(int i = 0; i < products.length; i++) {
    //     if (products[i]['pid'] == pid) {
    //       return true;
    //     }
    //   }
    // }
    // return false;
    bool addedToCart = false;
    var doc = cartCollection.doc(uid);
    print("aamaa");
    await doc.get().then((docSnapShot) {
      if (docSnapShot.exists) {
        print('wow');
        for (int i = 0; i < docSnapShot.get('Products').length; i++) {
          if (docSnapShot.get('Products')[i]['pid'] == pid) {
            print('avni');
            print(pid);
            print(docSnapShot.get('Products')[i]);
            addedToCart = true;
            break;
          }
        }
      }
    });
    print("final");
    print(addedToCart);
    return addedToCart;

    //   await cartCollection.doc(uid).get().then((docSnapshot) => {
    //   if (docSnapshot.exists) {
    //   var products = docSnapshot.get('Products'),
    //   for(int i = 0; i < products.length; i++) {
    //     if (products[i].get('pid') == pid) {
    //       return true;
    //     }
    //   }
    //   return false;
    // }
    //   });
  }

  Future<void> clearCart() async {
    await cartCollection.doc(uid).delete();
  }

  addAddress(String name, String contact, String fullAddress, String pincode) {
    print('inside add address========');
    return userCollection.doc(uid).set({
      'addresses': FieldValue.arrayUnion([
        {
          'name': name,
          'contact': contact,
          'fullAddress': fullAddress,
          'pincode': pincode
        }
      ])
    }, SetOptions(merge: true));
  }
}

// getProductsOfVendor() {
//
// }
