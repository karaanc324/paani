import 'package:flutter/material.dart';
import 'package:paani/modal/product.dart';
import 'package:paani/service/database_service.dart';

import '../service/auth_service.dart';

class VendorView extends StatefulWidget {
  const VendorView({Key? key, required this.vendorId}) : super(key: key);
  final String vendorId;

  @override
  State<VendorView> createState() => _VendorViewState();
}

class _VendorViewState extends State<VendorView> {
  get orientation => null;
  int itemCount = 0;
  List cartItems = [];
  bool isButtonDisabled = false;
  final AuthService authService = AuthService();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                          prefixIcon: Padding(
                              padding: EdgeInsets.only(
                                  top: 20), // add padding to adjust icon
                              child: Icon(Icons.search)),
                          border: UnderlineInputBorder(),
                          labelText: 'search product'),
                    )),
                // Expanded(child: ElevatedButton(child: Icon(Icons.search), onPressed: () {
                // },))
              ],
            ),
            Expanded(
              child: FutureBuilder(
                  future: DatabaseService(uid: widget.vendorId).getProducts(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return GridView.builder(
                          itemCount: snapshot.data.length,
                          gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                              (orientation == Orientation.portrait)
                                  ? 2
                                  : 3),
                          itemBuilder: (BuildContext context, int index) {
                            // PUser pUser = jsonDecode(snapshot.data[index]);
                            Map<String, dynamic> values =
                            Map<String, dynamic>.from(snapshot.data[index]);
                            print("999999999");
                            print(values);
                            Product prod = Product(values['pid'], values['name'], values['type'], values['description'], values['price'], values['vendorId']);
                            return Card(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    InkResponse(
                                      child: Text(prod.name),
                                    ),
                                    const SizedBox(height: 42,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                      ],
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          bool addedToCart = false;

                                          await checkIfProductInCart(prod.pid).then((value) => addedToCart = value);
                                          print("wwwwwoowowowowowow");
                                          print(addedToCart);
                                          if (addedToCart) {
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Item already in cart."),
                                            ));
                                          } else {
                                            authService.addToCart(prod);
                                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                              content: Text("Added to cart."),
                                            ));
                                          }
                                        },
                                        child: const Text("Add to cart")),
                                  ],
                                ));
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            // ElevatedButton(onPressed: () {
            //   // itemCount > 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => Cart())) : null;
            //   if (itemCount > 0) {
            //     DatabaseService(uid: widget.vendorId).addToCart(cartItems);
            //     cartItems.clear();
            //   }
            // },
            //   child: Text(itemCount > 0 ? 'Add to cart': 'Add items'), )
          ],
        ),
      ),
    );
  }

  Future<bool> checkIfProductInCart(int pid) {
    var lol = authService.checkIfProductInCart(pid);
    print('karanaa');
    print(lol);
    return lol;
  }

}