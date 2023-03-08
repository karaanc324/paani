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
                    'addedToCart': true
                    // 'role': role
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
                    'addedToCart': true
                    // 'role': role
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
      print(docSnapshot.runtimeType);
      print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
      print(docSnapshot.get('Products').runtimeType);
      return docSnapshot.get('Products');
    }
    return null;
  }

  getVendors() async {
    var docSnapshot = await userCollection.get();
    print("tttttttttttttttttttttttt");
    print(docSnapshot.docs.map((e) => e.data()));
    return docSnapshot.docs;
  }

  getCart() async {
    var docSnapshot = await cartCollection.doc(uid).get();
    if (docSnapshot.exists) {
      print(docSnapshot.runtimeType);
      print("qqqqqqqqqqqqqqqqqqqqqqqqqqqqq");
      print(docSnapshot.get('Products').runtimeType);
      print(docSnapshot.get('Products'));
      return docSnapshot.get('Products');
    }
    return null;
  }

  bool addToCart(Product product) {
    bool addedToCart = false;
    var doc = cartCollection.doc(uid);
    doc.get().then((docSnapShot) => {
          if (docSnapShot.exists)
            {
              print("aaaaaaaaaaaaaaaaaaa"),
              print(docSnapShot.get('Products')[0]),
              for (int i = 0; i < docSnapShot.get('Products').length; i++)
                {
                  if (docSnapShot.get('Products')[i]['pid'] != product.pid)
                    {
                      cartCollection.doc(uid).update({
                        'Products': FieldValue.arrayUnion([
                          {
                            'pid': product.pid,
                            'name': product.name,
                            'type': product.type,
                            'description': product.description,
                            'price': product.price,
                            'unit': 1
                            // 'groups': [],
                            // 'profilePic': ''
                          }
                        ])
                      }),
                      addedToCart = true
                    }
                  // else {
                  //   cartCollection.doc(uid).get().then((value) => (docs) {
                  //
                  //   })
                  // }
                }
            }
          // else
          //   {
          //     cartCollection.doc(uid).set({
          //       'Products': FieldValue.arrayUnion([
          //         {
          //           'pid': product.pid,
          //           'name': product.name,
          //           'type': product.type,
          //           'description': product.description,
          //           'price': product.price,
          //           'unit': 1
          //           // 'groups': [],
          //           // 'profilePic': ''
          //         }
          //       ])
          //     }),
          //     addedToCart = true
          //   }
        });
    return addedToCart;
  }

  removeProductFromCart(int pid) {
    bool addedToCart = false;
    var doc = cartCollection.doc(uid);
    doc.get().then((docSnapShot) => {
          if (docSnapShot.exists)
            {
              print("aaaaaaaaaddddaaaaaaaaaa"),
              print(docSnapShot.get('Products')[0]),
              print(docSnapShot.get('Products')[0].runtimeType),
              for (int i = 0; i < docSnapShot.get('Products').length; i++)
                {
                  if (docSnapShot.get('Products')[i]['pid'] == pid)
                    {
                      print("insideeeeeeeeeeeeeeeeeeeeee"),
                      print(docSnapShot.get('Products')[i]),
                      productToUpdate = docSnapShot.get('Products')[i],
                      print(productToUpdate),
                      cartCollection.doc(uid).update({
                        'Products': FieldValue.arrayRemove(
                            [productToUpdate])
                      }),
                      if (productToUpdate['unit'] > 1) {
                        print(productToUpdate['pid']),
                        cartCollection.doc(uid).update({
                          'Products': FieldValue.arrayUnion([
                            {
                              'pid': productToUpdate['pid'],
                              'name': productToUpdate['name'],
                              'type': productToUpdate['type'],
                              'description': productToUpdate
                              ['description'],
                              'price': productToUpdate['price'],
                              'unit': --productToUpdate['unit']
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
          // else
          //   {
          //     cartCollection.doc(uid).set({
          //       'Products': FieldValue.arrayUnion([
          //         {
          //           'pid': product.pid,
          //           'name': product.name,
          //           'type': product.type,
          //           'description': product.description,
          //           'price': product.price,
          //           'unit': 1
          //           // 'groups': [],
          //           // 'profilePic': ''
          //         }
          //       ])
          //     }),
          //     addedToCart = true
          //   }
        });
    return addedToCart;
  }
}

// getProductsOfVendor() {
//
// }
