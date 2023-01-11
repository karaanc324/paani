import 'package:flutter/material.dart';
import 'package:paani/service/database_service.dart';

class VendorView extends StatefulWidget {
  const VendorView({Key? key, required this.vendorId}) : super(key: key);
  final String vendorId;

  @override
  State<VendorView> createState() => _VendorViewState();
}

class _VendorViewState extends State<VendorView> {
  get orientation => null;
  int itemCount = 0;
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
                //   print('search');
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
                            return Card(
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkResponse(
                                  child: Text(values['name']),
                                ),
                                const SizedBox(height: 42,),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (itemCount > 0) {
                                              itemCount--;
                                            }
                                          });
                                        },
                                        child: const Icon(
                                          Icons.remove,
                                          color: Colors.black,
                                          size: 16,
                                        )),
                                    Container(
                                      margin:
                                          const EdgeInsets.symmetric(horizontal: 3),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: Colors.white),
                                      child: Text(
                                        '$itemCount',
                                        style: const TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ),
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            itemCount++;
                                          });
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: Colors.black,
                                          size: 16,
                                        )),
                                  ],
                                ),
                              ],
                            ));
                          });
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            ElevatedButton(onPressed: () {
              // itemCount > 0 ? Navigator.push(context, MaterialPageRoute(builder: (context) => Cart())) : null;
              if (itemCount > 0) {
                DatabaseService(uid: widget.vendorId).addToCart();
              }
            },
              child: Text(itemCount > 0 ? 'Add to cart': 'Add items'), )
          ],
        ),
      ),
    );
  }
}
