import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class DatabaseService {
  final String? uid;

  DatabaseService({required this.uid});

  Random random = Random();

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  final CollectionReference productCollection =
      FirebaseFirestore.instance.collection('product');
  final CollectionReference cartCollection =
      FirebaseFirestore.instance.collection('cart');

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

  Future addProduct(String name, String type, String description) async {
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

  void addToCart() {

    var doc = cartCollection.doc(uid);
    doc.get().then((docSnapShot) => {
      if (docSnapShot.exists)
        {
          cartCollection.doc(uid).update({
            'Products': FieldValue.arrayUnion([
              {
                'pid': random.nextInt(90),
                'name': name,
                'type': type,
                'description': description,
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
                // 'role': role
                // 'groups': [],
                // 'profilePic': ''
              }
            ])
          })
        }
    });
  }

  // getProductsOfVendor() {
  //
  // }
}
