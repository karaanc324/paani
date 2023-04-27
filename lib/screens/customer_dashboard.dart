import 'package:flutter/material.dart';
import 'package:paani/screens/address_screen.dart';
import 'package:paani/screens/login.dart';
import 'package:paani/screens/vendor_view.dart';

import '../service/auth_service.dart';
import '../service/database_service.dart';

class CustomerDashboard extends StatefulWidget {
  const CustomerDashboard({Key? key}) : super(key: key);

  @override
  State<CustomerDashboard> createState() => _CustomerDashboardState();
}

class _CustomerDashboardState extends State<CustomerDashboard> {
  @override
  int selectedIndex = 0;
  final _screens = [
    CustomerDash(),
    CartDash(),
    Settings(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _screens[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

class CustomerDash extends StatelessWidget {
  CustomerDash({
    Key? key,
  }) : super(key: key);

  final AuthService authService = AuthService();

  get orientation => null;

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Container(
          child: Expanded(
            child: FutureBuilder(
              future: authService.getAllVendors(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // print(snapshot.data[0]);
                  if (snapshot.hasData) {
                    return GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3),
                        itemBuilder: (BuildContext context, int index) {
                          // PUser pUser = jsonDecode(snapshot.data[index]);
                          // Map<String, dynamic> values = Map<String, dynamic>.from(snapshot.data[index]);
                          if (snapshot.data[index].get('role') == 'vendor') {
                            return Card(
                              child: InkResponse(
                                  child: Text(snapshot.data[index].get('name')),
                                  onTap: () {
                                    print("-----------------");
                                    authService
                                        .checkCart(
                                            snapshot.data[index].get('uid'))
                                        .then((val) {
                                      if (val) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    VendorView(
                                                        vendorId: snapshot
                                                            .data[index]
                                                            .get('uid'))));
                                      } else {
                                        try {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                "Items in cart from another vendor. Do you wanna remove them?"),
                                            action: SnackBarAction(
                                              label: 'Yes',
                                              onPressed: () {
                                                authService.clearCart();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            VendorView(
                                                                vendorId: snapshot
                                                                    .data[index]
                                                                    .get(
                                                                        'uid'))));
                                              },
                                            ),
                                          ));
                                        } on Exception catch (e, s) {
                                          print(s);
                                        }
                                        // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                        //   content: Text("Items in cart from another vendor. Do you wanna remove them?"),
                                        //   action: SnackBarAction(
                                        //       label: 'Yes', onPressed: () {
                                        //         print("asdadasd");
                                        //         authService.removeProductFromCart(data);
                                        //   },
                                        // ));
                                      }
                                    });
                                  }),
                            );
                          } else {
                            return Container();
                          }
                        });
                  } else {
                    return const Text("Will load up...");
                  }
                  // return Text(snapshot.data.toString());
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Text("No data");
                }
                return const CircularProgressIndicator();
                // return Text("lol");
              },
            ),
          ),
        )
      ],
    );
  }
}

class Settings extends StatelessWidget {
  Settings({
    Key? key,
  }) : super(key: key);
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddressScreen()),
                );
          },
          title: const Text('My Adresses'),
        ),
        ListTile(
          onTap: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                    (route) => false);
          },
          title: const Text('Signout'),
        ),
      ],
    );
  }
}

class CartDash extends StatefulWidget {
  const CartDash({Key? key}) : super(key: key);

  @override
  State<CartDash> createState() => _CartDashState();
}

class _CartDashState extends State<CartDash> {
  final AuthService authService = AuthService();
  var dropdownValue = "home";
  // Map dropdownValue = {};
  late num totalPrice = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // dropdownValue.add('+ Add Address');
    // authService.getAddresses().data();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: StreamBuilder(
              stream: authService.getCart(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.active) {
                  List<dynamic> prodList = snapshot.data['Products'];
                  if(prodList.length == 0) {
                    return Text("No item in cart");
                  }
                  else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: prodList.length,
                              itemBuilder: (BuildContext context, int index) {
                                print(prodList[index]['price']);
                                totalPrice = totalPrice + prodList[index]['price'] * prodList[index]['unit'];
                                return ListTile(
                                  leading: IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      authService.removeProductFromCart(
                                          prodList[index]['pid']);
                                    },
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      authService.addProductToCart(
                                          prodList[index]['pid']);
                                    },
                                  ),
                                  title: Text(prodList[index]['name'] +
                                      '   (' +
                                      prodList[index]['unit'].toString() + ')' + '   Rs: ' + (prodList[index]['price'] * prodList[index]['unit']).toString()) ,
                                  onTap: () {},
                                );
                              }),
                        ),
                        const SizedBox(height: 20),
                        Text('Total Cart Price: $totalPrice'),
                        Align(
                          alignment: Alignment.bottomCenter,
                              child: StreamBuilder(
                                  stream: authService.getAddresses(),
                                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                                    if (snapshot.connectionState == ConnectionState.active) {
                                      List<dynamic> addresses = snapshot.data['addresses'];
                                      // var dropdownValue = addresses[0];
                                      print("22222222222222222222222");
                                      // print(dropdownValue.runtimeType);
                                      return DropdownButton(

                                        value: dropdownValue, // Set the initial value to the first item in the list
                                        onChanged: (newValue) {
                                          print("yqwertyuiop setstate");
                                          print(newValue);
                                           setState(() {
                                            dropdownValue = newValue;
                                          });
                                          print(dropdownValue);
                                        },
                                        items: addresses.map<DropdownMenuItem>((dynamic value) {
                                          print("==================kjhkjxhvjkcsv");
                                          print(value);
                                          return DropdownMenuItem(
                                            value: value['type'],
                                            child: Text(value['name']),
                                          );
                                        }).toList(),);
                                    } else if (snapshot.connectionState == ConnectionState.none) {
                                      return const Text("No data");
                                    }
                                    return const CircularProgressIndicator();
                                  }
                              )
                        ),
                        // DropdownButton(
                        //     items: dropdownValue[0],
                        //     onChanged: (value) {
                        //
                        //     }),
                        ElevatedButton(
                          onPressed: () {
                            if(prodList.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Nothing in cart"),
                              ));
                              print("Nothing in cart");
                            }
                            print('placing the order');
                          },
                          child: const Text('Place Order'),
                        )
                      ],
                    );
                  }
                } else if (snapshot.connectionState == ConnectionState.none) {
                  return const Text("No data");
                }
                return const CircularProgressIndicator();
              }
              // )
              // ],
              ),
        ),
      ],
    );
  }
}
