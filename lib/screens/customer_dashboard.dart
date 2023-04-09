import 'package:flutter/material.dart';
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
                                    authService.checkCart(snapshot.data[index].get('uid')).then((val) {
                                      if (val) {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => VendorView(
                                                    vendorId: snapshot.data[index]
                                                        .get('uid'))));
                                      } else {
                                        try {
                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                              content: Text("Items in cart from another vendor. Do you wanna remove them?"),
                                            action: SnackBarAction(
                                              label: 'Yes',
                                              onPressed: () {
                                                authService.clearCart();
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => VendorView(
                                                            vendorId: snapshot.data[index]
                                                                .get('uid'))));
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
            authService.signOut();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => Login()),
                (route) => false);
          },
          title: const Text('Signout'),
        )
      ],
    );
  }
}

class CartDash extends StatelessWidget {
  CartDash({
    Key? key,
  }) : super(key: key);
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    // return Column(
    //   children: [
    return FutureBuilder(
        future: authService.getCart(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          leading: IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              authService.removeProductFromCart(
                                  snapshot.data[index]['pid']);
                            },
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              authService.addProductToCart(
                                  snapshot.data[index]['pid']);
                            },
                          ),
                          title: Text(snapshot.data[index]['name'] +
                              '   ->   ' +
                              snapshot.data[index]['unit'].toString()),
                          onTap: () {},
                        );
                        return Column(
                          children: [
                            Row(
                              children: [Text(snapshot.data[index]['name'])],
                            ),
                          ],
                        );
                      }),
                ),
                ElevatedButton(
                  onPressed: () {
                    print('placing the order');
                  },
                  child: const Text('Place Order'),
                )
              ],
            );
          } else if (snapshot.connectionState == ConnectionState.none) {
            return const Text("No data");
          }
          return const CircularProgressIndicator();
        }
        // )
        // ],
        );
  }
}
